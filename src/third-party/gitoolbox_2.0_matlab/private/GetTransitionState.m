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
% Auxilary function, returns the state 'q' after transition from state
% 'q_u'
% through the alphabet a

function q = GetTransitionState(dfa, q_u, a)

	%dfa.Alphabets
	%pause
    [~, col_position] = ismember(a,dfa.Alphabets); 
    row_position = find(dfa.FiniteSetOfStates == q_u);
    if col_position ~=0
        q = dfa.TransitionMatrix(row_position, col_position);
    else
        q = 0 ;
    end
end
