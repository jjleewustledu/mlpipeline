classdef ISessionData 
	%% ISESSIONDATA  

	%  $Revision$
 	%  was created 28-Jan-2016 22:45:12
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	
	
	properties (Abstract)
        filetypeExt
        freesurfersDir
        sessionFolder
        sessionPath
        studyData
        subjectsDir
        subjectsFolder
        
        absScatterCorrected
        attenuationCorrected
        rnumber
        snumber
        vnumber
    end

    methods (Static, Abstract)
        fn    = fslchfiletype(fn, ~)
        fn    = mri_convert(fn, ~)
        [s,r] = nifti_4dfp_4(~)
        [s,r] = nifti_4dfp_n(~)
        [s,r] = nifti_4dfp_ng(~)
    end
    
	methods (Abstract)
        loc = sessionLocation(this)
        loc = vLocation(this)
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

