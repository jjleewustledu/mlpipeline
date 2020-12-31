classdef (Abstract) IBuilder 
	%% IBUILDER is an interface for builder design patterns.

	%  $Revision$
 	%  was created 06-Jan-2017 18:01:12
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.1.0.441655 (R2016b) for MACI64. 	

	properties (Abstract)
        buildVisitor
        finished
        logger
        product
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

