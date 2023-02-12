classdef (Abstract) ProjectData2 < handle & mlpipeline.ImagingData & mlpipeline.IProjectData2
	%% PROJECTDATA2 organizes a unique project, e.g., XNAT project.
    %
	%  $Revision$
 	%  was created 08-May-2019 19:15:11 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.5.0.1067069 (R2018b) Update 4 for MACI64.  Copyright 2019 John Joowon Lee.
 	
	properties (Dependent)
        projectsDir % homolog of __Freesurfer__ subjectsDir
        projectsPath
        projectsFolder
        projectPath % set using BIDs folders
        projectFolder % \in projectsFolder; set using BIDs folders
    end

	methods % GET/SET
        function g = get.projectsDir(this)
            g = this.pipelineData_.datasetDir;
        end
        function g = get.projectsPath(this)
            g = this.pipelineData_.datasetPath;
        end
        function g = get.projectsFolder(this)
            g = this.pipelineData_.datasetFolder;
        end
        function g = get.projectPath(this)
            g = this.pipelineData_.dataPath;
        end
        function     set.projectPath(this, s)
            this.pipelineData_.dataPath = s;
        end
        function g = get.projectFolder(this)
            g = this.pipelineData_.dataFolder;
        end        
        function     set.projectFolder(this, s)
            this.pipelineData_.dataFolder = s;
        end   
    end
    
	methods
        function this = ProjectData2(mediator, varargin)
            this = this@mlpipeline.ImagingData(mediator);
            this.pipelineData_ = mlpipeline.PipelineData(varargin{:});
 		end
    end 
    
    %% PROTECTED
    
    properties (Access = protected)
        pipelineData_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
end
