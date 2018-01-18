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
% The EDSM algorithm
% EDSM starts from creating PTA according to positive samples. Initialize
% RED state set and BLUE state set as following:
%   1. set start state as RED state and add it to RED set.
%   2. add all the successors of start state to BLUE set.
% After initialization, EDSM starts to merge blue and red states pairwise.
% After each Merge, we caculate the score of the merged DFA by EDSM_Count
% Select the merge with highest score as the optimal merge, if there's no
% merge possible, then promote current blue state.
% Until there's no BLUE state for Merge.
% see also EDSM_MERGE, EDSM_PROMOTE, EDSM_FOLD, BUILD_PTA,
% TraversedState, ReadSamples

function dfa = EDSM(positive, negative)
    %display('Bulding PTA....');
    dfa = BUILD_PTA(positive); 
    
    % adding the red states
    dfa.RED = [dfa.RED, dfa.FiniteSetOfStates(1)];
    
    % adding the blue states
    for i = 1:length(dfa.Alphabets)    
        temp_blue = GetTransitionState(dfa, dfa.FiniteSetOfStates(1), dfa.Alphabets(i));
        if(temp_blue~=0) % 0 means no transition            
            dfa.BLUE = [dfa.BLUE, temp_blue];
        end  
    end
    
    %display('Running EDSM on PTA....');
    while (~isempty(dfa.BLUE))
        dfa ;
        promotion = 1;
        for i = 1:length(dfa.BLUE)
            if promotion == 1
                bs = -inf;
                atleastonemerge = 1;
                for j = 1:length(dfa.RED)
                    dfa_merged = EDSM_MERGE(dfa, dfa.RED(j), dfa.BLUE(i));
                    count = EDSM_Count(dfa_merged, positive, negative);
                    if count > -inf
                        % at least one merge exists
                        atleastonemerge = 0;
                    end
                    if count > bs
                        % if current merged dfa has higher score
                        bs = count;
                        qr = dfa.RED(j);     % current index of red state
                        qb = dfa.BLUE(i);     % current index of blue state
                    end
                end
                if atleastonemerge == 1      % no merge is possible
                    qpromote = dfa.BLUE(i);
                    dfa.BLUE(i) = [];
                    dfa = EDSM_PROMOTE(qpromote, dfa);
                    promotion = 0;
                    %display('promoting:');
                    %display(qpromote)
                    break;
                end 
            end
        end
        if promotion == 1
            index = find(dfa.BLUE == qb);
            dfa.BLUE(index) = [];
            dfa = EDSM_MERGE(dfa, qr, qb);
            dfa = AddNewBlueStates(dfa);
        end
    end
    
    % so far a merged dfa is finally generated
    % add the final-accepted states
    for i = 1:length(positive)
        qt = TraversedState(positive{i}, dfa);
        if  qt ~= 0 && ~isequal(ismember(qt, dfa.FinalAcceptStates), [1])
            dfa.FinalAcceptStates = [dfa.FinalAcceptStates, qt];
        end
    end
    % add the final-rejected states
    for i = 1:length(negative)
        qt = TraversedState(negative{i}, dfa);
        if  qt ~= 0 && ~isequal(ismember(qt, dfa.FinalRejectStates), [1])
            dfa.FinalRejectStates = [dfa.FinalRejectStates, qt];
        end
    end
end
