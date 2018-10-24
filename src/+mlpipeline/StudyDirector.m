classdef StudyDirector 
	%% STUDYDIRECTOR  

	%  $Revision$
 	%  was created 05-Sep-2018 16:16:44 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.4.0.813654 (R2018a) for MACI64.  Copyright 2018 John Joowon Lee.
 	
	properties
 		
 	end

	methods 
		  
 		function this = StudyDirector(varargin)
 			ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'sessionData', [], @(x) isa(x, 'mlpipeline.ISessionData'));
            parse(ip, varargin{:});            
            this.sessionData_ = ip.Results.sessionData;  
 		end
 	end 
    
    %% PRIVATE
    
    properties (Access = private)
        sessionData_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

