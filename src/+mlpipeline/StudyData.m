classdef (Abstract) StudyData < handle & mlpipeline.IStudyData
	%% STUDYDATA  

	%  $Revision$
 	%  was created 21-Jan-2016 15:29:29
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	    
    properties (Dependent)
        rawdataDir
        projectsDir
        subjectsDir
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
        
        function g = get.rawdataDir(this)
            g = this.registry_.rawdataDir;
        end
        function g = get.projectsDir(this)
            g = this.registry_.projectsDir;
        end
        function g = get.subjectsDir(this)
            g = this.registry_.subjectsDir;
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
        
        %%
        
        function        diaryOff(~)
            diary off;
        end
        function        diaryOn(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.subjectsDir, @isdir);
            parse(ip, varargin{:});            
            diary( ...
                fullfile(ip.Results.path, sprintf('%s_diary_%s.log', mfilename, mydatetimestr(now))));
        end
        function tf   = isChpcHostname(~)
            [~,hn] = hostname;
            tf = lstrfind(hn, 'gpu') || lstrfind(hn, 'node') || lstrfind(hn, 'login') || lstrfind(hn, 'cluster');
        end
        function loc  = saveWorkspace(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.projectsDir, @isdir);
            parse(ip, varargin{:});
            loc = fullfile(ip.Results.path, sprintf('%s_workspace_%s.mat', mfilename, mydatetimestr(now)));
            save(loc);
        end
        
        %%
        
 		function this = StudyData(varargin)
            ip = inputParser;
            addRequired( ip, 'registry')
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

