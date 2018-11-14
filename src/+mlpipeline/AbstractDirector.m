classdef (Abstract) AbstractDirector < mlpipeline.IDirector
	%% ABSTRACTDIRECTOR
    %  See also:  mlxnat.*.

	%  $Revision$
 	%  was created 03-Oct-2017 18:57:25 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.

	properties (Dependent)
 		builder
        
        project
        subject
        session
        scan
        resource
        assessor
        
        studyData   % legacy
        sessionData %
    end

	methods 
        
        %% GET/SET
        
        function g = get.builder(this)
            g = this.builder_;
        end
        function g = get.project(this)
            g = this.studyData;
        end
        function g = get.subject(this)
            g = [];
        end
        function g = get.session(this)
            g = this.sessionData;
        end
        function g = get.scan(this)
            g = [];
        end
        function g = get.resource(this)
            g = [];
        end
        function g = get.assessor(this)
            g = [];
        end
        function g = get.studyData(this)
            g = this.builder_.sessionData.studyData;
        end
        function g = get.sessionData(this)
            g = this.builder_.sessionData;
        end        
        
        function this = set.session(this, s)
            this.sessionData = s;
        end
        function this = set.sessionData(this, s)
            assert(isa(s, 'mlpipeline.SessionData'));
            this.builder_.sessionData = s;
        end
        
        %% 
		  
 		function this = AbstractDirector(varargin)
 			%% ABSTRACTDIRECTOR
 			%  @param builder is mlpipeline.IBuilder
 			
            ip = inputParser;
            ip.KeepUnmatched = true;
            addRequired(ip, 'builder', @(x) isa(x, 'mlpipeline.IBuilder'));
            parse(ip, varargin{:});
 			this.builder_ = ip.Results.builder;
 		end
 	end 
    
    %% PROTECTED
    
    properties (Access = protected)
        builder_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
    
 end

