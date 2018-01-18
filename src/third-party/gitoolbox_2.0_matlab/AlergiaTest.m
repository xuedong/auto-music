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
% Test function for Alergia algorithm. Given two probabilities,
% examine if they're sufficiently close.
% Input: A DFFA, frequency (f1,n1,f2,n2), a parameter alpha
% Output: A Boolean indicating if the frequencies f1/n1 and f2/n2 are close
% see also AlergiaStochasticFold, AlergiaStochasticMerge, AlergiaCompatible, AlergiaPromote

function flag = AlergiaTest(dffa, f1, n1, f2, n2, alpha)
%ALERGIATEST test the similarity of two probabilities
    gamma = abs(f1/n1 - f2/n2);
    % if two probabilities is less than some threshold, then return true,
    % else false
    flag = (gamma < (sqrt(1/n1) + sqrt(1/n2))*sqrt(log(2/alpha)/2));
end

