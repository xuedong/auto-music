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
% sorting an array 

function X = LEXSORT(array)
    len = length(array);
    if(len<=1)
        X = array;
        return;
    end
    
    % selecting pivot for quick sort
    
    pivot_index = ceil(len/2);
    pivot(1) = array(pivot_index);
    array(pivot_index) = [];
    len = length(array);
    
    less = {};
    greater = {};
    
    for i = 1:len
       lex_value = LEXICALCMP(array{i}, pivot{1}); 
       if(lex_value==-1 || lex_value == 0)
           less(length(less)+1) = array(i);
       else
           greater(length(greater)+1) = array(i);
       end
    end
    
    less = LEXSORT(less);
    greater = LEXSORT(greater);   
    X = {less{:}, pivot{:}, greater{:}}'; 
end