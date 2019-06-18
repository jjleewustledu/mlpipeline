classdef (Abstract) ISessionData
	%% ISESSIONDATA 

	%  $Revision$
 	%  was created 28-Jan-2016 22:45:12
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
	
	properties (Abstract)        
        rawdataPath
        rawdataFolder % \in sessionFolder
        
        studyData
        
        projectsDir % homolog of __Freesurfer__ subjectsDir
        projectsPath
        projectsFolder
        projectData
        projectPath
        projectFolder % \in projectsFolder
        
        subjectsDir % __Freesurfer__ convention
        subjectsPath
        subjectsFolder
        subjectData
        subjectPath
        subjectFolder % \in subjectsFolder
        
        sessionPath
        sessionFolder % \in projectFolder
        
        scanPath
        scanFolder % \in sessionFolder
        
        absScatterCorrected
        attenuationCorrected
        frame
        isotope
        region
        tracer
    end
    
	methods (Abstract)
        obj  = ctObject(this)
               diaryOff(this)
               diaryOn(this)
        obj  = mrObject(this)
        obj  = petObject(this)
        dt   = datetime(this)
        obj  = fqfilenameObject(this)
        obj  = freesurferObject(this)
        tf   = isequal(this)
        tf   = isequaln(this)
        loc  = saveWorkspace(this)
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
    
 end

