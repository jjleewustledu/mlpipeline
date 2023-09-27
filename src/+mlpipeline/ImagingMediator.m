classdef (Abstract) ImagingMediator < handle & mlpipeline.IBids
    %% IMAGINGMEDIATOR is the abstract mediator in a mediator design pattern that mediates, e.g., 
    %  mlpipeline.{IScanData, ISessionData, ISbujectData, IProjectData, IStudyData}
    %
    %  Created 05-Feb-2023 13:24:09 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.13.0.2126072 (R2022b) Update 3 for MACI64.  Copyright 2023 John J. Lee.
    
    methods (Abstract, Access = protected)
        buildImaging(this) % keeps track of colleagues; builds the colleagues (widgets) and initializes
        % this mediator's (director's) references to them
    end

    %%

    methods (Abstract, Static)
        create(varargin)
    end

    %%

    properties (Constant)
        BIDS_FOLDERS = {'derivatives', 'rawdata', 'sourcedata'};
    end

    properties (Dependent)
        projectsDir % homolog of __Freesurfer__ subjectsDir
        projectsPath
        projectsFolder
        projectPath
        projectFolder % \in projectsFolder        
        
        subjectsDir % __Freesurfer__ convention
        subjectsPath 
        subjectsFolder 
        subjectPath
        subjectFolder % \in subjectsFolder  
        
        sessionsDir % __Freesurfer__ convention
        sessionsPath 
        sessionsFolder 
        sessionPath
        sessionFolder % \in projectFolder        
        
        scansDir % __Freesurfer__ convention
        scansPath 
        scansFolder 
        scanPath
        scanFolder % \in sessionFolder

        anatPath
        derivAnatPath
        derivativesPath
        derivPetPath
        listmodePath
        mriPath
        petPath
        rawdataPath
        sourcedataPath
        sourceAnatPath
        sourcePetPath

        atlas_ic
        dlicv_ic
        flair_ic
        T1_ic % FreeSurfer
        T1_on_t1w_ic
        t1w_ic
        t2w_ic
        tof_ic
        tof_on_t1w_ic
        wmparc_ic % FreeSurfer
        wmparc_on_t1w_ic % FreeSurfer

        atlasTag
        bids
        blurTag
        imagingAtlas
        imagingContext
        imagingDlicv
        imagingFormat
        isotope
        radMeasurements % supporting legacy interfaces
        reconstructionMethod
        regionTag
        registry
        timeOffsetConsole
        tracer
    end

    methods %% GET/SET
        function g = get.projectsDir(this)
            g = this.projectData_.projectsDir;
        end
        function g = get.projectsPath(this)
            g = this.projectData_.projectsPath;
        end
        function g = get.projectsFolder(this)
            g = this.projectData_.projectsFolder;
        end
        function g = get.projectPath(this)
            g = this.projectData_.projectPath;
        end
        function     set.projectPath(this, s)
            this.projectData_.projectPath = s;
        end
        function g = get.projectFolder(this)
            g = this.projectData_.projectFolder;
        end        
        function     set.projectFolder(this, s)
            this.projectData_.projectFolder = s;
        end   

        function g = get.subjectsDir(this)
            g = this.subjectData_.subjectsDir;
        end
        function g = get.subjectsPath(this)
            g = this.subjectData_.subjectsPath;
        end
        function g = get.subjectsFolder(this)
            g = this.subjectData_.subjectsFolder;
        end
        function g = get.subjectPath(this)
            g = this.subjectData_.subjectPath;
        end
        function     set.subjectPath(this, s)
            this.subjectData_.subjectPath = s;
        end
        function g = get.subjectFolder(this)
            g = this.subjectData_.subjectFolder;
        end        
        function     set.subjectFolder(this, s)
            this.subjectData_.subjectFolder = s;
        end   

        function g = get.sessionsDir(this)
            g = this.sessionData_.sessionsDir;
        end
        function g = get.sessionsPath(this)
            g = this.sessionData_.sessionsPath;
        end
        function g = get.sessionsFolder(this)
            g = this.sessionData_.sessionsFolder;
        end
        function g = get.sessionPath(this)
            g = this.sessionData_.sessionPath;
        end
        function     set.sessionPath(this, s)
            this.sessionData_.sessionPath = s;
        end
        function g = get.sessionFolder(this)
            g = this.sessionData_.sessionFolder;
        end        
        function     set.sessionFolder(this, s)
            this.sessionData_.sessionFolder = s;
        end

        function g = get.scansDir(this)
            g = this.scanData_.scansDir;
        end
        function g = get.scansPath(this)
            g = this.scanData_.scansPath;
        end
        function g = get.scansFolder(this)
            g = this.scanData_.scansFolder;
        end
        function g = get.scanPath(this)
            g = this.scanData_.scanPath;
        end
        function     set.scanPath(this, s)
            this.scanData_.scanPath = s;
        end
        function g = get.scanFolder(this)
            g = this.scanData_.scanFolder;
        end        
        function     set.scanFolder(this, s)
            this.scanData_.scanFolder = s;
        end

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
        function g = get.listmodePath(this)
            g = fullfile(this.rawdataPath, this.subjectFolder, this.bids.sessionFolderForPet, 'lm', '');
        end
        function g = get.petPath(this)
            g = this.bids.petPath;
        end
        function g = get.rawdataPath(this)
            g = this.bids.rawdataPath;
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
        function g = get.T1_on_t1w_ic(this)
            g = this.bids.T1__on_t1w_ic;
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
        function g = get.wmparc_on_t1w_ic(this)
            g = this.bids.wmparc_on_t1w_ic;
        end
        
        function g = get.atlasTag(this)
            g = this.registry.atlasTag;
        end
        function g = get.bids(this)
            g = this.bids_;
        end
        function     set.bids(this, s)
            assert(isa(s, 'mlpipeline.IBids') || isstruct(s))
            this.bids_ = s;
        end
        function g = get.blurTag(this)
            g = this.registry.blurTag;
        end
        function     set.blurTag(this, s)
            this.registry.blurTag = s;
        end
        function g = get.imagingAtlas(this)
            g = copy(this.imagingAtlas_);
        end
        function g = get.imagingContext(this)
            g = copy(this.imagingContext_);
        end
        function g = get.imagingDlicv(this)
            g = copy(this.imagingDlicv_);
        end
        function g = get.imagingFormat(this)
            g = this.imagingContext.imagingFormat;
        end
        function g = get.isotope(this)
            g = this.scanData_.isotope;
        end
        function g = get.radMeasurements(this)
            g = this.sessionData_.radMeasurements;
        end
        function     set.radMeasurements(this, s)
            this.sessionData_.radMeasurements = s;
        end
        function g = get.reconstructionMethod(this)
            g = this.scanData_.reconstructionMethod;
        end
        function g = get.regionTag(this)
            g = this.regionTag_;
        end
        function     set.regionTag(this, s)
            assert(istext(s))
            this.regionTag_ = s;
        end
        function g = get.registry(this)
            g = this.studyData_.registry;
        end
        function g = get.timeOffsetConsole(this)
            g = this.sessionData_.timeOffsetConsole;
        end
        function g = get.tracer(this)
            g = this.scanData_.tracer;
        end
    end

    methods
        function dt = datetime(this, varargin)
            dt = this.scanData_.datetime(varargin{:});
        end
        function dt = datetime_console_adjusted(this, varargin)
            dt = this.scanData_.datetime_console_adjusted(varargin{:});
        end
        function dt = datetime_bids_filename(this, varargin)
            dt = this.scanData_.datetime_bids_filename(varargin{:});
        end
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
        function this = load(~, varargin)
            ld = load(varargin{:});
            this = ld.this;
        end
        function ic = metricOnAtlas(this, varargin)
            ic = this.scanData_.metricOnAtlas(varargin{:});
        end
        function ps = petPointSpread(this, varargin)
            reg = this.sessionData_.registry;
            ps = reg.petPointSpread(varargin{:});
        end
        function save(this, fn)
            save(fn, 'this')
        end
        function t = taus(this, varargin)
            t = asrow(this.imagingContext.json_metadata.taus);
        end
        function t = times(this, varargin)
            try
                t = asrow(this.imagingContext.json_metadata.times);
            catch ME
                handwarning(ME)
                t = [];
            end
        end
        function t = timesMid(this, varargin)
            t = asrow(this.imagingContext.json_metadata.timesMid);
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

    %% PROTECTED

    properties (Access = protected)
        bids_
        imagingAtlas_
        imagingContext_
        imagingDlicv_
        projectData_
        regionTag_
        scanData_
        sessionData_
        subjectData_
        studyData_
    end

    methods (Access = protected)
        function this = ImagingMediator(varargin)
            if isempty(varargin)
                error("mlpipeline:ValueError", ...
                    "ImagingMediator requires inputs understood by mlfourd.ImagingContext2");                    
            end
            if isa(varargin{1}, 'mlpipeline.ImagingMediator')
                this.imagingContext_ = varargin{1}.imagingContext_;
                return
            end
            this.imagingContext_ = mlfourd.ImagingContext2(varargin{:});
        end
        
        function that = copyElement(this)
            that = copyElement@matlab.mixin.Copyable(this);
            if ~isempty(this.bids_)
                that.bids_ = copy(this.bids_); end
            if ~isempty(this.imagingAtlas_)
                that.imagingAtlas_ = copy(this.imagingAtlas_); end
            if ~isempty(this.imagingContext_)
                that.imagingContext_ = copy(this.imagingContext_); end
            if ~isempty(this.imagingDlicv_)
                that.imagingDlicv_ = copy(this.imagingDlicv_); end
        end    
        function ic = ensureTimingData(this, ic)
            arguments
                this mlpipeline.ImagingMediator
                ic mlfourd.ImagingContext2
            end

            j = ic.json_metadata;
            if ~isfield(j, "taus")
                % make timing data from this.scanData_, which may make best guesses
                taus_ = asrow(this.scanData_.taus());
                times_ = cumsum(taus_) - taus_;
                timesMid_ = cumsum(taus_) - taus_/2;
                j_toadd = struct( ...
                    "taus", taus_, ...
                    "times", times_, ...
                    "timesMid", timesMid_, ...
                    "timeUnit", "second");
                ic.addJsonMetadata(j_toadd);
            end
        end
        function pth = omit_bids_folders(this, pth)
            folds = strsplit(pth, filesep);
            folds = folds(~contains(folds, this.BIDS_FOLDERS));
            if strcmp(computer, 'PCWIN64')
                pth = fullfile(folds{:});
                return
            end
            pth = fullfile(filesep, folds{:});
        end
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
