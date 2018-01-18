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
% Basically RPNI_PROMOTE will promote a BLUE state to RED and add
% additional BLUE states ib the set BLUE if necessary and return a DFA with
% update sets of RED and BLUE states. As optional output parameter it will
% also return the ste of RED and the BLUE states.
%    
% RPNI_PROMOTE(blue, dfa) needs two parameters: 
%   'blue' is the to be promoted blue state; 
%   'dfa' is the DFA of the blue state;
% The blue state will be added to the current set of red states, and then
% all the existing successors of this blue state will be transformed to be
% blue states which are then added to the set of blue states.

function [dfa, RED, BLUE] = RPNI_PROMOTE(blue, dfa)
    dfa.RED = union(dfa.RED, blue);
    RED = dfa.RED;
    for i = 1:length(dfa.Alphabets)
        if(GetTransitionState(dfa, blue, dfa.Alphabets(i))~=0) %0 represents no state transition        
             dfa.BLUE = union(dfa.BLUE, GetTransitionState(dfa, blue, dfa.Alphabets(i)));
        end
    end
    BLUE = dfa.BLUE;
end