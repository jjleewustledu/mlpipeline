classdef AbstractDataBuilder < mlpipeline.IDataBuilder
	%% ABSTRACTDATABUILDER  

	%  $Revision$
 	%  was created 01-Feb-2017 22:41:34
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.1.0.441655 (R2016b) for MACI64.
 	

	properties 		
 		keepForensics
    end
    
    properties (Dependent)
        logger
        product        
        sessionData
        studyData
 	end

	methods %% GET
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
    end 
    
    methods 
        function this = AbstractDataBuilder(varargin)            
 			ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'sessionData', [], @(x) isa(x, 'mlpipeline.ISessionData'));
            parse(ip, varargin{:});
            
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

