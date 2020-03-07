classdef AbstractHandleSessionBuilder < handle & mlpipeline.AbstractHandleBuilder
	%% ABSTRACTHANDLESESSIONBUILDER  

	%  $Revision$
 	%  was created 18-Dec-2018 22:08:02 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.4.0.813654 (R2018a) for MACI64.  Copyright 2018 John Joowon Lee.
 	
	properties (Dependent)
 		sessionData
 	end

	methods 
        
        %% GET, SET
        
        function g = get.sessionData(this)
            g = this.sessionData_;
        end
        function set.sessionData(this, s)
            assert(isa(s, 'mlpipeline.ISessionData'));
            this.sessionData_ = s;
        end
		  
        %%
        
 		function this = AbstractHandleSessionBuilder(varargin)
 			%% ABSTRACTHANDLESESSIONBUILDER
 			%  @param .

 			this = this@mlpipeline.AbstractHandleBuilder(varargin{:});
            ip = inputParser;
            ip.KeepUnmatched = true;            
            addParameter(ip, 'sessionData', [], @(x) isa(x, 'mlpipeline.ISessionData'));
            parse(ip, varargin{:});
            this.sessionData_ = ip.Results.sessionData;
            this = this.setLogPath(fullfile(this.sessionData_.tracerLocation, 'Log', ''));
 		end
 	end 
    
    %% PROTECTED
    
    properties (Access = protected)
        sessionData_
    end
    
    %% PRIVATE
    
    methods (Access = private)
        function t = sessionTag(this)
            t = [myclass(this) '_' this.sessionData.tracerRevision('typ','fp')];            
            p = this.product_;
            if (isempty(p))
                return
            end
            t = [t '_' myclass(p)];
            if (~isprop(p, 'fileprefix'))
                return
            end
            t = [t '_' p.fileprefix];
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

