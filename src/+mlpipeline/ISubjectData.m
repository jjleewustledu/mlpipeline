classdef (Abstract) ISubjectData 
	%% ISUBJECTDATA manages a unique subject identity.

	%  $Revision$
 	%  was created 05-May-2019 23:27:36 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.5.0.1067069 (R2018b) Update 4 for MACI64.  Copyright 2019 John Joowon Lee.
 	
	properties (Abstract)
        TRACERS
        EXTS
        
 		subjectFolder
        subjectPath
        subjectsDir
 		subjectsStruct 
        
        projectsDir
 	end

	methods (Abstract)
        
        % XNAT -> BIDS
        ses = experimentID_to_ses(this, eid)
        fld = getProjectFolder(this, ses)
        pth = getProjectPath(this, ses)
        sub = subjectID_to_sub(this, sid) 
  	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

