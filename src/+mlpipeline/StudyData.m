classdef (Abstract) StudyData < handle & mlpipeline.IStudyData
	%% STUDYDATA  

	%  $Revision$
 	%  was created 21-Jan-2016 15:29:29
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	    
    properties (Dependent)
        projectsDir
        subjectsDir
        subjectsFolder
        YeoDir
        
        atlVoxelSize
        noclobber
        referenceTracer
    end
    
    properties
        comments
    end
    
	methods 
        
        %% GET
        
        function g = get.projectsDir(this)
            g = this.registry_.projectsDir;
        end
        function g = get.subjectsDir(this)
            g = this.registry_.subjectsDir;
        end
        function g = get.subjectsFolder(this)
            g = basename(this.subjectsDir);
        end
        function g = get.YeoDir(this)
            g = this.registry_.YeoDir;
        end  
        
        function g = get.atlVoxelSize(this)
            g = this.registry_.atlVoxelSize;            
        end
        function g = get.noclobber(this)
            g = this.registry_.noclobber;
        end
        function g = get.referenceTracer(this)
            g = this.registry_.referenceTracer;
        end
        function     set.referenceTracer(this, s)
            assert(ischar(s));
            this.registry_.referenceTracer = s;
        end
        
        %%
        
        function        diaryOff(~)
            diary off;
        end
        function        diaryOn(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.projectsDir, @isfolder);
            parse(ip, varargin{:});
            loc = fullfile(ip.Results.path, diaryfilename('obj', class(this)));
            diary(loc);
        end
        function loc  = saveWorkspace(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.projectsDir, @isfolder);
            parse(ip, varargin{:});
            loc = fullfile(ip.Results.path, matfilename('obj', class(this)));
            save(loc);
        end
        
 		function this = StudyData(varargin)
            ip = inputParser;
            addRequired(ip, 'registry')
            parse(ip, varargin{:});
            this.registry_ = ip.Results.registry;
        end 
    end
    
    %% PROTECTED
    
    properties (Access = protected)
        registry_
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

