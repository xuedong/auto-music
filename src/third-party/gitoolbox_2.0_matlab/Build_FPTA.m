% [Authors]: Hasan Ibne Akram, Huang Xiao
% [Institute]: Munich University of Technology
% [Web]: http://code.google.com/p/gitoolbox/
% [Emails]: hasan.akram@sec.in.tum.de, huang.xiao@mytum.de
% Copyright ? 2010
% 
% ****** This is a beta version ****** 
% [DISCLAIMER OF WARRANTY]
% This source code is provided "as is" and without warranties
% as to performance or merchantability. The author and/or 
% distributors of this source code may have made statements 
% about this source code. Any such statements do not constitute 
% warranties and shall not be relied on by the user in deciding
% whether to use this source code. 
% 
% This source code is provided without any express or implied
% warranties whatsoever. Because of the diversity of conditions
% and hardware under which this source code may be used, no
% warranty of fitness for a particular purpose is offered. The 
% user is advised to test the source code thoroughly before relying
% on it. The user must assume the entire risk of using the source code.
% 
% -------------------------------------------------
% [Description]
% Building frequency prefix tree acceptor with respect to samples
% Only used for Alergia
% Input: A set of samples
% Output: Deterministic Frequency Finite Automaton (DFFA).
%         A sorted training set.
%         Total number of samples.

function [dffa, training_set_sorted, numOfSamples] = Build_FPTA(training)
%BUILD_FPTA builds FPTA from samples
    % first column denotes states, second column denotes corresponding final
    % state frequency
    training_set_sorted = LEXSORT(training);
    training_len = length(training);
    numOfSamples = training_len;
    SetOfStates = [1];    
    A = {};
    Init_Stat_Freq = [0];
    Final_Stat_Freq = [0];
    % first matrix denotes associate transition matrix, second denotes
    % corresponding frequency
    Freq_Tran_Matrix = {[],[]};
    Asso_Tran_Matrix = [];
    
    if nargin == 1
        A = [];

        % creating the alphabet list

        for i=1:training_len
        str = training{i};
            for j = 1: length(str)
                 % cheking if alphabet already entered into the list
                 if(isempty(A))
                    A(1) = str(j); 
                 end
                 check = max(A == str(j));
                 % adding the alphabets
                 if(check == 0)
                     A(length(A) + 1) = str(j);                  
                 end

            end
        end
    end
    
    
    % begin building prefix tree acceptor
    
    max_str_len = 1;
    for i = 1:training_len
        str = training_set_sorted{i};
        % inserting the max length of the string
        str_len = length(str);
        if(str_len>max_str_len)
            max_str_len = str_len;
        end
        Init_Stat_Freq(1) = Init_Stat_Freq(1) + 1 ;
        if (str_len==0)
            Final_Stat_Freq(1) = Final_Stat_Freq(end) + 1;
        end 
    end
    
    prefixes = {''};
    j = 1;
    while (j<=max_str_len)
        for i = 1:training_len
            str = training_set_sorted{i};
            % inserting the max length of the string
            str_len = length(str);
            if(str_len>max_str_len)
                max_str_len = str_len;
            end
            if(j==0)
                Init_Stat_Freq(1) = Init_Stat_Freq(1) + 1 ;
                if (str_len==length(prefix_str))
                    Final_Stat_Freq(1) = Final_Stat_Freq(end) + 1;
                end 
                break
            end
            if(j<=str_len)
                prefix_len = length(prefixes);
                prefix_str = str(1:j);
                if(LEXICALCMP(prefixes{prefix_len}, prefix_str)~=0)
                    prefixes{length(prefixes)+1, 1} = str(1:j);
                    SetOfStates = [SetOfStates; (length(SetOfStates) +1)];
                    Init_Stat_Freq = [Init_Stat_Freq; 0];
                    if(str_len==length(prefix_str))               
                        Final_Stat_Freq = [Final_Stat_Freq; 1];
                    else  
                        Final_Stat_Freq = [Final_Stat_Freq; 0];
                    end
                    % initialization
                    Freq_Tran_Matrix{1}(length(SetOfStates), 1:length(A)) = 0;
                    Freq_Tran_Matrix{2}(length(SetOfStates), 1:length(A)) = 0;
                else
                    if (str_len==length(prefix_str))
                        Final_Stat_Freq(end) = Final_Stat_Freq(end) + 1;
                    end                    
                end
                transit_state_from = find(cellfun(@(x) LEXICALCMP(x,prefix_str(1:j-1)),prefixes)==0);
                alphabet_index = find(A==prefix_str(j));          
                transit_state_to = SetOfStates(length(SetOfStates));
                Freq_Tran_Matrix{1}(transit_state_from, alphabet_index) = transit_state_to;
                Freq_Tran_Matrix{2}(transit_state_from, alphabet_index) = Freq_Tran_Matrix{2}(transit_state_from, alphabet_index) + 1;
            end
        end        
        j = j + 1;
    end
    dffa = DFFA(SetOfStates, A, Init_Stat_Freq, Final_Stat_Freq, Freq_Tran_Matrix, Freq_Tran_Matrix{1}, [], []);
    %dffa = AlergiaStochasticMerge(dffa, 6, 2);
end



