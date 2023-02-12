classdef (Abstract) IScanData2 < handle
    %% ISCANDATA specifies a unique scan.
    %  IScanData \in ISessionData \in ISubjectData \in IProjectData \in IStudyData
    %  
    %  Created 04-Feb-2023 00:03:15 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.13.0.2126072 (R2022b) Update 3 for MACI64.  Copyright 2023 John J. Lee.
    
	properties (Abstract)        
        scansDir % __Freesurfer__ convention
        scansPath 
        scansFolder 
        scanPath
        scanFolder % \in sessionFolder
    end

	methods (Abstract)
        dt = datetime(this)
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
