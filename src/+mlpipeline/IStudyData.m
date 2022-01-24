classdef (Abstract) IStudyData < handle
	%% ISTUDYHANDLE  

	%  $Revision$
 	%  was created 05-Sep-2018 20:03:19 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.4.0.813654 (R2018a) for MACI64.  Copyright 2018 John Joowon Lee.
 	
	properties (Abstract)
        rawdataDir 	
        projectsDir
        subjectsDir
    end
    
    methods (Abstract)
        diaryOff(this)
        diaryOn(this)
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

