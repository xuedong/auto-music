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
% Merge a red state with a blue state
% Only used for Alergia
% Input: A DFFA, a red state and a blue state
% Output: A updated Deterministic Frequency Finite Automaton (DFFA)
% see also AlergiaStochasticFold, AlergiaCompatible, AlergiaTest, AlergiaPromote

function dffa = AlergiaStochasticMerge(dffa, qr, qb)
%This method is used to merge a red state with a blue state
    % find the only predecessor of the blue state qb
    atm = dffa.AssociateTransitionMatrix;
    for i = 1:length(dffa.Alphabets)
        % alph = dffa.Alphabets(i);
        q = find(atm(:,i) == qb);   % predecessor of the blue state qb
        if (q)   % (q, i) -> qb
            break;
        end
    end
    % record the frequency
    freq = dffa.FrequencyTransitionMatrix{2}(q, i);
    % redirect to the red state qr
    dffa.FrequencyTransitionMatrix{1}(q, i) = qr;
    dffa.AssociateTransitionMatrix(q, i) = qr;
    %new_dffa = dffa;
    dffa = AlergiaStochasticFold(dffa, qr, qb);
end

