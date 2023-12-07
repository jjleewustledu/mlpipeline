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
        imagingDlicv
        isotope
        json_metadata
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
            mg = mglob(fullfile(this.sourcedataPath, this.subjectFolder, this.bids.sessionFolderForPet, "lm*"));
            if isempty(mg)
                g = pwd;
                return
            end
            mg = natsort(mg);
            g = mg(1);
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
        function g = get.imagingDlicv(this)
            g = copy(this.imagingDlicv_);
        end
        function g = get.isotope(this)
            g = this.scanData_.isotope;
        end        
        function j = get.json_metadata(this)
            j = this.imagingContext_.json_metadata;
        end
        function     set.json_metadata(this, s)
            this.imagingContext_.json_metadata = s;
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

        function ic = imagingContext(this)
            %% slow for large data
            ic = copy(this.imagingContext_);
        end
        function ifc = imagingFormat(this)
            %% potentially slow for large data
            ifc = this.imagingContext.imagingFormat;
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
        function st_ = starts(this)
            if ndims(this.imagingContext_) < 4
                st_ = [];
                return
            end
            P = size(this.imagingContext_, 4);

            % prefer json_metadata
            if isfield(this.json_metadata, "starts")
                st_ = asrow(this.json_metadata.starts);
                if length(st_) == P
                    return
                end

                % aufbau for moving averages
                M = length(st_);
                N = floor(P/M);
                if M < P
                    st__ = zeros(1, P);
                    dt_ = st_(end) - st_(end-1);
                    for n = 1:N
                        for m = 1:M
                            st__(m+M*(n-1)) = (n - 1)*(st_(M) + dt_) + st_(m);
                        end
                    end
                    if mod(P,M) > 0
                        st__(M*N+1:P) = N*(st_(M) + dt_) + st_(1:mod(P,M));
                    end
                    st_ = st__;
                    return
                end
            end

            % try console taus
            taus_ = this.scanData_.consoleTaus(this.tracer);
            st_ = cumsum(taus_) - taus_;
            if length(st_) == P
                return
            end

            % abort
            st_ = [];
        end
        function taus_ = taus(this)
            if ndims(this.imagingContext_) < 4
                taus_ = [];
                return
            end
            P = size(this.imagingContext_, 4);

            % prefer json_metadata
            if isfield(this.json_metadata, "taus")
                taus_ = asrow(this.json_metadata.taus);
                if length(taus_) == P
                    return
                end

                % aufbau for moving averages
                N = length(taus_);
                M = floor(P/N);
                if N < P
                    taus__ = zeros(1, P);
                    for n = 1:N
                        for m = 1:M
                            taus__(m+M*(n-1)) = taus_(n);
                        end
                    end
                    if mod(P,N) > 0
                        taus__(M*N+1:P) = taus_(N);
                    end
                    taus_ = taus__;
                    return
                end
            end

            % try console taus
            taus_ = this.scanData_.consoleTaus(this.tracer);
            if length(taus_) == P
                return
            end

            % abort
            taus_ = [];
        end
        function t_ = times(this)
            if ndims(this.imagingContext_) < 4
                t_ = [];
                return
            end
            P = size(this.imagingContext_, 4);

            % prefer json_metadata
            if isfield(this.json_metadata, "times")
                t_ = asrow(this.json_metadata.times);
                if length(t_) == P
                    return
                end

                % aufbau for moving averages
                try
                    dt = t_(end) - t_(end-1);
                    M = length(t_);
                    N = floor(P/M);
                    if M < P
                        st__ = zeros(1, P);
                        for n = 1:N
                            for m = 1:M
                                st__(m+M*(n-1)) = (n - 1)*(t_(M) + dt) + t_(m);
                            end
                        end
                        if mod(P,M) > 0
                            st__(M*N+1:P) = N*(t_(M) + dt) + t_(1:mod(P,M));
                        end
                        t_ = st__;
                    end
                    return
                catch ME
                    handwarning(ME)
                end
            end

            % try starts
            t_ = this.starts;
            if length(t_) == P
                return
            end

            % try console times
            taus_ = this.scanData_.consoleTaus(this.tracer);
            t_ = cumsum(taus_) - taus_;
            if length(t_) == P
                return
            end

            % abort
            t_ = [];
        end
        function tMid_ = timesMid(this)
            if ndims(this.imagingContext_) < 4
                tMid_ = [];
                return
            end
            P = size(this.imagingContext_, 4);

            % prefer json_metadata
            if isfield(this.json_metadata, "timesMid")
                tMid_ = asrow(this.json_metadata.timesMid);   
                if length(tMid_) == P
                    return
                end

                % no aufbau
            end
                
            % try console taus
            taus_ = this.scanData_.consoleTaus(this.tracer); 
            tMid_ = cumsum(taus_) - taus_/2;
            if length(tMid_) == P
                return
            end

            % abort
            tMid_ = [];
        end
        function ic = tracerOnAtlas(this, varargin)
            if endsWith(this.imagingContext_.fileprefix, this.registry.atlasTag)
                ic = this.imagingContext;
                return
            end
            s = this.bids.filename2struct(this.imagingContext_.fqfn);
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
            j.starts = this.starts;
            j.taus = this.taus;
            j.times = this.times;
            j.timesMid = this.timesMid;
            j.timeUnit = "second";
            ic.json_metadata = j;            
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
