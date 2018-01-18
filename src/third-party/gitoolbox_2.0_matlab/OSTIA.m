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
% OSTIA main function
% OSTIA stands for Onward Subsequential Transducer Inference Algorithm
% Given a dataset comprising pairs of input and output strings, OSTIA is
% able to learn a transducer from dataset in polynomial time.
% OSTIA starts with building a prefix tree transducer and make an onward
% operation on it, and then perform merging and folding processes to obtain
% a incompressible transducer.
% Input: Sample file name
% Output: A transducer T
% See also: TRANSDUCER, BUILD_PTT, OSTIA_Merge, OSTIA_Fold, OSTIA_Outputs,
% OSTIA_PushBack, LongestCommonPrefix
% ------------------------------------------------------------

function T = OSTIA(sample_file)
    % build PTT from sample
    T = BUILD_PTT(sample_file);
    % build onward PTT from PTT
    [T, f] = Onward_PTT(T, 1);
    % adding the red state
    T.RED = [T.RED, T.FiniteSetOfStates(1)];
    
    % adding the blue states
    for i = 1:length(T.InAlphabets)
        temp_blue = T.StateTransition(1, i);
        if(temp_blue~=0) 
            % 0 means no transition            
            T.BLUE = [T.BLUE, temp_blue];
        end
    end
    
    display('Start OSTIA on Onward-PTT....');
    while (~isempty(T.BLUE))
        % sorting BLUE SET
        T.BLUE = sort(T.BLUE);
        q_b = T.BLUE(1);
        
        % deleting the first element of BLUE
        T.BLUE = [T.BLUE(2:length(T.BLUE))];
        promote = 1;
        for i = 1:length(T.RED)
           display('start merge...')
           t_merged = OSTIA_Merge(T, T.RED(i), q_b);
           display('end merge...');
           if isa(t_merged, 'TRANSDUCER') 
               T = t_merged;
               T
               display('merge accepted')
               display(T.RED(i))
               display(q_b)
               promote = 0;
               break;
           end    
        end
        if (promote)
            display('promote...')
            T.RED = [T.RED, q_b];               
        end
        for i = 1:length(T.RED)
            % promote non-red successors of each red states to blue set
            for j = 1:length(T.InAlphabets)
                qr_succ = T.StateTransition(T.RED(i), j);
                if (qr_succ ~= 0)
                    if (find(T.RED == qr_succ))
                        continue;
                    else 
                        if (find(T.BLUE == qr_succ))
                            continue;
                        else
                            T.BLUE = [T.BLUE, qr_succ];                
                        end
                    end
                end
            end
        end
    end 
end

