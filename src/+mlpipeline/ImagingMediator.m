classdef (Abstract) ImagingMediator < handle
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

    properties (Constant)
        BIDS_FOLDERS = {'derivatives', 'rawdata', 'sourcedata'};
    end

    properties (Dependent)
        atlasTag
        bids
        blurTag
        imagingAtlas
        imagingContext
        imagingDlicv
        regionTag
        registry
    end

    methods % GET/SET
        function g = get.atlasTag(this)
            g = this.registry.atlasTag;
        end
        function g = get.bids(this)
            g = this.bids_;
        end
        function g = get.blurTag(this)
            g = this.registry.blurTag;
        end
        function set.blurTag(this, s)
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
        function set.regionTag(this, s)
            assert(istext(s))
            this.regionTag_ = s;
        end
        function g = get.registry(this)
            g = this.studyData_.registry;
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
