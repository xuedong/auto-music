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
% MDIScore computes a score value for compatibility test.
% Notice that the sample should be a sorted sample from Build_FPTA
% Input: Sample set, a DFFA
% Output: a score
% see also MDIStochasticFold, MDICompatible, MDIPromote, MDIStochasticMerge

function score = MDIScore(sample, dffa)
%MDISCORE returns a score of a dffa
    str = sample{1};
    cnt = 0;
    score = 0;
    dpfa = dffa2dpfa(dffa);
    for i = 1:length(sample)
        if (strcmp(sample{i}, str))
            cnt = cnt + 1;
        else
            score = score + cnt*log10(ProbabilityOfString(dpfa, str));
            str = sample{i};
            cnt = 1;
        end
    end
    size = AutomataSize(dffa.AssociateTransitionMatrix);
    score = -score/size;
    
end

