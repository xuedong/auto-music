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
% Building PTT according to samples (input, output pairs)
% PTT: Prefix Tree Transducer 
% In order to learn a transducer, we need to start with a PTT learned from 
% samples containing pairs of input and output.
% Input: A sample dataset comprising input and output pairs
% Output: A prefix tree transducer
% See also: TRANSDUCER, OSTIA, OSTIA_Merge, OSTIA_Fold, OSTIA_Outputs,
% OSTIA_PushBack, LongestCommonPrefix

function ptt = BUILD_PTT(ostia_sample)
%BUILD_PTT Summary of this function goes here
    % first of all, create input set and output set
    fid = fopen(ostia_sample, 'r');
    text_set = textscan(fid, '%s%s', 'delimiter', ',');
    input_set = text_set{1};
    output_set = text_set{2};
    
    % initialize PTT
    SetOfStates = [1];
    iAlphabetSet = {};
    oAlphabetSet = {};
    InitState = 1;
    StateTransit = [];     % (q, a) -> q'
    OutputTransduct = {};  % (q, a) -> w
    StateOutput = {''};      % q -> output, can be null string which means output is still unknown
    
    % parsing alphabets
    % input set
    for i=1:length(input_set)
        str = char(input_set(i));
        for j = 1: length(str)
             % cheking if alphabet already entered into the list
             if(isempty(iAlphabetSet))
                iAlphabetSet{1} = str(j); 
             end
             check = max(strcmp(iAlphabetSet, str(j)));
             % adding the alphabets
             if(check == 0)
                 iAlphabetSet{length(iAlphabetSet) + 1} = str(j);                  
             end            
        end
    end
    % output set
    for i=1:length(output_set)
        str = char(output_set(i));
        for j = 1: length(str)
             % cheking if alphabet already entered into the list
             if(isempty(oAlphabetSet))
                oAlphabetSet{1} = str(j); 
             end
             check = max(strcmp(oAlphabetSet, str(j)));
             % adding the alphabets
             if(check == 0)
                 oAlphabetSet{length(oAlphabetSet) + 1} = str(j);                  
             end            
        end
    end
    
    % parsing prefix and set states
    % sort a temporary input set
    tempset = input_set;
    tempset = LEXSORT(tempset);
    tempset_len = length(tempset);
    prefixes = {''};
    max_str_len = 1; 
    j = 1; 
    
    while (j<=max_str_len)
        for i = 1:tempset_len
            str = tempset{i};
            % inserting the max length of the string
            str_len = length(str);
            if(str_len>max_str_len)
                max_str_len = str_len;
            end
            if(j<=str_len)
                prefix_len = length(prefixes);
                prefix_str = str(1:j);
                if(strcmp(prefixes{prefix_len}, prefix_str)==0)
                    prefixes{prefix_len+1} = prefix_str;
                    % add states corresponding to the prefix
                    SetOfStates = [SetOfStates, (length(SetOfStates) +1)];
                    
                    % initializing a new row in the state transition matrix
                    % and state output function
                    for k = 1:length(iAlphabetSet)
                        StateTransit(length(SetOfStates), k) = 0; 
                        OutputTransduct{length(SetOfStates), k} = '';
                    end
                    StateOutput{length(SetOfStates), 1} = '*';
                    
                    % adding the state transitions and output transductions
                    transition_source_state = find(strcmp(prefixes, prefix_str(1:j-1)));
                    transition_state = SetOfStates(length(SetOfStates));
                    alphabet_index = find(strcmp(iAlphabetSet, prefix_str(j:j)));                    
                    StateTransit(transition_source_state, alphabet_index) = transition_state; 
                    OutputTransduct{transition_source_state, alphabet_index} = '';
                    
                    % adding state output function
                    if(str_len == length(prefix_str))
                        % find out corresponding index in output sample
                        output_index = find(strcmp(input_set, tempset{i}));
                        StateOutput{length(SetOfStates), 1} = output_set{output_index, 1};
                    end
                end       
            end
        end
        j = j + 1;
    end
    ptt = TRANSDUCER(SetOfStates, iAlphabetSet, oAlphabetSet, InitState, StateTransit, OutputTransduct, StateOutput, [], []);
end

