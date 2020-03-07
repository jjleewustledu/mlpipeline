classdef (Abstract) ILogger < handle & matlab.mixin.Copyable & mlpatterns.List
	%% ILOGGER  

	%  $Revision$
 	%  was created 28-Sep-2018 16:47:50 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.5.0.944444 (R2018b) for MACI64.  Copyright 2018 John Joowon Lee.
 	
    properties (Abstract, Constant)
        FILETYPE_EXT
        DATESTR_FORMAT
        TIMESTR_FORMAT
    end
    
	properties (Abstract)
        callerid
        contents
        creationDate
        echoToCommandWindow
        hostname
        includeTimeStamp 
        id % user id
        uname % machine id
 	end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

