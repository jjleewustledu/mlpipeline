classdef PipelineData
    %% PIPELINEDATA gathers filesystem specifiers and other data commonly structured in
    %  classes such as ScanData, SessionData, SubjectData, ProjectData, StudyData.
    %  
    %  Created 04-Feb-2023 13:10:17 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.13.0.2126072 (R2022b) Update 3 for MACI64.  Copyright 2023 John J. Lee.
    
	properties (Dependent)        
        datasetDir % __Freesurfer__ convention
        datasetPath 
        datasetFolder 
        dataPath
        dataFolder % \in sessionFolder
    end

    methods % GET/SET
        function g    = get.datasetDir(this)
            g = myfileparts(this.dataPath_);
        end
        function g    = get.datasetPath(this)
            g = this.datasetDir;
        end
        function g    = get.datasetFolder(this)
            g = mybasename(this.datasetDir);
        end
        function g    = get.dataPath(this)
            g = this.dataPath_;
        end
        function this = set.dataPath(this, s)
            assert(istext(s));
            this.dataPath_ = s;
        end
        function g    = get.dataFolder(this)
            g = mybasename(this.dataPath_);
        end        
        function this = set.dataFolder(this, s)
            assert(istext(s));
            this.dataPath_ = fullfile(this.datasetDir, s);
        end            
    end
    
    methods
        function this = PipelineData(opts)
            arguments
                opts.dataPath {mustBeFolder} = pwd
                opts.dataFolder = "" % support for legacy option
            end
            this.dataPath_ = opts.dataPath;
            if ~strcmp(opts.dataFolder, "")
                this.dataPath_ = fullfile(this.dataPath_, opts.dataFolder);
            end
        end
    end

    %% PROTECTED
    
    properties (Access = protected)
        dataPath_
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
