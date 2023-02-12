classdef (Abstract) ISessionData2 < handle
	%% ISESSIONDATA2 specifies a unique session or experiment.
    %  IScanData \in ISessionData \in ISubjectData \in IProjectData \in IStudyData
    %
	%  $Revision$
 	%  was created 28-Jan-2016 22:45:12
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
	
	properties (Abstract)
        sessionsDir % __Freesurfer__ convention
        sessionsPath 
        sessionsFolder 
        sessionPath
        sessionFolder % \in sessionsFolder   
    end
    
	methods (Abstract)
        dt = datetime(this)
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
    
end
