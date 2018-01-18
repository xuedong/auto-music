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
% Read samples from file and convert it into a Ktestable language
% Input: filename,the path of sample file
%        k, the learning parameter k
% Output: return a K-testable language
% see also KSET, K2dfa

function kset = KBuilder(positive, k)
%KBUILDER Summary of this function goes here
%   Detailed explanation goes here
    alphabet = [];
    I = {};
    I_str = {};
    C = {};
    C_str = {};
    F = {};
    F_str = {};
    T = {};
    T_str = {};
    for i=1:length(positive)
        s = positive{i};
        if length(s) < k
            if ~ismember(mat2str(s), C_str)
                C{length(C)+1} = s;
                C_str{length(C_str)+1} = mat2str(s);
            end
        end
        if length(s) >= (k-1)
            if ~ismember(mat2str(s(1:(k-1))), I_str)
                I{length(I)+1} = s(1:(k-1));
                I_str{length(I_str)+1} = mat2str(s(1:(k-1)));
            end
            if ~ismember(mat2str(s((length(s)-k+2):length(s))), F_str)               
                F{length(F)+1} = s((length(s)-k+2):length(s));          
                F_str{length(F_str)+1} = mat2str(s((length(s)-k+2):length(s)));
            end
        end
        if length(s) >= k
            for index = 1:(length(s)-k+1)
                if ~ismember(mat2str(s(index:(index+k-1))), T_str)
                    T{length(T)+1} = s(index:(index+k-1));
                    T_str{length(T_str)+1} = mat2str(s(index:(index+k-1)));
                end
            end
        end
        for i = 1:length(s)
            if ~ismember(s(i), alphabet)
                alphabet(length(alphabet)+1) = s(i);
            end
        end
    end
    kset = KSET(alphabet, I, C, F, T);
end


