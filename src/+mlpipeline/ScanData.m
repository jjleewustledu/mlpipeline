classdef ScanData < mlpipeline.IScanData
	%% SCANDATA  

	%  $Revision$
 	%  was created 07-May-2019 15:15:21 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.5.0.1067069 (R2018b) Update 4 for MACI64.  Copyright 2019 John Joowon Lee.
 	
	properties
 		
 	end

	methods 
		  
 		function this = ScanData(varargin)
 			%% SCANDATA
 			%  @param .

 			this = this@mlpipeline.IScanData(varargin{:});
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

