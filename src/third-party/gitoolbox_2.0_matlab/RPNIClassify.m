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
% RPNICLASSIFY classifies data usingthe RPNI algorithm method
% CLASS = RPNICLASSIFY(SAMPLE,TRAINING,GROUP) classifies each row of the
% data in SAMPLE into one of the groups in TRAINING using the RPNI algorithm. 
% GROUP is a grouping variable for TRAINING. Its unique values define groups, 
% and each element defines the group to which the corresponding row of TRAINING 
% belongs. GROUP can only be a numeric vector with two labels 0 and 1. 
% 1 to indicate the positive samples and 0 for the negative samples TRAINING and 
% GROUP must have the same number of rows. CLASS indicates which group each 
% row of SAMPLE has been assigned to, and is of the same type as GROUP.

function class = RPNIClassify(sample, training, group)
    % sort of positive and negetive sample from the training dataset
    positive = [];
    negative = [];
    for i = 1:length(training)
        if(group(i)==1)
            positive = [positive; training(i)];
        else
            negative = [negative; training(i)];
        end
    end
    
    % get the DFA from the training data
    dfa = RPNI(positive, negative);
    save('dfa_final.mat', 'dfa');
    class = [];
    for i = 1:length(sample)
        str = char(strrep(sample(i), ' ', ''));
        class = [class; IsStringAccepted(str, dfa)];        
    end        
end
