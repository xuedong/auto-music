classdef Utils
	methods (Static)

		function r = get_def(m, key)
			r = int32(0);
			if m.isKey(key)
				r = m(key);
			end
		end

		function [precision, recall] = pre_rec(confusion_matrix)
			precision = diag(confusion_matrix)./sum(confusion_matrix)';
            precision(isnan(precision)) = 1 ;
			recall = diag(confusion_matrix)./sum(confusion_matrix,2);
            recall(isnan(recall)) = 0 ;
		end


		function wrapper = get_datasets(learn_beg, learn_end, seq_type, ext)
		% [wrapper] is a cell array (length(seq_type)) of cell array (3 classes) of cell arrays (l_sz sequences)
			if nargin < 4
				ext = 'imp';
			end
			if nargin < 3
				seq_type = {'product'};
			end

			if strcmp(ext, 'imp')
				root = 'music/implicita/';
			elseif strcmp(ext, 'dif')
				root = 'music/diferencial/';
			end

			classes = {'bach', 'gre', 'scot'} ;
			l_sz = learn_end - learn_beg + 1 ;

			wrapper = {};
			for t = 1:length(seq_type)
				datasets = cell(length(classes), 1) ;
				data = {};
				for i = 1:length(classes)
				    dataset = cell(l_sz, 1) ;
				    for j = learn_beg:learn_end
				        path = strcat(root, classes{i}, '/', classes{i}, num2str(j,'%02d'), '.', ext) ;
				        [pitch, duration] = Parser(path) ;
				        [s, data] = Convert.transform_to_symbol_sequence(pitch, duration, seq_type{t}, data) ;
				        dataset{j-learn_beg+1} = s ;
                    end
                    datasets{i} = dataset ;
                end
                    if strcmp(seq_type{t},'sum')
                        newdatasets = cellfun(@(dataset) cellfun(@(sequence) Convert.product_sequence_to_sum_sequence(sequence, data),dataset,'UniformOutput',false),datasets,'UniformOutput',false);                        
                        wrapper{t}{1} = newdatasets;
                        data.size_alphabet = data.actual_key_duration + data.actual_key_pitch - 2 ;
                        wrapper{t}{2} = data;
                    else
                        wrapper{t}{1} = datasets;
                        wrapper{t}{2} = data;
                    end
			end
		end

		function params = gen_params_lm(n, data, pc, pc_args)
			% Generates params of a language model.
			params.n = n ;
			params.pseudo_count = pc;
			params.size_alphabet = {};            
			if nargin < 4
                params.pseudo_count_args.m = 1;
                params.pseudo_count_args.alpha = 1;
                params.pseudo_count_args.lambda = ones(1,n)/(n+1);
                params.pseudo_count_args.lambda0 = 1/(n+1);
            else                
                if ~isfield(pc_args, 'm')
                    pc_args.m = 1 ;
                end
                if ~isfield(pc_args, 'alpha')
                    pc_args.alpha = 1 ;
                end                
                if ~isfield(pc_args, 'lambda')
                    pc_args.lambda = ones(1,n)/(n+1);
                end                
                if ~isfield(pc_args, 'lambda0')
                    pc_args.lambda0 = 1/(n+1);
                end                
                params.pseudo_count_args = pc_args ;
            end
			for i = 1:length(data)
				params.size_alphabet{i} = data{i}{2}.size_alphabet;
            end
            params.allow_reject = false;
        end
        
        function params = gen_params_rpni(allow_reject, params)
            params.allow_reject = allow_reject;
        end
                
        function params = gen_params_edsm(allow_reject, params)
            params.allow_reject = allow_reject;
        end        
        
        function params = gen_params_ktsi(k,allow_reject, params)
            params.k = k;
            params.allow_reject = allow_reject;
        end
                
        function params = gen_params_alergia(alpha, t0)
            params.alpha = alpha;
            params.t0 = t0;
            params.allow_reject = false;
        end
        
		function res = add_prt(res, label, precision, recall, time)
			res{end+1}{1} = label;
			res{end}{2} = precision;
			res{end}{3} = recall;
			if nargin > 4
				res{end}{4} = time;
			end
		end

		function disp_results(res)
			l_nbrs = 5;
			l_lbl = 10;
			nb_values = 8;
			max_vals = zeros(1, nb_values);
			for i = 1:length(res)
				l_lbl = max(l_lbl, length(res{i}{1}));
				for i = 1:length(res)
					for j = 2:3 % precision / recall
						for k = 1:3 % for the three classes
							id = (j-2)*3+k;
							max_vals(1, id) = max(max_vals(1, id), res{i}{j}(k));
						end
						% mean P and R in 7 and 8
						max_vals(1,5+j) = max(max_vals(1,5+j), mean(res{i}{j}));
					end
				end
			end
			fprintf('\n%1$*2$s |  %3$*4$s %5$*4$s %6$*4$s  |  %7$*4$s %8$*4$s %9$*4$s  |  %10$*4$s %11$*4$s  |  %12$*4$s\n', 'Method', l_lbl, 'P1', l_nbrs, 'P2', 'P3', 'R1', 'R2', 'R3', 'mP', 'mR', 'Time');
			fprintf([repmat(['-'],1,l_lbl+8*l_nbrs+30) '\n']);
			for i = 1:length(res)
				fprintf('%1$*2$s', res{i}{1}, l_lbl);
				for j = 2:3
					fprintf(' |  ')
					for k = 1:3
						if res{i}{j}(k) == max_vals(1,(j-2)*3+k)
							fprintf('<strong>%1$*2$.2f</strong> ', res{i}{j}(k), l_nbrs);
						else
							fprintf('%1$*2$.2f ', res{i}{j}(k), l_nbrs);
						end
					end
				end
				fprintf(' |  ')
				mP = mean(res{i}{2});
				mR = mean(res{i}{3});
				if mP == max_vals(1,7)
					fprintf('<strong>%1$*2$.2f</strong> ', mP, l_nbrs);
				else
					fprintf('%1$*2$.2f ', mP, l_nbrs);
				end
				if mR == max_vals(1,8)
					fprintf('<strong>%1$*2$.2f</strong> ', mR, l_nbrs);
				else
					fprintf('%1$*2$.2f ', mR, l_nbrs);
				end
				fprintf(' |  ')
				fprintf('%1$*2$.2f\n', res{i}{4}, l_nbrs);
			end
			fprintf('\n');
		end


		function [res, time] = add_model(res, cv_data, name, classifier, params)
			tic;
			confusion_matrix = Learning.cross_validation(cv_data, classifier, params) ;
			[precision, recall] = Utils.pre_rec(confusion_matrix);
			time = toc;
			res = Utils.add_prt(res, name, precision, recall, time);
		end

		function h = hash(m)
            if isempty(m)
                h = '' ;
            else
                h = mat2str(m);
            end
			%h = DataHash(m);
			%opts = struct('Method','SHA-512');
			%h = DataHash(m,opts);
		end

		function play_path(path)
			system(['timidity -A300 ' path]);
		end

		function write_to_file(pitch, duration, path)
			l = length(pitch);
			p_safe = pitch(pitch~=99);
			ln = length(p_safe); % nb. of notes (without silences)
			mat = zeros(ln, 7);
			mat(:,3) = 1; % channel
			mat(:,5) = 127; % velocity
			% Then encode the notes !
			mat(:,4) = p_safe(:)+48; % pitch

			tot_d = 0;
			cur_lign = 1;
			for k = 1:l
				on = tot_d;
				tot_d = tot_d+duration(k);
				if pitch(k)~=99
					mat(cur_lign,6) = on;
					mat(cur_lign,7) = duration(k);
					mat(cur_lign,1) = 2*on;
					mat(cur_lign,2) = 2*duration(k);
					cur_lign = cur_lign+1;
				end
			end
			mat(:,[1,2,5,6]) = 0.6*mat(:,[1,2,5,6]);
			%mat
			%pause
			writemidi(mat, path, 100);
		end

		function play(pitch, duration)
			path = '.tmp.mid';
			Utils.write_to_file(pitch, duration, path);
			Utils.play_path('.tmp.mid');
		end

	end % methods (static)
end
