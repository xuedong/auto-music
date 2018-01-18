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
% AutomataSize outputs the size of an automata according to the states.
% Input: transition matrix of an automata
% Output: size of the automata

function size = AutomataSize( TransitionMatrix )
%AUTOMATASIZE Summary of this function goes here
%   traverse the automata to get the valid states
    queue = [1];
    valid = [1];
    while ~isempty(queue)
        state = queue(1);
        for i = 1:length(TransitionMatrix(state, :))
            next = TransitionMatrix(state, i);
            if next ~= 0
                if isempty(find(valid == next))
                    queue(length(queue)+1) = next;
                    valid(length(valid)+1) = next;
                end
            end
        end
        queue = queue(2:length(queue));
    end
    size = length(valid);
end

