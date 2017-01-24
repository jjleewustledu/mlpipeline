classdef IImageBuilder < mlpipeline.IDataBuilder
	%% IIMAGEBUILDER  

	%  $Revision$
 	%  was created 06-Jan-2017 18:33:36
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.1.0.441655 (R2016b) for MACI64.
 	

	properties (Abstract)
        referenceImage
        referenceWeight
        sourceImage
        sourceWeight
 	end

	methods (Abstract)		  
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

