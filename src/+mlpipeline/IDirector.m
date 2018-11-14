classdef (Abstract) IDirector 
	%% IDIRECTOR  
    %  See also mlxnat.*.

	%  $Revision$
 	%  was created 14-Nov-2018 00:59:34 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.4.0.813654 (R2018a) for MACI64.  Copyright 2018 John Joowon Lee.

	properties (Abstract)
 		builder
        
        project
        subject
        session
        scan
        resource
        assessor
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

