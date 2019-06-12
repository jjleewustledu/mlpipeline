classdef (Abstract) StudyRegistry < handle & mlpatterns.Singleton2
	%% STUDYREGISTRY  

	%  $Revision$
 	%  was created 11-Jun-2019 19:29:37 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.5.0.1067069 (R2018b) Update 4 for MACI64.  Copyright 2019 John Joowon Lee.
 	
    properties     
        atlVoxelSize = 222   
        comments = ''
        noclobber = true
    end
    
	properties (Dependent)
        debug
        keepForensics
        
        rawdataDir
        projectsDir
        subjectsDir
        YeoDir
    end
    
    methods
        
        %% GET, SET
        
        function g = get.debug(~)
            g = mlpipeline.ResourcesRegistry.instance().debug;
        end
        function     set.debug(~, s)
            inst = mlpipeline.ResourcesRegistry.instance();
            inst.debug = s;          
        end
        function g = get.keepForensics(~)
            g = mlpipeline.ResourcesRegistry.instance().keepForensics;
        end
        
        function x = get.rawdataDir(~)
            x = fullfile(getenv('PPG'), 'rawdata', '');
        end
        function g = get.projectsDir(~)
            g = getenv('PROJECTS_DIR');
        end        
        function     set.projectsDir(~, s)
            assert(isdir(s));
            setenv('PROJECTS_DIR', s);
        end
        function g = get.subjectsDir(~)
            g = getenv('SUBJECTS_DIR');
        end        
        function     set.subjectsDir(~, s)
            assert(isdir(s));
            setenv('SUBJECTS_DIR', s);
        end
        function g = get.YeoDir(this)
            g = this.subjectsDir;
        end
        
        %%        
        
        function       diaryOff(~)
            diary off;
        end
        function       diaryOn(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.projectsDir, @isdir);
            parse(ip, varargin{:});            
            diary(fullfile(ip.Results.path, sprintf('%s_diary_%s.log', mfilename('class'), mydatetimestr(now))));
        end
        function tf  = isChpcHostname(~)
            [~,hn] = mlbash('hostname');
            tf = lstrfind(hn, 'gpu') || lstrfind(hn, 'node') || lstrfind(hn, 'login') || lstrfind(hn, 'cluster');
        end
        function loc = saveWorkspace(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.projectsDir, @isdir);
            parse(ip, varargin{:});
            loc = fullfile(ip.Results.path, sprintf('%s_workspace_%s.mat', mfilename('class'), mydatetimestr(now)));
            save(loc);
        end
    end

	methods (Access = protected)		  
 		function this = StudyRegistry(varargin)
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

