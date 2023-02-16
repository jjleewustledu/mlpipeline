classdef (Abstract) ScanData2 < handle & mlpipeline.ImagingData & mlpipeline.IScanData2
    %% SCANDATA2 organizes a unique scan.
    %  
    %  Created 04-Feb-2023 00:03:57 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.13.0.2126072 (R2022b) Update 3 for MACI64.  Copyright 2023 John J. Lee.
    
	properties (Dependent)        
        scansDir % __Freesurfer__ convention
        scansPath 
        scansFolder 
        scanPath
        scanFolder % \in sessionFolder
    end

    methods % GET/SET
        function g = get.scansDir(this)
            g = this.pipelineData_.datasetDir;
        end
        function g = get.scansPath(this)
            g = this.pipelineData_.datasetPath;
        end
        function g = get.scansFolder(this)
            g = this.pipelineData_.datasetFolder;
        end
        function g = get.scanPath(this)
            g = this.pipelineData_.dataPath;
        end
        function     set.scanPath(this, s)
            this.pipelineData_.dataPath = s;
        end
        function g = get.scanFolder(this)
            g = this.pipelineData_.dataFolder;
        end        
        function     set.scanFolder(this, s)
            this.pipelineData_.dataFolder = s;
        end
    end

    methods
        function dt = datetime_bids_filename(this, varargin)
            ic = this.mediator_.imagingContext;
            re = regexp(ic.fileprefix, "ses-(?<dt>\d{14})", "names");
            if ~isempty(re.dt)
                dt = datetime(re.dt, varargin{:}, InputFormat="yyyyMMddHHmmss", TimeZone="local");
                return
            end
            re = regexp(ic.fileprefix, "ses-(?<dt>\d{8})", "names");
            if ~isempty(re.dt)
                dt = datetime(re.dt, varargin{:}, InputFormat="yyyyMMdd", TimeZone="local");
                return
            end
            dt = NaT;
        end
        function dt = datetime_mlnipet(~, varargin)
            dt = NaT;
        end
        function this = ScanData2(mediator, varargin)
            this = this@mlpipeline.ImagingData(mediator);
            this.pipelineData_ = mlpipeline.PipelineData(varargin{:});
        end
    end

    %% PROTECTED
    
    properties (Access = protected)
        pipelineData_
    end

    methods (Access = protected)
    end

    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
