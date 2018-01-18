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
% This method checks if two states outputs are identical or one of them is
% unknown, if not returns false.
% Input: Two strings output1 and output2
% Output: The common string or 0 if they are not identical
% See also: TRANSDUCER, BUILD_PTT, OSTIA_Merge, OSTIA_Fold, OSTIA, 
% OSTIA_PushBack, LongestCommonPrefix

function str = OSTIA_Outputs(output1, output2)
%OSTIA_OUTPUTS Summary of this function goes here
%   Detailed explanation goes here
    if strcmp(output1, '*')
        str = output2;
    else if strcmp(output2, '*')
            str = output1;
        else if strcmp(output1, output2)
                str = output1;
            else
                str = 0;
            end
        end
    end
end

