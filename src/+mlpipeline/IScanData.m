classdef IScanData 
	%% ISCANDATA  

	%  $Revision$
 	%  was created 11-Jun-2017 12:58:50 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.2.0.538062 (R2017a) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties (Abstract)
        aifData % is mlpet.IAifData
        clocks
        dose
        doseAdminDatetime
        scannerData % is mlpet.IScannerData
 		sessionData
        snumber
        tracer
        
        phantomDecayCorrSpecificActivity        
        wellCountDecayCorrSpecificActivity
        aifCountDecayCorrSpecificActivity
        scannerDecayCorrSpecificActivity
 	end

	methods (Abstract)
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

