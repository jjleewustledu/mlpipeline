classdef TestData < handle & mlpipeline.IScanData2
    %% line1
    %  line2
    %  
    %  Created 06-Feb-2023 15:05:21 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.13.0.2126072 (R2022b) Update 3 for MACI64.  Copyright 2023 John J. Lee.

	properties
        scansDir % __Freesurfer__ convention
        scansPath 
        scansFolder 
        scanPath
        scanFolder % \in sessionFolder
    end
    methods
        function dt = datetime(~)
            dt = datetime('now');
        end
        function this = TestData()
        end
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
