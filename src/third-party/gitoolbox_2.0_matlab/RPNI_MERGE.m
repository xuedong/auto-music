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
% This method will merge two states
% input: the dfa, state q1 and q2 to be merged, q1 is a member of RED and q2
% is a member of BLUE
% output: the updated DFA
% 
% First of all, we find out the precedessor(q_f) of BLUE state(q2),
% according to the principle of RPNI, this precedessor is unique.
% And then set the transition (q_f, a) as the RED state(q1).
% After operations above, a tree rooted at q2 will be isolated from DFA.
% Then we call RPNI_FOLD to concatenate this tree onto current DFA.
% RPNI_MERGE returns an updated DFA.
% see also RPNI_FOLD

function dfa = RPNI_MERGE(dfa, q1, q2)
    % first find a (q_f, a) such that del(q_f, a)<--q2
    for i = 1:length(dfa.Alphabets) 
            q_f = GetSourceState(dfa, q2, dfa.Alphabets(i));
            a = dfa.Alphabets(i);
            if(q_f~=0)
               break; 
            end
    end
    if(length(q_f)>1)
        display(q_f);
    end
    % Set the transition (q_f, a) as q1
    dfa = SetTransition(dfa, q_f, a, q1);  
    dfa = RPNI_FOLD(dfa, q1, q2);
end