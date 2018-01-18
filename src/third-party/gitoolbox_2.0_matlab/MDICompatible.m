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
% To see if two states are compatible for merge, this method merges
% two states first and check the score of merged automaton.
% Input: A DFFA, two states qu, qv, sample set, and a parameter alpha
% Output: A Boolean indicating if qu and qv are compatible, and also the
%         dffa after merge.
% see also MDIStochasticFold, MDIStochasticMerge, MDIScore, MDIPromote

function [correct, dffa_merged] = MDICompatible(dffa, qu, qv, sample, alpha)
%MDI_COMPATIBLE examines if two states are compatible
    dffa_merged = MDIStochasticMerge(dffa, qu, qv);
    if (MDIScore(sample, dffa_merged) < alpha)
        correct = 1;
    else
        correct = 0;
    end
end

