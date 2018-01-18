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
% This function checks wheather a given DFA accepts a string or not
% Q is the set of finite states
% A is the set of alphabets
% TM is the state transition matrix. 'X' is denoted as no transition
% I is the set of initial states
% F is the set of string_value
% 
% Input: 'string_value' which is an negative sample in our case
%        'dfa' defines a DFA
% Output: if returns non-zero, that means string is accepted and the return
%         value is the finally transitioned state of this string 
%         if returns 0, that means string is rejected

function x = TraversedState(string_value, dfa)
    % Iniializing x with a dummy value
    x = 5;
    %initial state
    state = dfa.InitialState;

    for i = 1:length(string_value)  
    %if max(strcmp(dfa.Alphabets, string_value(i))) ~= 0
        next_state = GetTransitionState(dfa, state, string_value(i));
        % here two conditions are checked and if all of the three conditions are true the string is rejected		
		% 1. there are no transitions from the state
		% 2. the string has more alphabets still to be checked 
	
        if (next_state==0 && i<length(string_value))			
            x = 0;
			break;
        end		
        state = next_state; 
    end

    if x ~= 0
        x = state;
    end
end


