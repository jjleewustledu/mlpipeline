classdef (Sealed) ResourcesRegistry < handle & mlpatterns.Singleton2
	%% RESOURCESREGISTRY provides global settings for mlpipeline, mlfourdfp, mlfourd, mlnipet.

	%  $Revision$
 	%  was created 11-Jun-2019 21:32:00 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.5.0.1067069 (R2018b) Update 4 for MACI64.  Copyright 2019 John Joowon Lee.
 	
	properties 	
        dicomExtension = '.dcm'	
        imagingContextCompatibility = false
        keepForensics = true 
        preferredTimeZone = 'America/Chicago'
    end
    
    properties (Dependent)
        alpha % significance level
        defaultN % imgreg_4dfp
        ignoreFinishMark % *T4ResolveBuilder
        matlabDrive
        neverMarkFinished % *T4ResolveBuilder
    end
    
    methods        
        %% GET, SET
        
        function g = get.alpha(this)
            g = this.alpha_;
        end
        function     set.alpha(this, s)
            assert(isnumeric(s) && eps < s && s < 1);
            this.alpha_ = s;
        end
        function g = get.defaultN(this)
            g = this.defaultN_;
        end
        function set.defaultN(this, s)
            assert(islogical(s));
            this.defaultN_ = s;
        end
        function g = get.ignoreFinishMark(this)
            g = this.ignoreFinishMark_;
        end
        function g = get.matlabDrive(~)
            g = fullfile(getenv('HOME'), 'MATLAB-Drive', '');
        end
        function g = get.neverMarkFinished(this)
            g = this.neverMarkFinished_;
        end
    end
    
    methods (Static)
        function this = instance(varargin)
            %% INSTANCE
            %  @param optional qualifier is char \in {'initialize' ''}
            
            ip = inputParser;
            addOptional(ip, 'qualifier', '', @ischar)
            parse(ip, varargin{:})
            
            persistent uniqueInstance
            if (strcmp(ip.Results.qualifier, 'initialize'))
                uniqueInstance = [];
            end          
            if (isempty(uniqueInstance))
                this = mlpipeline.ResourcesRegistry();
                uniqueInstance = this;
            else
                this = uniqueInstance;
            end
        end
    end 
    
    %% PRIVATE
    
    properties (Access = private)
        alpha_
        defaultN_  
        ignoreFinishMark_
        neverMarkFinished_
    end

	methods (Access = private)		  
 		function this = ResourcesRegistry(varargin)
            this.alpha_ = 0.05;
            this.defaultN_ = true;            
            this.ignoreFinishMark_ = false;
            this.neverMarkFinished_ = false;
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

