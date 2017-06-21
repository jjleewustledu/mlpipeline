classdef AbstractDataBuilder < mlpipeline.IDataBuilder
	%% ABSTRACTDATABUILDER  

	%  $Revision$
 	%  was created 01-Feb-2017 22:41:34
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.1.0.441655 (R2016b) for MACI64.  Copyright 2017 John Joowon Lee.
 	

	properties 		
 		keepForensics = true
    end
    
    properties (Dependent)
        logger
        product        
        sessionData
        studyData
 	end

	methods 
        
        %% GET
        
        function g = get.logger(this)
            g = this.logger_;
        end  
        function g = get.product(this)
            g = this.product_;
        end
        function g = get.sessionData(this)
            g = this.sessionData_;
        end
        function g = get.studyData(this)
            g = this.sessionData.studyData;
        end
        
        %%
        
        function this = AbstractDataBuilder(varargin)
            %% ABSTRACTDATABUILDER
            %  @params named 'logger' is an mlpipeline.AbstractLogger.
            %  @params named 'product' is the initial state of the product to build.
            %  @params named 'sessionData' is an mlpipeline.ISessionData.
            
 			ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'logger', mlpipeline.Logger, @(x) isa(x, 'mlpipeline.AbstractLogger'));
            addParameter(ip, 'product', []);
            addParameter(ip, 'sessionData', [], @(x) isa(x, 'mlpipeline.ISessionData'));
            parse(ip, varargin{:});
            
            this.logger_      = ip.Results.logger;
            this.product_     = ip.Results.product;
            this.sessionData_ = ip.Results.sessionData;
        end
    end
    
    %% PROTECTED
    
    properties (Access = protected)
        logger_
        product_
        sessionData_
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

