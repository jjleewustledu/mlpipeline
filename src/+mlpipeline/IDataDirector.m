classdef (Abstract) IDataDirector 
	%% IDATADIRECTOR  

	%  $Revision$
 	%  was created 02-Sep-2017 01:28:33 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.2.0.538062 (R2017a) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties (Abstract)     
        dataBuilder
        sessionData
        studyData 		
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

