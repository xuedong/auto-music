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
% Input a string to a DPFA, caculate the probability of this string
% Input: DPFA, string
% Output: Probability of this string

function prob = ProbabilityOfString(dpfa, str)
%PROBABILITYOFSTRING returns the probability of a string with respect to
%a DPFA
    curr_state = 1;
    prob = 1;
    for i = 1:length(str)
        ch = str(i);
        alphabet_index = find(dpfa.Alphabets == ch);
        if (alphabet_index)
            next_state = dpfa.ProbabilityTransitionMatrix{1}(curr_state, alphabet_index);
            if (next_state == 0)
                prob = 0;
                return;
            else              
                prob = prob*dpfa.ProbabilityTransitionMatrix{2}(curr_state, alphabet_index);
                curr_state = next_state;
            end            
        else
            prob = 0;
            return;
        end
    end
    prob = prob*dpfa.FinalStateProbability(curr_state);

end

