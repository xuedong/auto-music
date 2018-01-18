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
% The main MDI function, learning a PDFA from samples.
% The only difference between alergia and MDI is the compatibility tesing.
% Input: samples file, a parameter alpha
% Output: A DFFA and corresponding DPFA
% see also MDIStochasticMerge MDIStochasticFold, MDICompatible, MDIScore, MDIPromote

function [dffa, dpfa] = MDI(filename, alpha)
%MDI main function
    % caculate a t0, only the state with a frequency larger than t0 should
    % be able to be merged
    display('Start building FPTA')
    [dffa, train, numOfSamples] = Build_FPTA(filename);
    t0 = ceil(0.05 * numOfSamples);
    %t0 = 3;
    % initialize red and blue sets
    % adding the red states
    dffa.RED = [dffa.RED, dffa.FiniteSetOfStates(1)];    
    % adding the blue states
    for i = 1:length(dffa.Alphabets)
        temp_blue = dffa.AssociateTransitionMatrix(dffa.FiniteSetOfStates(1), i);
        if(temp_blue~=0) % 0 means no transition            
            dffa.BLUE = [dffa.BLUE, temp_blue];
        end
    end
    curr_score = MDIScore(train, dffa);
    display('Running MDI on FPTA....');
    while (~isempty(dffa.BLUE))
        % Random CHOOSE a blue state
        dffa.BLUE = sort(dffa.BLUE);
        q_b = dffa.BLUE(1);
        dffa.BLUE = dffa.BLUE(2:length(dffa.BLUE));
        promote = 1;
        if (FreqOfState(dffa, q_b) >= t0)
            for i = 1:length(dffa.RED)
                q_r = dffa.RED(i);
                [correct, dffa_merged] = MDICompatible(dffa, q_r, q_b, train, alpha);
                if (correct)
                    display('Merge accepted...');
                    display(q_r);
                    display(q_b);
                    dffa = dffa_merged;
                    promote = 0;
                    break;
                end
            end
            if (promote)
                display('Currently no merge is possible, promote...')
                dffa.RED = [dffa.RED, q_b];               
            end
            for i = 1:length(dffa.RED)
                % promote non-red successors of each red states to blue set
                for j = 1:length(dffa.Alphabets)
                    qr_succ = dffa.AssociateTransitionMatrix(dffa.RED(i), j);
                    if (qr_succ ~= 0)
                        if (find(dffa.RED == qr_succ))
                            continue;
                        else 
                            if (find(dffa.BLUE == qr_succ))
                                continue;
                            else
                                dffa.BLUE = [dffa.BLUE, qr_succ];                
                            end
                        end
                    end
                end
            end
        else
            continue;
        end       
    end
    dpfa = dffa2dpfa(dffa);
end

