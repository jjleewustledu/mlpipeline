classdef (Abstract) ISessionContext 
	%% ISESSIONCONTEXT  

	%  $Revision$
 	%  was created 30-May-2018 00:27:25 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.4.0.813654 (R2018a) for MACI64.  Copyright 2018 John Joowon Lee.
 	
	properties (Abstract)
        freesurfersDir
        rawdataDir % homolog of subjectsDir
        sessionDate
        sessionFolder
        sessionPath
        subjectsDir % Freesurfer convention
        subjectsFolder
        vfolder
        vnumber
    end

	methods (Abstract)
        aparcA2009sAseg(this)
        aparcAseg(this)
        brainmask(this)        
        sessionLocation(this)
        T1001(this)
        vLocation(this)	
        vallLocation(this)
  	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

