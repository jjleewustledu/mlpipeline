classdef ISessionData 
	%% ISESSIONDATA  

	%  $Revision$
 	%  was created 28-Jan-2016 22:45:12
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	
	
	properties (Abstract)
        subjectsDir
    end

	methods (Abstract)
        loc = sessionLocation(this)
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

