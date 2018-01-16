classdef NullDirector < mlpipeline.INull
	%% NULLDIRECTOR  

	%  $Revision$
 	%  was created 13-Jan-2018 23:56:57 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2018 John Joowon Lee.
 	
	properties
 		
 	end

	methods 
		  
 		function this = NullDirector(varargin)
 			%% NULLDIRECTOR
 			%  Usage:  this = NullDirector()

 			this = this@mlpipeline.INull(varargin{:});
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

