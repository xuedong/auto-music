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
% 
% --------------------
% This is an auxiliary function for RPNI that add blue states to a newly merged
% dfa

function dfa = AddNewBlueStates(dfa)
    
    for i = 1:length(dfa.Alphabets)
       a = dfa.Alphabets(i); 
       for j = 1:length(dfa.RED)
           red = dfa.RED(j);
           transition_state = GetTransitionState(dfa, red, a);
           if(transition_state~=0)
                   if  (max(ismember(dfa.RED, transition_state))~=1)
                       dfa.BLUE = union(dfa.BLUE, transition_state);
                   end
           end
       end
    end

end