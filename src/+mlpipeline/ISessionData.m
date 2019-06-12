classdef (Abstract) ISessionData
	%% ISESSIONDATA 

	%  $Revision$
 	%  was created 28-Jan-2016 22:45:12
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
	
	properties (Abstract)
        projectData
        subjectData
        %sessionData
        %scanData
        %assessorData
        %resourceData
        
        rawdataPath
        rawdataFolder % \in sessionFolder
        
        scanPath
        scanFolder % \in sessionFolder
        
        sessionPath
        sessionFolder % \in projectFolder
        
        projectPath
        projectFolder % \in projectsFolder
        
        projectsPath
        projectsDir % homolog of __Freesurfer__ subjectsDir
        projectsFolder
        
        subjectPath
        subjectFolder % \in subjectsFolder
        
        subjectsPath
        subjectsDir % __Freesurfer__ convention
        subjectsFolder  
        
        absScatterCorrected
        attenuationCorrected
        frame
        isotope
        region
        tracer
        useNiftyPet  
    end
    
	methods (Abstract)
        obj  = ctObject(this)
        obj  = mrObject(this)
        obj  = petObject(this)
        dt   = datetime(this)
        obj  = fqfilenameObject(this)
        obj  = freesurferObject(this)
        tf   = isequal(this)
        tf   = isequaln(this)
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
    
 end

