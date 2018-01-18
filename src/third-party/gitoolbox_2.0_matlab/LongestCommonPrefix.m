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
% Find out the longest common prefix string in a set of strings
% Specially hard coded for algorithm OSTIA
% Symbol '*' doesn't influence the result
% A string set containing null symbol will have the result empty symbol as well
% Input: A set of strings
% Output: The longest common prefix
% See also: TRANSDUCER, BUILD_PTT, OSTIA, OSTIA_Merge, OSTIA_Fold, OSTIA_Outputs,
% OSTIA_PushBack

function lcp = LongestCommonPrefix(string_set)
%LONGESTCOMMONPREFIX Summary of this function goes here
%   Detailed explanation goes here
    lcp = '';
    endflag = 0;
    j = 1;
    i = 1;
    if isempty(string_set)
        lcp = 0;
        return;
    end
    while i <= length(string_set)
    % disgard all '*' symbols, while unknow state doesn't matter onward operation.    
        if strcmp(string_set{i}, '*')
            string_set(i) = [];
            i = i - 1;
        end
        i = i + 1;
    end
    if isempty(string_set)
    % if no strings exist after disgarding '*', simply return 0    
        lcp = 0;
        return;
    end
    if length(string_set) == 1
    % if only one string left, simply return it as lcp   
        lcp = string_set{1};
        return;
    end
    while ~endflag
        tempchar = '';
        for i = 1:length(string_set)
            str = string_set{i};
            if strcmp(str, '')
                % if there is an empty string, return it.
                lcp = '';
                return;
            end
            if strcmp(tempchar, '')
            % first iteration check, tempchar is the character to be checked.   
                tempchar = str(j);
                if length(str) == j
                    % only one character for a string, end.
                    endflag = 1;
                end
            else
                % not the first iteration.
                if ~strcmp(str(j), tempchar)
                    % there is a character not compatible, end
                    endflag = 1;
                    if j == 1
                        lcp = '';
                    end
                    return;
                end
                if length(str) == j
                    endflag = 1;
                end
            end                        
        end
        
        lcp = strcat(lcp, tempchar);
        j = j + 1;
    end

end

