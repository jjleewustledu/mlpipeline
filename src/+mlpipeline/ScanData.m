classdef ScanData < mlpipeline.IScanData
	%% SCANDATA  

	%  $Revision$
 	%  was created 07-May-2019 15:15:21 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.5.0.1067069 (R2018b) Update 4 for MACI64.  Copyright 2019 John Joowon Lee.
 	
	properties (Dependent)
 		scanPath
 	end

	methods 
        function        diaryOff(~)
            diary off;
        end
        function        diaryOn(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.scanPath, @isdir);
            parse(ip, varargin{:});
            loc = fullfile(ip.Results.path, diaryfilename('obj', class(this)));
            diary(loc);
        end
        function loc  = saveWorkspace(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.scanPath, @isdir);
            parse(ip, varargin{:});
            loc = fullfile(ip.Results.path, matfilename('obj', class(this)));
            save(loc);
        end
		  
 		function this = ScanData(varargin)
 			%% SCANDATA
 			%  @param .
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

