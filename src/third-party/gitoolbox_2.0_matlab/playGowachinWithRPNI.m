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
% This file is used to test the dataset from Gowachin
% Input: paths for training set, test set, output file
% output: time overhead in seconds

function cost = playGowachinWithRPNI(trainfile, testfile, outfile )
    % start timer
    start = clock;  
    % start RPNI Algorithm
    [training, group, positive, negative] = ReadSamples(trainfile);
    dfa = RPNI(positive, negative);
    % stop timer when RPNI is finished
    finish = clock;
    time = finish - start;
    % caculate the overhead
    cost = time(4)*60*60 + time(5)*60 + time(6);
    
    % parse the test file in order to output the result of testing
    fo = fopen(outfile, 'w+');
    fi = fopen(testfile, 'r');

    startindex = 0;
    % ignore the first line
    str = fgetl(fi);

    while ~feof(fi)
        str = fgetl(fi);
        for i = 1:length(str)
        	if startindex == 2
        		break;
            end
        	if str(i) == ' '
            	startindex = startindex + 1;
            end
        end
        startindex = i;
        teststr = str(startindex:length(str));

        teststr = strrep(teststr, ' ', '');
        % if a string is accepted, then output 1 else 0
        if ~IsStringAccepted(teststr, dfa)
        	fprintf(fo, '0');
        	fprintf(fo, '\n');
        else 
            fprintf(fo, '1');
            fprintf(fo, '\n');
        end
    	startindex = 0;
    end
    fclose(fi);
    fclose(fo);
end

