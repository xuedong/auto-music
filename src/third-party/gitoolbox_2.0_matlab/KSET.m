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
% Here defines the data structure of K-testable language

classdef KSET
    % This class deinfes the KSET structure
    properties   
        Alphabets   % the set of alphabets
        ISET  % prefixes of length k-1 and suffixes (or finals) of length k-1   
        CSET   % short strings with length < k
        FSET   % prefixes of length k-1 and suffixes (or finals) of length k-1
        TSET  % allowed segments
    end
    
    methods
       function obj = KSET(a, i, c, f, t)
            obj.Alphabets = a;
            obj.ISET = i;
            obj.CSET = c;
            obj.FSET = f;
            obj.TSET = t;
       end        
    end
end

