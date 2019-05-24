classdef (Abstract) StudyData < handle & mlpipeline.IStudyData
	%% STUDYDATA  

	%  $Revision$
 	%  was created 21-Jan-2016 15:29:29
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	    
    properties (Dependent)
        atlVoxelSize
        dicomExtension
        noclobber
        
        rawdataDir
        projectsDir
        subjectsDir
        YeoDir
    end
    
    properties
        comments
    end
    
	methods 
        
        %% GET
        
        function g = get.atlVoxelSize(this)
            g = this.registryInstance.atlVoxelSize;            
        end
        function g = get.dicomExtension(this)
            g = this.registryInstance.dicomExtension;
        end
        function g = get.noclobber(this)
            g = this.registryInstance.noclobber;
        end
        function g = get.rawdataDir(this)
            g = this.registryInstance.rawdataDir;
        end
        function g = get.projectsDir(this)
            g = this.registryInstance.projectsDir;
        end
        function g = get.subjectsDir(this)
            g = this.registryInstance.subjectsDir;
        end
        function g = get.YeoDir(this)
            g = this.registryInstance.YeoDir;
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
            addParameter(ip, 'dicomExtension', '', @ischar);
            addParameter(ip, 'rawdataDir', '', @ischar);
            addParameter(ip, 'projectsDir', '', @ischar);
            addParameter(ip, 'subjectsDir', '', @ischar);
            addParameter(ip, 'YeoDir', '', @ischar);
            parse(ip, varargin{:});
            
            this.registryInstance = mlraichle.RaichleRegistry.instance();
            if ~isempty(ip.Results.dicomExtension)
                this.registryInstance.dicomExtension = ip.Results.dicomExtension;
            end
            if ~isempty(ip.Results.rawdataDir)
                this.registryInstance.rawdataDir = ip.Results.rawdataDir;
            end
            if ~isempty(ip.Results.projectsDir)
                this.registryInstance.projectsDir = ip.Results.projectsDir;
            end
            if ~isempty(ip.Results.subjectsDir)
                this.registryInstance.subjectsDir = ip.Results.subjectsDir;
            end
            if ~isempty(ip.Results.YeoDir)
                this.registryInstance.YeoDir = ip.Results.YeoDir;
            end
        end 
    end
    
    %% PROTECTED
    
    properties (Access = protected)
        registryInstance
    end
    
    %% HIDDEN LEGACY
    
    methods
        function a    = seriesDicomAsterisk(this, fqdn)
            assert(isdir(fqdn));
            assert(isdir(fullfile(fqdn, 'DICOM')));
            a = fullfile(fqdn, 'DICOM', ['*' this.dicomExtension]);
        end        
        function f    = subjectsDirFqdns(this)
            if (isempty(this.subjectsDir))
                f = {};
                return
            end            
            dt = mlsystem.DirTools(this.subjectsDir);
            f = {};
            for di = 1:length(dt.dns)
                if (strncmp(dt.dns{di}, 'sub-', 4))
                    f = [f dt.fqdns(di)]; %#ok<AGROW>
                end
            end
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

