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
% Data structure for transducer

classdef TRANSDUCER   
    properties
        FiniteSetOfStates      % A set of states
        InAlphabets            % A set of input alphabets 
        OuAlphabets            % A set of output alphabets  
        InitialState           % initial state
        StateTransition        % Transition from state q to q'
        OutputTransduction     % Tranduction by input character
        StateOutputs           % The output function at each state
        RED                    % The red set
        BLUE                   % The blue set
    end
    
    methods
        function obj = TRANSDUCER(q, ia, oa, i, st, ot, so, red, blue)
            obj.FiniteSetOfStates = q;
            obj.InAlphabets = ia;
            obj.OuAlphabets = oa;
            obj.InitialState = i;
            obj.StateTransition = st;
            obj.OutputTransduction = ot;
            obj.StateOutputs = so;
            obj.RED = red;
            obj.BLUE = blue;
       end
    end  
end

