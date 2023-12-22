classdef (Abstract) ScanData2 < handle & mlpipeline.ImagingData & mlpipeline.IScanData2
    %% SCANDATA2 organizes a unique scan.
    %  
    %  Created 04-Feb-2023 00:03:57 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.13.0.2126072 (R2022b) Update 3 for MACI64.  Copyright 2023 John J. Lee.
    
    methods (Abstract, Static)
        consoleTaus
    end

    %%

	properties (Dependent)        
        scansDir % __Freesurfer__ convention
        scansPath 
        scansFolder 
        scanPath
        scanFolder % \in sessionFolder

        defects
        isotope
        reconstructionMethod
        tracer % lower-case
    end

    methods % GET/SET
        function g = get.scansDir(this)
            g = this.pipelineData_.datasetDir;
            if ~contains(g, "sub-") || ~contains(g, "ses-")
                warning("mlpipeline:ValueWarning", "%s: scansDir->%s", stackstr(), g);
            end
        end
        function g = get.scansPath(this)
            g = this.pipelineData_.datasetPath;
            if ~contains(g, "sub-") || ~contains(g, "ses-")
                warning("mlpipeline:ValueWarning", "%s: scansPath->%s", stackstr(), g);
            end
        end
        function g = get.scansFolder(this)
            g = this.pipelineData_.datasetFolder;
            if ~contains(g, "ses-")
                warning("mlpipeline:ValueWarning", "%s: scansFolder->%s", stackstr(), g);
            end
        end
        function g = get.scanPath(this)
            g = this.pipelineData_.dataPath;
            if ~contains(g, "sub-") || ~contains(g, "ses-")
                warning("mlpipeline:ValueWarning", "%s: scansDir->%s", stackstr(), g);
            end
        end
        function     set.scanPath(this, s)
            if ~contains(s, "sub-") || ~contains(s, "ses-")
                warning("mlpipeline:ValueWarning", "%s: scansDir->%s", stackstr(), s);
            end
            this.pipelineData_.dataPath = s;
        end
        function g = get.scanFolder(this)
            g = this.pipelineData_.dataFolder;
            assert(~isemptytext(g))
        end        
        function     set.scanFolder(this, s)
            assert(~isemptytext(s))
            this.pipelineData_.dataFolder = s;
        end

        function g = get.defects(this)
            g = this.mediator_.registry.defects;
        end
        function g = get.isotope(this)
            switch lower(this.tracer)
                case {'fdg' 'azan' 'asem' 'av45' 'av1451' 'mk6240' 'ro948' 'mdl' 'iti'}
                    g = '18F';
                case {'co' 'ho' 'oc' 'oh' 'oo'}
                    g = '15O';
                case {'s1p1'}
                    g = '11C';
                otherwise
                    error("mlvg:ValueError", stackstr())
            end
        end
        function g = get.reconstructionMethod(this)
            g = this.mediator_.registry.reconstructionMethod;
        end
        function g = get.tracer(this)
            ic = this.mediator_.imagingContext;
            re = regexp(ic.fileprefix, "_trc-(?<trc>\w+)_", "names");
            if ~isempty(re)
                g = upper(re.trc);
                return
            end
            g = this.mediator_.registry.tracer;
            %assert(~isempty(g)) % ic may not be PET
        end
    end

    methods
        function dt = datetime(this, varargin)
            dt = this.datetime_bids_filename(varargin{:});
        end
        function dt = datetime_console_adjusted(this, varargin)
            dt = datetime(this) - this.mediator_.timeOffsetConsole;
        end
        function dt = datetime_bids_filename(this, fn)
            arguments
                this mlpipeline.ScanData2
                fn = this.mediator_.imagingContext.filename
            end
            if isempty(fn) % erroneously passed fn = {}
                fn = this.mediator_.imagingContext.filename;
            end

            try
                [~,fp] = myfileparts(fn);
                assert(~isempty(fp), stackstr())
            catch ME
                handexcept(ME)
            end
            
            re = regexp(fp, "ses-(?<dt>\d{14})", "names");
            if ~isempty(re.dt)
                dt = datetime(re.dt, InputFormat="yyyyMMddHHmmss", TimeZone="local");
                return
            end
            re = regexp(fp, "ses-(?<dt>\d{8})", "names");
            if ~isempty(re.dt)
                dt = datetime(re.dt, InputFormat="yyyyMMdd", TimeZone="local");
                return
            end
            dt = NaT;
        end
        function dt = datetime_mlnipet(~, varargin)
            dt = NaT;
        end
        function ic = metricOnAtlas(this, metric, tags)
            %% METRICONATLAS forms an ImagingContext2 with modality->metric
            %  and adding tags and atlasTag.

            arguments
                this mlpipeline.ScanData2
                metric {mustBeTextScalar} = 'unknown'
                tags {mustBeTextScalar} = ''
            end

            s = this.mediator_.bids.filename2struct(this.mediator_.imagingContext.fqfn);
            s.modal = metric;
            s.tag = strcat(s.tag, tags);
            fqfn = fullfile(this.mediator_.scanPath, this.mediator_.bids.struct2filename(s));
            ic  = mlfourd.ImagingContext2(fqfn);
        end
        function this = ScanData2(mediator, varargin)
            this = this@mlpipeline.ImagingData(mediator);
            this.pipelineData_ = mlpipeline.PipelineData(varargin{:});
        end
        function t = taus(this, trc)
            arguments
                this mlpipeline.ScanData2
                trc = this.tracer
            end
            t = this.consoleTaus(trc);
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
