classdef AbstractDataDirector 
	%% ABSTRACTDATADIRECTOR  

	%  $Revision$
 	%  was created 03-Oct-2017 18:57:25 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.

	properties (Dependent)
 		builder
        sessionData
        studyData
    end

	methods 
        
        %% GET/SET
        
        function g = get.builder(this)
            g = this.builder_;
        end
        function g = get.sessionData(this)
            g = this.builder_.sessionData;
        end
        function g = get.studyData(this)
            g = this.builder_.sessionData.studyData;
        end
        
        function this = set.sessionData(this, s)
            assert(isa(s, 'mlpipeline.SessionData'));
            this.builder_.sessionData = s;
        end
        
        %% 
		  
 		function this = AbstractDataDirector(varargin)
 			%% ABSTRACTDATADIRECTOR
 			%  Usage:  this = AbstractDataDirector()
 			
            ip = inputParser;
            ip.KeepUnmatched = true;
            addRequired(ip, 'builder', @(x) isa(x, 'mlfourdfp.AbstractUmapResolveBuilder'));
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

