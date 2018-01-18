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
% Similar as other state merging algorithm, this method folds a tree rooted 
% at a blue state to the rest of Transducer.
% Input: Transducer T, red state qr, blue state qb
% Output: Updated Transducer T into which qb has been folded.
% See also: TRANSDUCER, BUILD_PTT, OSTIA, OSTIA_Merge, OSTIA_Outputs,
% OSTIA_PushBack, LongestCommonPrefix

function T = OSTIA_Fold(T, qr, qb)
%OSTIA_FOLD Summary of this function goes here
%   Detailed explanation goes here
    if ~isa(T, 'TRANSDUCER')
        return;
    else
        w = OSTIA_Outputs(T.StateOutputs{qr}, T.StateOutputs{qb});
        if w == 0
            % if the outputs of these two states are not identical, fold fail!
            T = 0;
            return;
        else
            T.StateOutputs{qr} = w;
            for i = 1:length(T.InAlphabets)
                if T.StateTransition(qb, i) ~= 0
                    if T.StateTransition(qr, i) ~= 0  
                        string_set = {T.OutputTransduction(qb, i), T.OutputTransduction(qr, i)};
                        lcs = LongestCommonPrefix(string_set);
                        if ~strcmp(lcs, T.OutputTransduction(qr, i))
                            T = 0;
                            return;
                        else
                            [T, pushed] = OSTIA_PushBack(T, qr, qb, i);
                            T = OSTIA_Fold(T, T.StateTransition(qr, i), T.StateTransition(qb, i));
                            if ~isa(T, 'TRANSDUCER')
                               break;
                            end
                        end                        
                    else
                        T.StateTransition(qr, i) = T.StateTransition(qb, i);
                        T.OutputTransduction{qr, i} = T.OutputTransduction{qb, i};
                    end
                end
            end
        end
    end
end

