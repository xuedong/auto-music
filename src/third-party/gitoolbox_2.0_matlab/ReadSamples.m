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
% This function will load the sample as an input for the into a matlab array 
%   input: 'file_name'as an input it takes the file name
%   output: [training, group, positive_samples, negative_samples]
%       training: this array contains all the training samples in the specified input file
%       group: this array contains the corresponding classes of training
%       negative_samples: this array contains all the negative samples of the training set
%       positive_samples: this array contains all the positive samples of the training set


function [training, group, positive_samples, negative_samples] = ReadSamples(file_name)
    fid = fopen(file_name,'r');     % 'rt' means "read text"
    if (fid < 0)
        error('could not open file');
    end;

    group = [];
    temp_s = '';
    training = [];
    negative_samples = [];
    positive_samples = [];
    
    s = fgetl(fid); % get a line and ignore the first line
    s = fgetl(fid); % get a line. From this line the real data starts

    % i is the row index for training data matrix
    i = 1;
    while (ischar(s))  % not eof                   
        %in the following two lines we ignore the first two columns
        starter = 1;
        number_of_empty_space = 0;
        label = '';
        for k = 1:length(s)
            if(number_of_empty_space ~= 1)            
                    label = strcat(label, s(k));
            end
            if strcmp(s(k),' ')
               number_of_empty_space = number_of_empty_space + 1;
                % adding the label

               if number_of_empty_space == 1
                  % adding the group information to the group matrix
                  if(strcmp(label, '1')==1)
                      group = [group;1];
                  else
                      group = [group;0];
                  end
               end
               if number_of_empty_space == 2
                   % initializing the starter
                  starter = k; 
                  break; 
               end
            end
        end

        training_row = [];
        training_row = s(starter:length(s));
        % adding positive sample
        if strcmp(label, '1')
            positive_samples{length(positive_samples) + 1, 1} = strrep(training_row, ' ', '');
        else
            negative_samples{length(negative_samples) + 1, 1} = strrep(training_row, ' ', '');
        end
        training{i,1} = strrep(training_row, ' ', '');
        i = i + 1;
        s = fgetl(fid);
    end