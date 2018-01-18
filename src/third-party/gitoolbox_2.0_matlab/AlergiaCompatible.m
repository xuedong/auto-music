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
% To see if two states are compatible for merge, this method call
% AlergiaTest as many times as needed.
% Input: A DFFA, two states qu, qv, and a parameter alpha
% Output: A Boolean indicating if qu and qv are compatible
% see also AlergiaStochasticFold, AlergiaStochasticMerge, AlergiaTest, AlergiaPromote

function correct = AlergiaCompatible(dffa, qu, qv, alpha)
%ALERGIA_COMPATIBLE examines if two states are compatible
    correct = 1;
    if (~AlergiaTest(dffa, dffa.FinalStateFrequency(qu), FreqOfState(dffa, qu),...
                    dffa.FinalStateFrequency(qv), FreqOfState(dffa, qv), alpha))
        correct = 0;
        return;
    end
    for i = 1:length(dffa.Alphabets)
        if (~AlergiaTest(dffa, dffa.FrequencyTransitionMatrix{2}(qu, i), FreqOfState(dffa, qu),...
                        dffa.FrequencyTransitionMatrix{2}(qv, i), FreqOfState(dffa, qv), alpha))
            correct = 0;
            return;
        end
    end
    % ?only when all the alergia-test fail, goes here and return 1
    % ?which means all the examined probabilities are bigger than a miu
    % ?also equals that this two states are not similar.
end

