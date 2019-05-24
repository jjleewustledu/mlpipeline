classdef AbstractDirector < mlpipeline.IDirector
	%% ABSTRACTDIRECTOR
    %  See also:  mlxnat.*.

	%  $Revision$
 	%  was created 03-Oct-2017 18:57:25 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.

	properties (Dependent)
 		builder
        sessionData
        xnat
    end

	methods 
        
        %% GET/SET
        
        function g = get.builder(this)
            g = this.builder_;
        end
        function g = get.sessionData(this)
            g = this.builder_.sessionData;
        end  
        function g = get.xnat(this)
            g = this.xnat_;
        end      
        
        function this = set.sessionData(this, s)
            assert(isa(s, 'mlpipeline.ISessionData'));
            this.builder_.sessionData = s;
        end
        function this = set.xnat(this, s)
            assert(isa(s, 'mlxnat.Xnat'));
            this.xnat_ = s;
        end
        
        %% 
		  
 		function this = AbstractDirector(varargin)
 			%% ABSTRACTDIRECTOR
 			%  @param required builder is mlpipeline.IBuilder.
            %  @param sessionData is mlpipeline.ISessionData.
            %  @param xnat is mlxnat.Xnat.
 			
            ip = inputParser;
            ip.KeepUnmatched = true;
            addRequired(ip, 'builder', @(x) isa(x, 'mlpipeline.IBuilder'));
            addParameter(ip, 'sessionData', [], @(x) isa(x, 'mlpipeline.ISessionData'));
            addParameter(ip, 'xnat', [], @(x) isa(x, 'mlxnat.Xnat'));
            parse(ip, varargin{:});
 			this.builder_ = ip.Results.builder;
            if (~isempty(ip.Results.sessionData))
                this.builder_.sessionData = ip.Results.sessionData;
            end
            this.xnat_ = ip.Results.xnat;
 		end
 	end 
    
    %% PROTECTED
    
    properties (Access = protected)
        builder_
        xnat_
    end
    
    %% HIDDEN
    
    methods (Hidden)
        function this = setBuilder__(this, s)
            %% for testing, debugging
            
            this.builder_ = s;
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
    
 end

