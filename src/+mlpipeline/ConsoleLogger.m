classdef ConsoleLogger < mlpipeline.Logger
	%% CONSOLELOGGER   

	%  $Revision: 2647 $ 
 	%  was created $Date: 2013-09-21 17:59:08 -0500 (Sat, 21 Sep 2013) $ 
 	%  by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2013-09-21 17:59:08 -0500 (Sat, 21 Sep 2013) $ 
 	%  and checked into repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/src/+mlpipeline/trunk/ConsoleLogger.m $,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id: ConsoleLogger.m 2647 2013-09-21 22:59:08Z jjlee $  	 

	methods 
        function this = ConsoleLogger(varargin)
            %% CTOR opens logging file with requested file-permissions
            %  Usage:   this = Logger([fname, perm])
            %                          ^ logging filename, default is stdout
            %                                 ^ fopen permissions, default is 'a+'
            
            this = this@mlpipeline.Logger(varargin{:});
        end % ctor     
    end
    

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

