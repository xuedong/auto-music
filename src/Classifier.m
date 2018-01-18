classdef Classifier
    
	methods (Static)

        function [ ngrams, before ] = ngram( sequence, n )
        		% Returns the set of n-grams of [sequence], including m-grams (m<n) "prefixes" for the beginning of the sequence.
            ngrams = [arrayfun(@(x) sequence(1:x), 1:(n-1), 'UniformOutput', false), arrayfun(@(x) sequence(x: x+n-1), 1:(length(sequence)-n+1), 'UniformOutput', false)] ;
        end 

        function [ ngrams, before ] = ngrams_fs( sequence, n )
        		% Returns the set of n-grams of [sequence] of fixed size n.
            ngrams = arrayfun(@(x) sequence(x: x+n-1), 1:(length(sequence)-n+1), 'UniformOutput', false) ;
        end 
        
        function [ model ] = build_language_model( training_sequences, n, pseudo_count, pc_args, size_alphabet )
			import Utils.get_def;

        	% Build language model for the set of [training_sequences] using [pseudo_count] strategy.
            model = {} ;
            model.n = n ;
            model.pc_args = pc_args ;
            % Keys/ngrams dictionary
            model.key_to_gram = {} ;
            model.key_to_gram{n} = containers.Map('KeyType', 'char', 'ValueType', 'any') ;
			% Counts for ngrams
            model.counts = {} ;
            model.counts{n} = containers.Map('KeyType', 'char', 'ValueType', 'int32') ;
            % Counts for premisses
            model.pre = {};
            model.pre{n} = containers.Map('KeyType', 'char', 'ValueType', 'int32') ;
			model.probabilities = containers.Map('KeyType', 'char', 'ValueType', 'double') ;
            % Keys and counts for lower-order (interpolation/back-off only)
           	if strcmp(pseudo_count, 'back-off') || strcmp(pseudo_count, 'interpolation')
           		for i = 1:(model.n-1)
            		model.key_to_gram{i} = containers.Map('KeyType', 'char', 'ValueType', 'any') ;
            		model.counts{i} = containers.Map('KeyType', 'char', 'ValueType', 'int32') ;
            		model.pre{i} = containers.Map('KeyType', 'char', 'ValueType', 'int32') ;
            	end
            end
            % Count occurrences of ngrams
            for sequence = training_sequences
                % Count occurences of all n-grams (and lower-order prefixes)
                ngrams = Classifier.ngram(sequence{1}, n) ;
                for gram = ngrams % For all n-grams of all training sequences
                	s_gram = Utils.hash(gram{1});
                    if ~ model.key_to_gram{n}.isKey(s_gram)
                        model.key_to_gram{n}(s_gram) = gram{1} ; % add it if not seen before.
                    end
                    model.counts{n}(s_gram) = Utils.get_def(model.counts{n}, s_gram) + 1 ; % increment count
                end   

            	% If using back-off or interpolation, we need to calculate occurrences
            	% for lower-order grams.
            	if strcmp(pseudo_count, 'back-off') || strcmp(pseudo_count, 'interpolation')
            		for k = 1:(model.n-1)
            	    	ngrams_k = Classifier.ngrams_fs(sequence{1}, k); % Calculate k-grams for k<n
            	    	for gram = ngrams_k
            	    		s_gram = Utils.hash(gram{1});
                			if ~ model.key_to_gram{k}.isKey(s_gram)
                			    model.key_to_gram{k}(s_gram) = gram{1} ; % add it if not seen before.
                			end
                		    model.counts{k}(s_gram) = Utils.get_def(model.counts{k}, s_gram) + 1 ; % increment count
            	    	end
            	    end
            	end

            end
            % Calculate occurrence
            for key = model.key_to_gram{n}.keys
                gram = model.key_to_gram{n}(key{1}) ;
                pre = gram(1:length(gram)-1) ; % premisse (first n-1 terms of the n-gram)
                if ~isempty(pre); s_pre = Utils.hash(pre); else; s_pre = ''; end;
                model.pre{n}(Utils.hash(pre)) = Utils.get_def(model.pre{n}, s_pre) + model.counts{n}(key{1}) ;
            end

            if strcmp(pseudo_count, 'back-off') || strcmp(pseudo_count, 'interpolation')
            	% If using back-off or interpolation, we also need to count occurrences of 
            	% premisses for lowe-order models.
            	for k = 1:(model.n-1)
            		for key = model.key_to_gram{k}.keys
            		    gram = model.key_to_gram{k}(key{1}) ;
            		    pre = gram(1:length(gram)-1) ; % premise (first n-1 terms of the n-gram)
                		if ~isempty(pre); s_pre = Utils.hash(pre); else; s_pre = ''; end;
            		    % Add the number of occurrence of the ngram to the nb. of 
            		    % occurrences of the premisse
            		    model.pre{k}(s_pre) = Utils.get_def(model.pre{k}, s_pre) + model.counts{k}(key{1}) ;
            		end
            	end
            end

            model.probabilities = @(gram) Classifier.gram_probability(gram, model, pseudo_count, size_alphabet) ;
        end
        
        function [ p ] = gram_probability(gram, model, pseudo_count, size_alphabet)

			import Utils.get_def;
			import Utils.hash;
        	n = model.n ;

        	% Calculates the probability of a n-gram [gram] using the language model [model].
            if strcmp(pseudo_count, 'none')

                key = Utils.hash(gram) ;
                if model.counts{n}.isKey(key)
                    pre = gram(1:length(gram)-1) ;
                	if ~isempty(pre); s_pre = Utils.hash(pre); else; s_pre = ''; end;
                    p = double(model.counts{n}(key))/double(model.pre{n}(s_pre)) ;
                else
                    p = 0;
                end
                
            elseif strcmp(pseudo_count, 'simple') % Use +1 pseudocount

                key = Utils.hash(gram) ;
                a = Utils.get_def(model.counts{n}, key) + 1 ;
                pre = gram(1:length(gram)-1) ; % premisse
                if ~isempty(pre); s_pre = Utils.hash(pre); else; s_pre = ''; end;
                b = Utils.get_def(model.pre{n}, s_pre) + size_alphabet ;
                p = double(a)/double(b) ;

            elseif strcmp(pseudo_count, 'back-off')

				a = 0;
                b = 0;
                l = length(gram);
                key = Utils.hash(gram) ;
                pre = gram(1:l-1) ; % premisse
                if ~isempty(pre); s_pre = Utils.hash(pre); else; s_pre = ''; end;
                if model.counts{n}.isKey(key) % Use ngram proba, if existing
                    a = model.counts{n}(key) ;
                	b = Utils.get_def(model.pre{n}, s_pre) ;
                else % otherwise, try to use lower-order
                	for k = 2:l
                		gram_ok = gram(k:l) ; % gram of order k
                		pre_ok = gram_ok(1:length(gram_ok)-1);
                		key_ok = Utils.hash(gram_ok) ; % associated key
                		if ~isempty(pre_ok); s_pre_ok = Utils.hash(pre_ok); else; s_pre_ok = ''; end;
						order = l-k+1;
                		if model.counts{order}.isKey(key_ok)
                			a = model.counts{order}(key_ok);
                			b = model.pre{order}(s_pre_ok);
                			break;
                		end
                	end
                	if isfield(model.pc_args, 'alpha')
                		alpha_back_off = model.pc_args.alpha ;
                	else
                		alpha_back_off = 1 ;
                	end
                	a = alpha_back_off*a;
                end
                p = double(a+1)/double(b+size_alphabet) ;

            elseif strcmp(pseudo_count, 'back-off')

            end
        end


        function [ model ] = build_language_model_mixed( training_sequences, n, pseudo_count, pc_args, size_alphabet )
			import Utils.get_def;
			import Utils.hash;

			fld = 'cache/';
			hash_train = DataHash(training_sequences);
			filename = strcat(fld, 'mixed_', hash_train, '.mat');
			if 0&&exist(filename) % If it exists, load from cache
				cache = load(filename);
				model = cache.model;
			else
        		% Build language model for the set of [training_sequences] using [pseudo_count] strategy.
            	model = {} ;
            	model.n = n ;
            	model.pc_args = pc_args ;
            	% Keys/ngrams dictionary
            	model.key_to_gram = {} ;
				% Counts for ngrams
            	model.counts = {} ;
            	% Counts for premises
            	model.pre = {} ;
            	% Good-Turing discounting
            	model.counts_gt = {};
            	model.pre_gt = {};
            	% Probas
            	model.probabilities = containers.Map('KeyType', 'char', 'ValueType', 'double') ;

            	% Keys and counts initialization
           		for i = 1:n
            		model.key_to_gram{i} = containers.Map('KeyType', 'char', 'ValueType', 'any') ;
            		model.counts{i} = containers.Map('KeyType', 'char', 'ValueType', 'int32') ;
            		model.counts_gt{i} = containers.Map('KeyType', 'char', 'ValueType', 'double') ;
            		model.pre{i} = containers.Map('KeyType', 'char', 'ValueType', 'int32') ;
            		model.pre_gt{i} = containers.Map('KeyType', 'char', 'ValueType', 'double') ;
            		model.nb_seen{i} = 0;
            	end

            	% Count occurrences of ngrams
				for i = 1:numel(training_sequences)
					sequence = training_sequences{i};
            	    % Count occurences of all n-grams (and lower-order prefixes)
            		for k = 1:n
            			ngrams_k = Classifier.ngrams_fs(sequence, k); % Calculate k-grams for k<n
            			for gram = ngrams_k
            				s_gram = Utils.hash(gram{1});
							%fprintf('%s\n', s_gram);
            	    		if ~ model.key_to_gram{k}.isKey(s_gram)
            	    		    model.key_to_gram{k}(s_gram) = gram{1} ; % add it if not seen before.
            	    		end
            	    	    model.counts{k}(s_gram) = Utils.get_def(model.counts{k}, s_gram) + 1 ; % increment count
            			end
            		end
            	end
            	model.counts_uni = 0;
            	for key = keys(model.counts{1})
            		model.counts_uni = model.counts_uni + model.counts{1}(key{1});
            	end

				% Premises counts & Good-turing
            	for k = 1:n
                	% Counts for GT
                	l = 5000; % Just need something big enough.
                	nb_gt = zeros(l, 1) ;
                	c_star = zeros(l, 1) ;
            		for key = model.key_to_gram{k}.keys
            		    gram = model.key_to_gram{k}(key{1}) ;
						count = model.counts{k}(key{1});
            		    pre = gram(1:length(gram)-1) ; % premise (first n-1 terms of the n-gram)
            			if ~isempty(pre); s_pre = Utils.hash(pre); else; s_pre = ''; end;
            		    % Add the number of occurrence of the ngram to the nb. of 
            		    % occurrences of the premisse
            		    model.pre{k}(s_pre) = Utils.get_def(model.pre{k}, s_pre) + count ;
            			% GT discounting
            			if count>l
            				disp(count)
            			end
                        nb_gt(count) = nb_gt(count)+1;
            		end
					% Compute GT new weigths
					for i=1:length(nb_gt)-1
						c_star(i) = (i+1)*nb_gt(i+1)/nb_gt(i); % New count
					end
					%c_star'
					% Update 
            		for key = model.key_to_gram{k}.keys
            		    gram = model.key_to_gram{k}(key{1}) ;
						count = model.counts{k}(key{1});
						new_count = c_star(count);
						model.counts_gt{k}(key{1}) = new_count; % memorize GT counts
						% Then update premisses GT counts
            		    pre = gram(1:length(gram)-1) ; % premise (first n-1 terms of the n-gram)
            			if ~isempty(pre); s_pre = Utils.hash(pre); else; s_pre = ''; end;
            			model.pre_gt{k}(s_pre) = Utils.get_def(model.pre_gt{k}, s_pre) + new_count;
            			model.nb_seen{k} = model.nb_seen{k}+1;
            		end
            		% In the computation of premisses GT counts, 
            		% we also need to count ngrams that had occurence 0 before.
            		N1 = c_star(1);
            		N0 = size_alphabet^k-numel(model.counts{k}.keys);
            		for key = model.pre_gt{k}.keys
						model.pre_gt{k}(key{1}) = model.pre_gt{k}(key{1})...
							+ (size_alphabet-model.nb_seen{k})*N1/N0;
            		end
            	end

				save(filename, 'model'); % cache model
			end

            model.probabilities = @(gram) Classifier.gram_probability_mixed(gram, model, pseudo_count, size_alphabet) ;
        end

        function [ p ] = gram_probability_mixed(gram, model, pseudo_count, size_alphabet)
        	n = model.n ;
        	l = length(gram);

        	% Calculates the probability of a n-gram [gram] using the language model [model].
            if strcmp(pseudo_count, 'simple') % Use +1 pseudocount

                key = Utils.hash(gram) ;
                a = Utils.get_def(model.counts{l}, key);
                pre = gram(1:length(gram)-1) ; % premisse
                if ~isempty(pre); s_pre = Utils.hash(pre); else; s_pre = ''; end;
                b = Utils.get_def(model.pre{l}, s_pre);
                p = double(a+model.pc_args.m)/double(b+(size_alphabet+1)*model.pc_args.m) ;

            elseif strcmp(pseudo_count, 'good-turing')

                key = Utils.hash(gram) ;
                a = Utils.get_def(model.counts_gt{l}, key);
                pre = gram(1:length(gram)-1) ; % premisse
                if ~isempty(pre); s_pre = Utils.hash(pre); else; s_pre = ''; end;
                b = Utils.get_def(model.pre_gt{l}, s_pre);
                p = double(a)/double(b) ;

			elseif strcmp(pseudo_count, 'back-off')

				a = 0;
				b = 0;
				key = Utils.hash(gram) ;
				pre = gram(1:length(gram)-1) ; % premisse
				if ~isempty(pre); s_pre = Utils.hash(pre); else; s_pre = ''; end;
                count = 1 ;
				if model.counts{l}.isKey(key) % Use ngram proba, if existing
					a = model.counts{l}(key) ;
					b = Utils.get_def(model.pre{l}, s_pre) ;
				else % otherwise, try to use lower-order            
					for k = 2:l
                        count = count+1 ;
						gram_ok = gram(k:l) ; % gram of order k
						pre_ok = gram_ok(1:length(gram_ok)-1);
						key_ok = Utils.hash(gram_ok) ; % associated key
						if ~isempty(pre_ok); s_pre_ok = Utils.hash(pre_ok); else; s_pre_ok = ''; end;
						order = l-k+1;
						if model.counts{order}.isKey(key_ok)
							a = model.counts{order}(key_ok);
							b = model.pre{order}(s_pre_ok);
							break;
						end
					end
                end      
                if a == 0
                	p = 0;
                else
					p = (double(a+model.pc_args.m)/double(b+(size_alphabet+1)*model.pc_args.m))*(model.pc_args.alpha^count) ;
				end
            elseif strcmp(pseudo_count, 'interpolation')
                p = double(model.pc_args.lambda0)/double(size_alphabet+1);
                for k = 1:l
                    key_gram = Utils.hash(gram(l-k+1:l));
                    key_pre = Utils.hash(gram(l-k+1:l-1));
                    if model.counts{k}.isKey(key_gram)
                        p = p + double(model.pc_args.lambda(k))*double(Utils.get_def(model.counts{k}, key_gram))/double(Utils.get_def(model.pre{k}, key_pre));
                    end
                    %p
                end
                %p = double(p);
            end
        end

        function [ p ] = sequence_probability(model, sequence)
        	% Returns the probability of a sequence.
            ngrams = Classifier.ngram( sequence, model.n ) ;
            p = 1.0 ;
            for gram = ngrams
                p = p * model.probabilities(gram{1}) ;
            end
        end

	end % methods (Static)

end
