classdef (Abstract) SessionData2 < handle & mlpipeline.ImagingData & mlpipeline.ISessionData2
    %% SESSIONDATA2 organizes a unique session or experiment.
    %  
    %  Created 03-Feb-2023 23:47:15 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.13.0.2126072 (R2022b) Update 3 for MACI64.  Copyright 2023 John J. Lee.

	properties (Dependent)
        registry
        sessionsDir % __Freesurfer__ convention
        sessionsPath 
        sessionsFolder 
        sessionPath
        sessionFolder % \in sessionsFolder   
    end

    methods % GET/SET
        function g = get.registry(this)
            g = this.registry_;
        end

        function g = get.sessionsDir(this)
            g = this.pipelineData_.datasetDir;
        end
        function g = get.sessionsPath(this)
            g = this.pipelineData_.datasetPath;
        end
        function g = get.sessionsFolder(this)
            g = this.pipelineData_.datasetFolder;
        end
        function g = get.sessionPath(this)
            g = this.pipelineData_.dataPath;
        end
        function     set.sessionPath(this, s)
            this.pipelineData_.dataPath = s;
        end
        function g = get.sessionFolder(this)
            g = this.pipelineData_.dataFolder;
        end        
        function     set.sessionFolder(this, s)
            this.pipelineData_.dataFolder = s;
        end            
    end

    methods
        function this = SessionData2(mediator, varargin)
            this = this@mlpipeline.ImagingData(mediator);
            this.pipelineData_ = mlpipeline.PipelineData(varargin{:});
        end

        function dt = datetime(this)
            re = regexp(this.sessionFolder, 'ses-(?<dt>\d+)', 'names');
            switch length(re.dt)
                case 8
                    dt = datetime(re.dt, InputFormat='yyyyMMdd', TimeZone='local');
                case 14
                    dt = datetime(re.dt, InputFormat='yyyyMMddHHmmss', TimeZone='local');
                otherwise
                    error('mlpipeline:valueError', 'SessionData2.datetime()')
            end
        end
    end

    %% PROTECTED
    
    properties (Access = protected)
        pipelineData_
        registry_
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
