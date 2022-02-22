classdef (Abstract) ISessionData
	%% ISESSIONDATA 

	%  $Revision$
 	%  was created 28-Jan-2016 22:45:12
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
	
	properties (Abstract)  
        studyData
        projectData
        subjectData     
        
        projectsFolder
        projectsDir % homolog of __Freesurfer__ subjectsDir
        projectsPath
        projectFolder % \in projectsFolder
        projectPath
        
        subjectsFolder
        subjectsDir % __Freesurfer__ convention
        subjectsPath
        subjectFolder % \in subjectsFolder
        subjectPath
        
        sessionFolder % \in projectFolder
        sessionPath
        
        scanFolder % \in sessionFolder
        scanPath
    end
    
	methods (Abstract)
        dt = datetime(this)
        %ds = datestr(this)
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
    
end
