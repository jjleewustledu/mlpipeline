classdef ScanData < mlpipeline.IScanData
	%% SCANDATA  

	%  $Revision$
 	%  was created 11-Jun-2017 12:57:12 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.2.0.538062 (R2017a) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties (Dependent)
        aifData % is mlpet.IAifData
        clocks
        dose
        doseAdminDatetime
        scannerData % is mlpet.IScannerData
 		sessionData
        snumber
        tracer
        
 	end

	methods 
        
        %% GET
        
        function g = get.aifData(this)
            g = this.aifData_;
        end
        function g = get.clocks(this)
            g = this.xlsxObj_.clocks;
        end
        function g = get.dose(this)
            g = this.xlsxObj_.dose;
        end
        function g = get.doseAdminDatetime(this)
            g = this.xlsxObj_.doseAdminDatetime;
        end
        function g = get.scannerData(this)
            g = this.scannerData_;
        end
        function g = get.sessionData(this)
            g = this.sessionData_;
        end
        function g = get.snumber(this)
            g = this.sessionData_.snumber;
        end
        function g = get.tracer(this)
            g = this.sessionData_.tracer;
        end
        
        %%
		  
 		function this = ScanData(varargin)
 			%% SCANDATA
 			%  Usage:  this = ScanData()

            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'aifData',     [], @(x) isa(x, 'mlpet.IAifData')          || isempty(x));
            addParameter(ip, 'scannerData', [], @(x) isa(x, 'mlpet.IScannerData')      || isempty(x));
            addParameter(ip, 'sessionData', [], @(x) isa(x, 'mlpipeline.ISessionData') || isempty(x));
            addParameter(ip, 'xlsxObj',     []);
            parse(ip, varargin{:});           
 			
            this.aifData_     = ip.Results.aifData;
            this.scannerData_ = ip.Results.scannerData;
            this.sessionData_ = ip.Results.sessionData;
            this.xlsxObj_     = ip.Results.xlsxObj;
 		end
    end 
    
    %% PROTECTED
    
    properties (Access = protected)
        aifCal_
        aifData_
        scannerCal_
        scannerData_
        sessionData_
        xlsxObj_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

