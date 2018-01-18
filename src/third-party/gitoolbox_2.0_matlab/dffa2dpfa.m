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
% This method converts a DFFA to a DPFA. This requires such condition
% fullfilled that the DFFA should be well defined which means the number
% of strings entering and leaving a state should be identical.
% Input: a well defined DFFA
% Output: corresponding DPFA

function dpfa = DFFA2DPFA(dffa)
%DFFA2DPFA converts DFFA to DPFA
    lenOfState = length(dffa.FiniteSetOfStates);
    freq = [];
    SetOfState = dffa.FiniteSetOfStates;
    alphabets = dffa.Alphabets;
    init = dffa.FiniteSetOfStates(1);
    fsp = zeros(lenOfState, 1);
    ptm = {[],[]};
    ptm{1} = dffa.FrequencyTransitionMatrix{1};
    atm = dffa.AssociateTransitionMatrix;
    red = dffa.RED;
    blue = dffa.BLUE;

    for i = 1:lenOfState
        freq(i) = dffa.FinalStateFrequency(i);
        for j = 1:length(dffa.Alphabets)
            % caculate number of all entering strings 
            freq(i) = freq(i) + dffa.FrequencyTransitionMatrix{2}(i, j);
        end
        fsp(i) = dffa.FinalStateFrequency(i)/freq(i);
        for j = 1:length(dffa.Alphabets)
            ptm{2}(i, j) = dffa.FrequencyTransitionMatrix{2}(i, j)/freq(i);
        end
    end
    dpfa = DPFA(SetOfState, alphabets, init, fsp, ptm, atm, red, blue);
end

