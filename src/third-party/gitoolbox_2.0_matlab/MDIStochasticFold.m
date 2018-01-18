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
% After merging, it's neccessary to fold the isolated subtree into original
% DFFA, this method recursively folds the subtree into DFFA
% Input: A DFFA which contains an seperated subtree rooted on a blue state
%        Red state qr, and Blue state qb       
% Output: A updated Deterministic Frequency Finite Automaton (DFFA)
% see also MDIStochasticMerge, MDICompatible, MDIScore, MDIPromote

function dffa = MDIStochasticFold(dffa, qr, qb)
%This method operates on a DFFA after merge
    % adds up final state frequency
    dffa.FinalStateFrequency(qr) = dffa.FinalStateFrequency(qr) + dffa.FinalStateFrequency(qb);
    for i = 1:length(dffa.Alphabets)
        transition_from_qr = dffa.AssociateTransitionMatrix(qr, i);
        transition_from_qb = dffa.AssociateTransitionMatrix(qb, i);
        % if (qb, a) is defined (for each alphabet) 
        if (transition_from_qb ~= 0)
            % check if (qr, a) is also defined
            if (transition_from_qr ~= 0)
                % if so
                dffa.FrequencyTransitionMatrix{2}(qr, i) = dffa.FrequencyTransitionMatrix{2}(qr, i) + dffa.FrequencyTransitionMatrix{2}(qb, i);
                dffa = AlergiaStochasticFold(dffa, transition_from_qr, transition_from_qb);
            else
                dffa.FrequencyTransitionMatrix{1}(qr, i) = dffa.FrequencyTransitionMatrix{1}(qb, i);
                dffa.AssociateTransitionMatrix(qr, i) = dffa.AssociateTransitionMatrix(qb, i);
                dffa.FrequencyTransitionMatrix{2}(qr, i) = dffa.FrequencyTransitionMatrix{2}(qb, i);
            end
        end
    end
end

