classdef Learning

	methods (Static)

        function models = train(xtr, ytr, classifier, num_class, parameters)
        	% Train a different model for each class
        	
            models = cell(1, num_class) ;
            if strcmp(classifier, 'lm') % Language model (n-grams)
                for i = 1:num_class
                    models{i} = Classifier.build_language_model(xtr(ytr==i), parameters.n, parameters.pseudo_count, parameters.pseudo_count_args, parameters.size_alphabet);
                end
            elseif strcmp(classifier, 'lm_mix') % Language model (n-grams)
                for i = 1:num_class
                    models{i} = Classifier.build_language_model_mixed(xtr(ytr==i), parameters.n, parameters.pseudo_count, parameters.pseudo_count_args, parameters.size_alphabet);
                end
            elseif strcmp(classifier, 'rpni') % Deterministic finite automaton (RPNI)
                for i = 1:num_class
                    models{i} = RPNI(xtr(ytr==i), xtr(ytr~=i));
                end
            elseif strcmp(classifier, 'edsm') % Deterministic finite automaton (EDSM)
                for i = 1:num_class
                    models{i} = EDSM(xtr(ytr==i), xtr(ytr~=i));
                end
            elseif strcmp(classifier, 'ktsi') % Deterministic finite automaton (EDSM)
                for i = 1:num_class
                    models{i} = K2dfa(KBuilder(xtr(ytr==i), parameters.k));
                end            
            elseif strcmp(classifier, 'rpni+lm_mix') % Deterministic finite automaton (RPNI)
                for i = 1:num_class
                    models{i} = {};
                    models{i}{1} = RPNI(xtr(ytr==i), xtr(ytr~=i));                    
                    models{i}{2} = Classifier.build_language_model_mixed(xtr(ytr==i), parameters.n, parameters.pseudo_count, parameters.pseudo_count_args, parameters.size_alphabet);
                end
            elseif strcmp(classifier, 'edsm+lm_mix') % Deterministic finite automaton (EDSM)
                for i = 1:num_class
                    models{i} = {};
                    models{i}{1} = EDSM(xtr(ytr==i), xtr(ytr~=i));
                    models{i}{2} = Classifier.build_language_model_mixed(xtr(ytr==i), parameters.n, parameters.pseudo_count, parameters.pseudo_count_args, parameters.size_alphabet);
                end
            elseif strcmp(classifier, 'ktsi+lm_mix') % Deterministic finite automaton (EDSM)
                for i = 1:num_class
                    models{i} = {};
                    models{i}{1} = K2dfa(KBuilder(xtr(ytr==i), parameters.k));
                    models{i}{2} = Classifier.build_language_model_mixed(xtr(ytr==i), parameters.n, parameters.pseudo_count, parameters.pseudo_count_args, parameters.size_alphabet);
                end
            elseif strcmp(classifier, 'alergia') % Deterministic frequency finite automaton (Alergia)
                for i = 1:num_class
                    [~,models{i}] = Alergia(xtr(ytr==i),parameters.alpha,parameters.t0);
                end
            end
        end

        function class = test(classifier, models, x, parameters )
        	% Test sequence [x] for each model of [models]
            if strcmp(classifier, 'lm') || strcmp(classifier, 'lm_mix')
                f = @(model) Classifier.sequence_probability(model{1}, x{1}) ;
            elseif strcmp(classifier, 'rpni') || strcmp(classifier, 'edsm') || strcmp(classifier, 'ktsi')
                f = @(model) IsStringAccepted(x{1},model{1});                
            elseif strcmp(classifier, 'rpni+lm_mix') || strcmp(classifier, 'edsm+lm_mix') || strcmp(classifier, 'ktsi+lm_mix')
                f = @(model) IsStringAccepted(x{1},model{1}{1});                 
            elseif strcmp(classifier, 'alergia')
                f = @(model) ProbabilityOfString(model{1},x{1});
            else
                fprintf('WARNING TEST : CLASSIFIER PROVIDED DOESNT EXIST');
                class = 0 ;
                return
            end
            results = arrayfun(f, models) ;
            if parameters.allow_reject
                m = max(results) ;
                class = find(results == m) ;
                if length(class)>1
                    class = NaN ;
                end
            else
                if strcmp(classifier, 'rpni+lm_mix') || strcmp(classifier, 'edsm+lm_mix') || strcmp(classifier, 'ktsi+lm_mix')                    
                    m = max(results) ;
                    class = find(results == m) ;
                    if length(class)>1                        
                        f = @(model) Classifier.sequence_probability(model{1}{2}, x{1}) ;
                        results_2 = arrayfun(f, models) ;
                        [~, class] = max(results_2(results == m)) ;
                    end
                else
                    [~, class] = max(results) ;
                end
            end
        end

        function [yte] = classify(classifier, xte, xtr, ytr, num_class, parameters)
        	% Classify test data [xte] using training data [xtr] and labels [ytr]
        	
            models = Learning.train(xtr, ytr, classifier, num_class, parameters) ;
            yte = arrayfun(@(x) Learning.test(classifier, models, x, parameters), xte) ;
        end

        function cv_data = pre_cross_validation(datasets_and_data, k)
        	% Calculates X, y, and partitions for cross_validation.
        	
            cv_data = {};
            d1 = datasets_and_data{1}{1};
            nb_classes = length(d1);
            % Calculate y (same for all X)
            y = zeros(length(d1),1);
            i = 1 ;
            j = 1 ;
            for r = 1:nb_classes % for each class
                nj = length(d1{r}) ; % nb. of training samples for class r
                y(i:i+nj-1) = j ;
                j = j+1 ; % number representing the class
                i = i+nj ;
            end
            cvpart = cvpartition(y, 'k', k) ; % Generate cross-validation partitions.
            cv_data.cvpart = cvpart;
            cv_data.nb_classes = nb_classes;
            cv_data.y = y;
            cv_data.X = {};
            cv_data.data = {};
            cv_data.nb_X = length(datasets_and_data);
            for d = 1:cv_data.nb_X
            	datasets = datasets_and_data{d}{1};
            	X = vertcat(datasets{:});
            	cv_data.X{d} = X;
            	cv_data.data{d} = datasets_and_data{d}{2};
            end
        end

        function [confusion_matrix] = cross_validation(cv_data, classifier, parameters)

            order = 1:cv_data.nb_classes ;
            if cv_data.nb_X==1
            	X1 = cv_data.X{1};
            	Y = cv_data.y;
            	confusion_matrices = crossval(@f, X1, Y, 'partition', cv_data.cvpart) ;
            else
            	X1 = cv_data.X{1};
            	X2 = cv_data.X{2};
            	X3 = cv_data.X{3};
            	Y = cv_data.y;
            	confusion_matrices = crossval(@f3, X1, Y, X2, X3, 'partition', cv_data.cvpart) ;
            end
            % Average confusion matrix
            confusion_matrix = reshape(sum(confusion_matrices),3,3) ;

            function r = f(xtr, ytr, xte, yte) 
				try
					if strcmp(classifier,'lm_mix') || strcmp(classifier,'rpni+lm_mix') || strcmp(classifier,'edsm+lm_mix') || strcmp(classifier,'ktsi+lm_mix')
            			p1 = parameters; p1.size_alphabet = p1.size_alphabet{1};
            		else
            			p1 = parameters ;
            		end
                    %disp(p1.size_alphabet)
					y = Learning.classify(classifier, xte, xtr, ytr, cv_data.nb_classes, p1);
            		r = confusionmat(yte, y, 'order', order) ;
				 	% One confusion matrix by line
				 catch ME
					 getReport(ME)
					 rethrow(ME)
				 end
            end

            function r = f3(xtr1, ytr1, xtr2, xtr3, xte1, yte1, xte2, xte3)
            	try
					if strcmp(classifier,'lm_mix')
            			p1 = parameters; p1.size_alphabet = p1.size_alphabet{1};
            			p2 = parameters; p2.size_alphabet = p2.size_alphabet{2};
            			p3 = parameters; p3.size_alphabet = p3.size_alphabet{3};
            		else
            			p1 = parameters;
            			p2 = parameters;
            			p3 = parameters;
            		end
					y1 = Learning.classify(classifier, xte1, xtr1, ytr1, cv_data.nb_classes, p1);
					y2 = Learning.classify(classifier, xte2, xtr2, ytr1, cv_data.nb_classes, p2);
					y3 = Learning.classify(classifier, xte3, xtr3, ytr1, cv_data.nb_classes, p3);
					y = mode([y1,y2,y3],2);
					%disp([yte1,y,y1,y2,y3])
					%pause
            		r = confusionmat(yte1, y, 'order', order) ;
            	catch ME
					getReport(ME)
					rethrow(ME)
				end
            end
        end

    end % methods (Static)
    
end
