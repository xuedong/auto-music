classdef Generation

	methods (Static)

		function r = gen_seqs(model_type, parameters, cv_data, nb_seqs, len)
            X = cv_data.X{1};
            Y = cv_data.y;
            nb_classes = cv_data.nb_classes;
            if strcmp(model_type,'lm_mix')
            	parameters.size_alphabet = parameters.size_alphabet{1};
            end
            models = Learning.train(X, Y, model_type, nb_classes, parameters) ;
            r = {};

            data = cv_data.data{1};

			if strcmp(model_type, 'lm_mix')

				for i=1:length(models)
					r{i} = {};
					m = models{i}; % model of class i
					for seq_num = 1:nb_seqs
						pitch = zeros(1,len);
						duration = zeros(1,len);
						pre = [];
						ngram = [];
						for k=1:len
							if length(ngram)==m.n
								pre = ngram(2:end);
							else
								pre = ngram;
							end

							%if ~isempty(pre)
								%val_pre = data.key_to_value(pre(1));
								%fprintf('Premisse: %d, i.e. pitch=%d, value=%.2f\n', pre, data.key_to_pitch(val_pre(1)), data.key_to_duration(val_pre(2)));
							%end

							sz = length(pre)+1;
							fk = @(key) Utils.get_def(m.counts{sz}, Utils.hash([pre, key]));
							counts = arrayfun(fk, 1:data.size_alphabet); % calc. probas for arr possible ngrams
							counts_cum = [0, cumsum(counts)];
							counts_tot = counts_cum(end); % total count
							%fprintf('counts_tot: %d\n', counts_tot);
							%counts
							if counts_tot < 1
								pitch = pitch(1,1:k-1);
								duration = duration(1,1:k-1);
								break;
							else
								rd = randi([1 counts_tot]);
								sel_key = sum(rd>counts_cum); % randomly generated key
 								value = data.key_to_value(sel_key);
								pitch(k) = data.key_to_pitch(value(1));
								duration(k) = data.key_to_duration(value(2));
								ngram = [pre, sel_key];
							end
						end
						r{i}{seq_num} = {};
						r{i}{seq_num}{1} = pitch;
						r{i}{seq_num}{2} = duration;
					end
				end

			elseif strcmp(model_type, 'rpni') || strcmp(model_type, 'edsm') || strcmp(model_type, 'ktsi')

				for m = 1:length(models)
					%disp(models{m}.TransitionMatrix)
					%pause
					r{m} = {};
					for seq_num = 1:nb_seqs
						%disp(models{1}.Alphabets)
						start_state = models{m}.FiniteSetOfStates;
						pitch = zeros(1,len);
						duration = zeros(1,len);
						tm = models{m}.TransitionMatrix;
						init_state = models{m}.InitialState;
						cur_state = init_state;
						for k = 1:len
							cur_row = tm(cur_state,:);
							pos_vals = find(cur_row);
							s = randi([1 length(pos_vals)]);
							trans = models{m}.Alphabets(pos_vals(s));
							cur_state = cur_row(pos_vals(s));
							% Encode!
 							value = data.key_to_value(trans);
							pitch(k) = data.key_to_pitch(value(1));
							duration(k) = data.key_to_duration(value(2));
						end
						r{m}{seq_num} = {};
						r{m}{seq_num}{1} = pitch;
						r{m}{seq_num}{2} = duration;
					end
				end

			end
        end % gen_seqs

	end % methods (Static)

end
