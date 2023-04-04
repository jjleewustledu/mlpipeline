classdef SimpleSession < mlpipeline.SessionData2 & handle
    %% line1
    %  line2
    %  
    %  Created 07-Mar-2023 00:00:42 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.13.0.2126072 (R2022b) Update 3 for MACI64.  Copyright 2023 John J. Lee.
    
    properties
        defects = {}
    end

    methods
        function this = SimpleSession(varargin)
            this = this@mlpipeline.SessionData2(varargin{:});
            this.registry_ = mlsiemens.VisionRegistry.instance();
        end
    end

    %% PROTECTED

    methods (Access = ?mlpipeline.SessionData2)
        function buildRadmeasurements(~)
        end
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
