% Author: Hasan Ibne Akram, Huang Xiao
% Munich University of Technology
% Web: http://www.sec.in.tum.de/hasan-akram/
% Email: hasan.akram@sec.in.tum.de
%          huang.xiao@mytum.de
% Copyright © 2010
% 
% This is a beta version
% 
% DISCLAIMER OF WARRANTY
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
% --------------------------
% this is an auxiliary function that sets the
% trantition of a state q for alphabet 'a' in the Transition Matrix
% input: DFA, source state q, destination state qt, 'a' is the alpahbet
% output: updated DFA

function dfa = SetTransition(dfa, q, a, qt)
     col_position =  find(strcmp(dfa.Alphabets, a));
     row_position = find(dfa.FiniteSetOfStates == q);
     
     dfa.TransitionMatrix(row_position, col_position) = qt;
end