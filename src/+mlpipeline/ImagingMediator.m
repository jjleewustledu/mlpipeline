classdef (Abstract) ImagingMediator < handle & mlpipeline.IBids
    %% IMAGINGMEDIATOR is the abstract mediator in a mediator design pattern that mediates, e.g., 
    %  mlpipeline.{IScanData, ISessionData, ISbujectData, IProjectData, IStudyData}
    %
    %  Created 05-Feb-2023 13:24:09 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.13.0.2126072 (R2022b) Update 3 for MACI64.  Copyright 2023 John J. Lee.
    
    methods (Abstract)
        imagingChanged(this, imdata) % ensures that colleagues (widgets) work together properly
    end

    methods (Abstract, Access = protected)
        buildImaging(this) % keeps track of colleagues; builds the colleagues (widgets) and initializes
        % this mediator's (director's) references to them
    end

    %%

    methods (Abstract, Static)
        create(varargin)
    end

    %%

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

        isotope
        reconstructionMethod
        tracer

        atlasTag
        bids
        blurTag
        imagingAtlas
        imagingContext
        imagingDlicv
        regionTag
        registry
        timeOffsetConsole
    end

    methods % GET/SET
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

        function g = get.isotope(this)
            g = this.scanData_.isotope;
        end
        function g = get.reconstructionMethod(this)
            g = this.scanData_.reconstructionMethod;
        end
        function g = get.tracer(this)
            g = this.scanData_.tracer;
        end


        function g = get.atlasTag(this)
            g = this.registry.atlasTag;
        end
        function g = get.bids(this)
            g = this.bids_;
        end
        function     set.bids(this, s)
            assert(isa(s, 'mlpipeline.IBids'))
        end
        function g = get.blurTag(this)
            g = this.registry.blurTag;
        end
        function     set.blurTag(this, s)
            this.registry.blurTag = s;
        end
        function g = get.imagingAtlas(this)
            g = this.imagingAtlas_;
        end
        function g = get.imagingContext(this)
            g = this.imagingContext_;
        end
        function g = get.imagingDlicv(this)
            g = this.imagingDlicv_;
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
    end

    methods
        function dt = datetime(this, varargin)
            dt = this.scanData_.datetime(varargin{:});
        end
        function dt = datetime_bids_filename(this, varargin)
            dt = this.scanData_.datetime_bids_filename(varargin{:});
        end
        function ic = metricOnAtlas(this, varargin)
            ic = this.scanData_.metricOnAtlas(varargin{:});
        end
        function ps = petPointSpread(this, varargin)
            reg = this.sessionData_.registry;
            ps = reg.petPointSpread(varargin{:});
        end
        function t = taus(this, varargin)
            if isempty(varargin)
                t = this.scanData_.taus(upper(this.tracer));
                return
            end
            t = this.scanData_.taus(varargin{:});
        end
    end

    %% PROTECTED

    properties (Access = protected)
        bids_
        imagingAtlas_
        imagingContext_
        imagingDlicv_
        scanData_
        sessionData_
        subjectData_
        projectData_
        regionTag_
        studyData_
    end

    methods (Access = protected)
        function this = ImagingMediator(varargin)
            if ~isempty([varargin{:}])
                this.imagingContext_ = mlfourd.ImagingContext2(varargin{:});
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
