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
% After each merge we use EDSM_Count to caculate the score for a specific
% merge. If a negative sample is accpceted or a positive sample is rejected
% then the score goes infinitely.

function score = EDSM_Count( dfa, positive, negative )
%   This function is used to caculate the score for a certain merge
    tp = [];
    tn = [];
    sc = 0;
    % initialize the positive/negative counter 
    for i = 1:length(dfa.FiniteSetOfStates)
        tp(i) = 0;
        tn(i) = 0;
    end
    % see how many positive samples are accepted
    for i = 1:length(positive)
        qt = TraversedState(positive{i}, dfa);
        if  qt ~= 0
            tp(qt) = tp(qt) + 1;
        end
    end
    % see how many negative samples are accepted
    for i = 1:length(negative)
        qt = TraversedState(negative{i}, dfa);
        if  qt ~= 0
            tn(qt) = tn(qt) + 1;
        end
    end
    for i = 1:length(dfa.FiniteSetOfStates)
        if sc ~= -inf
            if tn(i) > 0    % this state i ever accepted a negative sample
                if tp(i) > 0    % this state i also accepted positive samples
                    sc = -inf;
                else
                    sc = sc + tn(i) - 1;
                end
            else            % this state i only accepted positive samples
                if tp(i) > 0
                    sc = sc + tp(i) - 1;
                end
            end
        end
    end
    score = sc;
end
