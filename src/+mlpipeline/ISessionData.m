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
        subjectsDir
        subjectsFolder
        
        attenuationCorrected
        pnumber
        rnumber
        snumber
        tracer
        vnumber
    end

    methods (Static, Abstract)
        fn    = fslchfiletype(fn, ~)
        fn    = mri_convert(fn, ~)
        [s,r] = nifti_4dfp_4(~)
        [s,r] = nifti_4dfp_n(~)
        [s,r] = nifti_4dfp_ng(~)
        fn    = niigzFilename(~)
    end
    
	methods (Abstract)
        loc = freesurferLocation(this)
        loc = fslLocation(this)
        loc = mriLocation(this)
        loc = petLocation(this)
        loc = sessionLocation(this)
        loc = tracerLocation(this)
        loc = tracerResolved(this)
        loc = tracerResolvedFinal(this)
        loc = tracerResolvedFinalSumt(this)
        loc = tracerResolvedSumt(this)
        loc = tracerRevision(this)
        loc = tracerRevisionSumt(this)
        loc = vLocation(this)
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
    
 end

