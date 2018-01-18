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
% Promote a given blue state, add it to red set and all its successors 
% should be added to red set.
% Input: a state, a DFFA
% Output: A promoted DFFA
% see also MDIStochasticMerge MDIStochasticFold, MDICompatible, MDIScore

function dffa = MDIPromote(qb, dffa)
%MDIPROMOTE promotes a blue state
    dffa.RED = [dffa.RED, qb];
    for i = 1:length(dffa.Alphabets)
        if (dffa.AssociateTransitionMatrix(qb, i) ~= 0)
            dffa.BLUE = [dffa.BLUE, dffa.AssociateTransitionMatrix(qb, i)];
        end
    end
end

