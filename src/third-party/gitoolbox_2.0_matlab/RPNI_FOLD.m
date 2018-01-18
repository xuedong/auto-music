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
% This method will is a recursive fold function. It takes care of the non
% determinism of the DFA while merging two states.
% input: the dfa, state q1 and q2 to be merged.
% output: the updated DFA, where subtree in q2 is folded into q1.
% 
% When we start to fold q2 into q1, we check if q2 belongs to final states,
% if it does, then q1 should also be set as a final state.
% For each transition of q2: (q2, a) where a from the symbol set, 
%   1. if there's also a transition of q1 with respect to the same symbol 
%      'a' as q2, then we start to recursively fold q2's transitioned state
%      (q2, a) to q1's transitioned state (q1, a).
%   2. if there's no corresponding transition in q1, then we delete this 
%      transition from q2, and meanwhile add it to q1. That means:
%           (q1, a) <- (q2, a)
%           delete transition of q2 to (q2, a)
% Until there's no possible RPNI_FOLD
% RPNI_FOLD returns an new DFA.
% see also RPNI_MERGE

function dfa = RPNI_FOLD(dfa, q1, q2)
   % if the blue state is in the final states, then we also insert the red
   % state in final
   if(find(dfa.FinalAcceptStates == q2))
      dfa.FinalAcceptStates = union(dfa.FinalAcceptStates, q1);
   end 
   for i = 1:length(dfa.Alphabets) 
      a = dfa.Alphabets(i);
      transition_from_q2 = GetTransitionState(dfa, q2, a);
      transition_from_q1 = GetTransitionState(dfa, q1, a);      
      if(transition_from_q2~=0)
          if(transition_from_q1~=0)              
             dfa = RPNI_FOLD(dfa, transition_from_q1, transition_from_q2);
          else
             dfa = SetTransition(dfa, q1, a, transition_from_q2);          
             dfa = DeleteTransition(dfa, q2, a);
          end
      end
   end    
end