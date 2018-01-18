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
% this is an auxiliary function that return the source state of a
% trantition, i.e., if there is a transition q1 ->(a) q2, given q2 and 'a' as input it
% will return q1, independent of the alphabet that causes that transition.
% in case of multiple sources it shows an error that PTA of the RPNI
% algorithm has not been constructed accurately
% input: DFA, destination state q2, 'a' is the alpahbet
% output: source state q1. A 0 is returned if no source exist

function q1 = GetSourceState(dfa, q2, a)
    q1 = 0; 
    col =  find(strcmp(dfa.Alphabets, a));
  
    array = dfa.TransitionMatrix(:,col);
    
    q1 = find(array==q2);
    
%   needs clarification
    if(length(q1)>1)
        display('double');
        q1 = q1(1);
    end
end