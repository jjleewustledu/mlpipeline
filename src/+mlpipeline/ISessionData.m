classdef (Abstract) ISessionData 
	%% ISESSIONDATA  

	%  $Revision$
 	%  was created 28-Jan-2016 22:45:12
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	
	
	properties (Abstract)
        filetypeExt
        rawdataDir % homolog of subjectsDir
        sessionFolder
        sessionPath
        subjectsDir % Freesurfer convention
        subjectsFolder  
        vfolder
        vnumber
    end

    methods (Static, Abstract)
        [s,r] = nifti_4dfp_4(~)
        [s,r] = nifti_4dfp_n(~)
        [s,r] = nifti_4dfp_ng(~)
        fn    = niigzFilename(~)
    end
    
	methods (Abstract)
        loc = sessionLocation(this)
        loc = vLocation(this)
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
    
 end

