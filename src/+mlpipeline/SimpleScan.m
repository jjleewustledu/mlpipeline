classdef SimpleScan < mlpipeline.ScanData2 & handle
    %% line1
    %  line2
    %  
    %  Created 07-Mar-2023 00:00:37 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.13.0.2126072 (R2022b) Update 3 for MACI64.  Copyright 2023 John J. Lee.
    
    methods
        function this = SimpleScan(varargin)
            this = this@mlpipeline.ScanData2(varargin{:});
        end
    end
    
    methods (Static)
        function t = consoleTaus(tracer)            
            reg = mlpipeline.SimpleRegistry.instance();
            try
                t = reg.tausMap(tracer);
            catch
                t = [];
            end
        end
    end

    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
