classdef SimpleMediator < handle & mlpipeline.ImagingMediator
    %% line1
    %  line2
    %  
    %  Created 06-Mar-2023 23:37:38 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.13.0.2126072 (R2022b) Update 3 for MACI64.  Copyright 2023 John J. Lee.

    properties (Constant)
        BIDS_FOLDERS = {'derivatives', 'rawdata', 'sourcedata'};
    end

    properties (Dependent)
        anatPath
        derivAnatPath
        derivativesPath
        derivPetPath
        mriPath
        petPath
        sourcedataPath
        sourceAnatPath
        sourcePetPath

        atlas_ic
        dlicv_ic
        flair_ic
        T1_ic % FreeSurfer
        t1w_ic
        t2w_ic
        tof_ic
        tof_on_t1w_ic
        wmparc_ic % FreeSurfer
    end

    methods % GET/SET
        function g = get.anatPath(this)
            g = this.bids.anatPath;
        end      
        function g = get.derivAnatPath(this)
            g = this.bids.derivAnatPath;
        end
        function g = get.derivativesPath(this)
            g = this.bids.derivativesPath;
        end
        function g = get.derivPetPath(this)
            g = this.bids.derivPetPath;
        end        
        function g = get.mriPath(this)
            g = this.bids.mriPath;
        end
        function g = get.petPath(this)
            g = this.bids.petPath;
        end
        function g = get.sourcedataPath(this)
            g = this.bids.sourcedataPath;
        end
        function g = get.sourceAnatPath(this)
            g = this.bids.sourceAnatPath;
        end
        function g = get.sourcePetPath(this)
            g = this.bids.sourcePetPath;
        end
        
        function g = get.atlas_ic(this)
            g = this.bids.atlas_ic;
        end  
        function g = get.dlicv_ic(this)
            g = this.bids.dlicv_ic;
        end
        function g = get.flair_ic(this)
            g = this.bids.flair_ic;
        end
        function g = get.T1_ic(this) % FreeSurfer
            g = this.bids.T1_ic;
        end
        function g = get.t1w_ic(this)
            g = this.bids.t1w_ic;
        end
        function g = get.t2w_ic(this)
            g = this.bids.t2w_ic;
        end
        function g = get.tof_ic(this)
            g = this.bids.tof_ic;
        end
        function g = get.tof_on_t1w_ic(this)
            g = this.bids.tof_on_t1w_ic;
        end
        function g = get.wmparc_ic(this) % FreeSurfer
            g = this.bids.wmparc_ic;
        end
    end

    methods
        function imagingChanged(this, imdata)
            %% subclasses override to affect mlpipeline.ImagingData
            %  complexity of mediator design patterns arise here

            arguments
                this mlpipeline.ImagingMediator
                imdata mlpipeline.ImagingData
            end

            if imdata == this.scanData_
            elseif imdata == this.sessionData_
            elseif imdata == this.subjectData_
            elseif imdata == this.projectData_
            elseif imdata == this.studyData_
            else
                error('mlpipeline:ValueError', stackstr());
            end
        end
        function this = SimpleMediator(varargin)
            %% Args must be understandable by mlfourd.ImagingContext2.

            this = this@mlpipeline.ImagingMediator(varargin{:});

            warning('off', 'MATLAB:unassignedOutputs')
            warning('off', 'MATLAB:badsubscript')
            warning('off', 'MATLAB:assertion:failed')
            warning('off', 'mfiles:ChildProcessWarning')

            this.buildImaging();
            this.bids_ = mlpipeline.SimpleBids( ...
                destinationPath=this.scanPath, ...
                projectPath=this.projectPath, ...
                subjectFolder=this.subjectFolder);
            this.imagingAtlas_ = this.bids_.atlas_ic;
            try
                this.imagingDlicv_ = this.bids_.dlicv_ic;
            catch
            end
        end
        function t = taus(this, varargin)
            if isempty(varargin)
                t = this.scanData_.taus(upper(this.tracer));
                return
            end
            t = this.scanData_.taus(varargin{:});
        end
        function ic = tracerOnAtlas(this, varargin)
            if endsWith(this.imagingContext.fileprefix, this.registry.atlasTag)
                ic = this.imagingContext;
                return
            end
            s = this.bids.filename2struct(this.imagingContext.fqfn);
            s.tag = this.atlasTag;
            fqfn = this.bids.struct2filename(s);
            ic = mlfourd.ImagingContext2(fqfn);
        end
    end

    methods (Static)
        function this = create(varargin)
            this = mlpipeline.SimpleMediator(varargin{:});
        end
    end

    %% PROTECTED

    methods (Access = protected)        
        function buildImaging(this, imcontext)
            arguments
                this mlpipeline.SimpleMediator
                imcontext = []
            end
            if ~isempty(imcontext)
                this.imagingContext_ = mlfourd.ImagingContext2(imcontext);
            end

            this.scanData_ = mlpipeline.SimpleScan(this, dataPath=this.imagingContext_.filepath);
            this.sessionData_ = mlpipeline.SimpleSession(this, dataPath=this.scanPath);
            this.subjectData_ = mlpipeline.SimpleSubject(this, dataPath=this.scanPath);
            this.projectData_ = mlpipeline.SimpleProject(this, dataPath=this.scansPath);
            this.studyData_ = mlpipeline.SimpleStudy(this, mlpipeline.SimpleRegistry.instance());

            % additional assembly required?

        end
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
