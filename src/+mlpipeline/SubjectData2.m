classdef (Abstract) SubjectData2 < handle & mlpipeline.ImagingData & mlpipeline.ISubjectData2
	%% SUBJECTDATA2 organizes a unique subject identity.
    %
	%  $Revision$
 	%  was created 05-May-2019 22:07:32 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.5.0.1067069 (R2018b) Update 4 for MACI64.  Copyright 2019 John Joowon Lee.
 	
	properties (Dependent)
        subjectsDir % __Freesurfer__ convention
        subjectsPath 
        subjectsFolder 
        subjectPath
        subjectFolder % \in subjectsFolder 
 	end

	methods % GET/SET
        function g = get.subjectsDir(this)
            g = this.pipelineData_.datasetDir;
        end
        function g = get.subjectsPath(this)
            g = this.pipelineData_.datasetPath;
        end
        function g = get.subjectsFolder(this)
            g = this.pipelineData_.datasetFolder;
        end
        function g = get.subjectPath(this)
            g = this.pipelineData_.dataPath;
        end
        function     set.subjectPath(this, s)
            this.pipelineData_.dataPath = s;
        end
        function g = get.subjectFolder(this)
            g = this.pipelineData_.dataFolder;
        end        
        function     set.subjectFolder(this, s)
            this.pipelineData_.dataFolder = s;
        end   
    end
    
    methods		  
        function this = SubjectData2(mediator, varargin)
            this = this@mlpipeline.ImagingData(mediator);
            this.pipelineData_ = mlpipeline.PipelineData(varargin{:});
            setenv('SUBJECTS_DIR', this.subjectsDir);
 		end
    end 
    
    %% PROTECTED
    
    properties (Access = protected)
        pipelineData_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

