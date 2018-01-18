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
% Make a normal PTT onward
% Input: PTT Prefix Tree Transducer 
%        q The state where onward will be applied
% Output: An onward PTT

function [ptt, f] = Onward_PTT(ptt, q)
%ONWARD_PTT Summary of this function goes here
%   Detailed explanation goes here
    iAlphabet = ptt.InAlphabets;
    for i = 1:length(iAlphabet)
        % Let's start from leaves of PTT
        alpha = iAlphabet{i};
        if ptt.StateTransition(q, i) ~= 0
            [ptt, w] = Onward_PTT(ptt, ptt.StateTransition(q, i));
            if w == 0 
                continue;
            end
            if ~strcmp(w, '')
                % if we got an reasonable LCP
                ptt.OutputTransduction{q, i} = strcat(ptt.OutputTransduction{q, i}, w);
            end
        end      
    end
    string_set = {};
    for i = 1:length(iAlphabet)
        if ptt.StateTransition(q, i) ~= 0 
            string_set{length(string_set)+1, 1} = ptt.OutputTransduction{q, i};
        end
    end
    string_set{length(string_set)+1, 1} = ptt.StateOutputs{q};
    f = LongestCommonPrefix(string_set);
    if f == 0
        return;
    end
    if ~strcmp(f, '')
        % if we got a reasonable LCP, cut the LCP from outputs
        for i = 1:length(iAlphabet)
            if ptt.StateTransition(q, i) ~= 0
                str = ptt.OutputTransduction{q, i};
                if strcmp(str, f)
                    ptt.OutputTransduction{q, i} = '';
                else
                    ptt.OutputTransduction{q, i} = str((length(f)+1):length(str));
                end
            end
        end
        str = ptt.StateOutputs{q};
        if strcmp(str, f)
            ptt.StateOutputs{q} = '';
        end
        if ~strcmp(str, '*')
            ptt.StateOutputs{q} = str((length(f)+1):length(str));
        end
    end
    return;
end

