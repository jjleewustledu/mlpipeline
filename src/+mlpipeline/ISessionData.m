classdef (Abstract) ISessionData
	%% ISESSIONDATA  

	%  $Revision$
 	%  was created 28-Jan-2016 22:45:12
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
	
	properties (Abstract)
        project
        subject
        session
        scan
        resource
        assessor
        
        freesurfersPath
        freesurfersDir % homolog of subjectsDir
        freesurfersFolder
        
        rawdataPath
        rawdataDir % homolog of subjectsDir
        rawdataFolder
        
        sessionPath
        sessionDir % homolog of subjectsDir
        sessionFolder
        
        subjectsPath
        subjectsDir % Freesurfer convention
        subjectsFolder  
    end
    
	methods (Abstract)
        tf  = isequal(this)
        tf  = isequaln(this)
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
    
 end

