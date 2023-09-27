classdef SimpleMediator < handle & mlpipeline.ImagingMediator
    %% SimpleMediator provides a mediator design pattern for projects not using BIDS (cf. GoG pp. 276-278).  
    %  As a mediator, it separates and manages data-conceptual entities previously squashed into class 
    %  hierarchies such as that for mlraichle.SessionData.
    %
    %  It also provides a prototype design pattern for use by abstract factories like mlkinetics.BidsKit 
    %  (cf. GoF pp. 90-91, 117).  For prototypes, call initialize(obj) using obj understood by 
    %  mlfourd.ImagingContext2.  Delegates data-conceptual functionality to mlvg.{SimpleScan, SimpleSession, 
    %  SimpleSubject, SimpleProject, SimpleStudy}.
    %  
    %  Created 06-Mar-2023 23:37:38 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.13.0.2126072 (R2022b) Update 3 for MACI64.  Copyright 2023 John J. Lee.

    properties (Constant)
    end

    properties (Dependent)
    end

    methods % GET/SET
    end

    methods
        function findProximal(~, varargin)
            error("mlpipeline:NotImplementedError", stackstr())
        end
        function this = initialize(this, varargin)
            this.buildImaging(varargin{:});
            this.bids_ = mlpipeline.SimpleBids( ...
                destinationPath=this.scanPath, ...
                projectPath=this.projectPath, ...
                subjectFolder=this.subjectFolder);
            this.imagingAtlas_ = this.bids_.atlas_ic;
            try
                this.imagingDlicv_ = this.bids_.dlicv_ic;
            catch ME
                handwarning(ME)
            end          
        end
        function this = SimpleMediator(varargin)
            %% Args must be understandable by mlfourd.ImagingContext2.

            this = this@mlpipeline.ImagingMediator(varargin{:});
            warning('off', 'MATLAB:unassignedOutputs')
            warning('off', 'MATLAB:badsubscript')
            warning('off', 'MATLAB:assertion:failed')
            warning('off', 'mfiles:ChildProcessWarning')
            this.initialize();
        end
        function t = taus(this, varargin)
            if isempty(this.scanData_)
                this.buildImaging();
            end
            if isempty(varargin)
                t = this.scanData_.taus(upper(this.tracer));
                return
            end
            t = this.scanData_.taus(varargin{:});
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
                imcontext = this.imagingContext
            end
            if ~isempty(imcontext)
                this.imagingContext_ = mlfourd.ImagingContext2(imcontext);
            end

            this.scanData_ = mlpipeline.SimpleScan(this, dataPath=this.imagingContext_.filepath);
            this.sessionData_ = mlpipeline.SimpleSession(this, dataPath=this.scanPath);
            this.subjectData_ = mlpipeline.SimpleSubject(this, dataPath=this.scanPath);
            this.projectData_ = mlpipeline.SimpleProject(this, dataPath= ...            
                this.omit_bids_folders(this.subjectsPath));
            this.studyData_ = mlpipeline.SimpleStudy(this, mlpipeline.SimpleRegistry.instance());

            % additional assembly required?

        end
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
