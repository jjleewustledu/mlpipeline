classdef (Abstract) StudyBuilder < handle
    %% Builds objects for a study, using a builder design pattern.
    %  See also mlvg.Ccir1211Builder, mlan.Ccir993Builder, mlraichle.Ccir559754Builder, ...
    %  
    %  Created 22-Sep-2022 12:17:11 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.13.0.2049777 (R2022b) for MACI64.  Copyright 2022 John J. Lee.
    
    properties (Abstract)
        % BIDS fully-qualified directories, folders
        derivativesDir
        rawdataDir
        sourcedataDir
        studyDir
        studyFolder

        dicomExt
        workdir
    end

	properties (Dependent)        
        studyData % delegate class
        projectData % delegate class
        subjectData % delegate class
        sessionData % delegate class
        scanData % delegate class
    end

    methods % GET/SET
        function g    = get.studyData(this)
            g = this.studyData_;
        end
        function        set.studyData(this, s)
            assert(isa(s, 'mlpipeline.IStudyData') || isa(s, 'mlnipet.StudyData'));
            this.studyData_ = s;
        end
        function g    = get.projectData(this)
            g = this.projectData_;
        end
        function        set.projectData(this, s)
            assert(isa(s, 'mlpipeline.IProjectData'));
            this.projectData_ = s;
        end
        function g    = get.subjectData(this)
            g = this.subjectData_;
        end  
        function        set.subjectData(this, s)
            assert(isa(s, 'mlpipeline.ISubjectData'));
            this.subjectData_ = s;
        end 
        function g    = get.sessionData(this)
            g = this.sessionData_;
        end  
        function        set.sessionData(this, s)
            this.sessionData_ = s;
        end 
        function g    = get.scanData(this)
            g = this.scanData_;
        end  
        function        set.scanData(this, s)
            assert(isa(s, 'mlpipeline.IScanData'));
            this.scanData_ = s;
        end 
    end

    methods
        function this = build_bids(this, varargin)
            %% Builds filesystem with, e.g., $SINGULARITY_HOME/CCIR_*/
            %  {rawdata,sourcedata,derivatives}/sub-<id>/ses-<date>/
            %  {anat,fmap,func,pet}/*.nii.gz
        end
        function this = build_filesystem(this, varargin)
            ensuredir(this.workdir);

            ensuredir(this.rawdataDir);
            ensuredir(this.sourcedataDir);
            ensuredir(this.derivativesDir);
        end
        function modf = build_modalityFolder(this, subf, sesf, fn)
            %% Ensures session directories in filesystem for BIDS.
            %  Args:
            %      this
            %      subf {mustBeText} : e.g., sub-123456.
            %      sesf {mustBeText} : e.g., 'ses-yyyymmdd'.
            %      fn {mustBeFile} : DICOM containing AcquisitionDate.
            %  Returns:
            %      subf {mustBeText,mustBeNonempty} : e.g., 'ses-yyyymmdd'.

            arguments (Input)
                this mlpipeline.StudyBuilder
                subf {mustBeText}
                sesf {mustBeText}
                fn {mustBeFile}
            end
            arguments (Output)
                modf {mustBeText,mustBeNonempty}
            end

            assert(contains(fn, this.dicomExt), clientname(false, 2))
            info = dicominfo(fn);            
            modf = this.info2modality(info);
            ensuredir(fullfile(this.sourcedataDir, subf, sesf, modf));
            ensuredir(fullfile(this.derivativesDir, subf, sesf, modf));
        end
        function this = build_quality_assurance(this, varargin)
        end
        function sesf = build_sesFolder(this, subf, fn)
            %% Ensures session directories in filesystem for BIDS.
            %  Args:
            %      this
            %      subf {mustBeText} : e.g., sub-123456.
            %      fn {mustBeFile} : DICOM containing AcquisitionDate.
            %  Returns:
            %      subf {mustBeText,mustBeNonempty} : e.g., 'ses-yyyymmdd'.

            arguments (Input)
                this mlpipeline.StudyBuilder
                subf {mustBeText}
                fn {mustBeFile}
            end
            arguments (Output)
                sesf {mustBeText,mustBeNonempty}
            end

            assert(isfolder(fullfile(this.rawdataDir, subf)), clientname(false, 2))
            assert(contains(fn, this.dicomExt), clientname(false, 2))
            info = dicominfo(fn);            
            sesf = sprintf('ses-%s', info.AcquisitionDate);
            ensuredir(fullfile(this.sourcedataDir, subf, sesf));
            ensuredir(fullfile(this.derivativesDir, subf, sesf));
        end
        function subf = build_subFolder(this, pth)
            %% Ensures subject directories in filesystem for BIDS.
            %  Args:
            %      this
            %      pth {mustBeText} = this.workdir : proposed path.
            %  Returns:
            %      subf {mustBeText,mustBeNonempty} : e.g., 'sub-123456'.

            arguments (Input)
                this mlpipeline.StudyBuilder
                pth {mustBeText} = this.workdir
            end
            arguments (Output)
                subf {mustBeText,mustBeNonempty}
            end
            
            assert(contains(pth, 'sub-'), clientname(false, 2))
            ss = strsplit(pth, filesep);
            subf = ss{contains(ss, 'sub-')};
            ensuredir(fullfile(this.rawdataDir, subf));
            ensuredir(fullfile(this.sourcedataDir, subf));
            ensuredir(fullfile(this.derivativesDir, subf));
        end
        function this = build_unpacked(this, varargin)
        end
        function this = call(this, varargin)
            announce('beginning')
            this.build_filesystem(varargin{:});
            this.build_unpacked(varargin{:});
            this.build_bids(varargin{:});
            this.build_quality_assurance(varargin{:});
            announce('ending')
        end
        function m = info2modality(~, info)
            if contains(info.Modality, 'MR', 'IgnoreCase',true)
                if contains(info.ProtocolName, 'fMRI', 'IgnoreCase',true) || ...
                   contains(info.SeriesDescription, 'fMRI', 'IgnoreCase',true)
                    m = 'func';
                    return
                end
                if contains(info.ProtocolName, 'FieldMap', 'IgnoreCase',true) || ...
                   contains(info.SeriesDescription, 'FieldMap', 'IgnoreCase',true)
                    m = 'fmap';
                    return
                end
                m = 'anat';
                return
            end
            if contains(info.Modality, 'PET', 'IgnoreCase',true) || ...
               contains(info.Modality, 'PT', 'IgnoreCase',true)
                m = 'pet';
                return
            end            
            if contains(info.Modality, 'CT', 'IgnoreCase',true)
                m = 'ct';
                return
            end
        end

        function this = StudyBuilder(varargin)
        end
    end

    %% PROTECTED

    properties (Access = protected)
        studyData_
        projectData_
        subjectData_
        sessionData_
        scanData_
    end

    methods (Access = protected)
        function move_etc(~)
            g = glob('*_setter_*', '-ignorecase')';
            if ~isempty(g)
                ensuredir('etc');
                movefile('*_setter_*', 'etc', 'f');
            end
            g = glob('*Scout*', '-ignorecase')';
            if ~isempty(g)
                ensuredir('etc');
                movefile('*Scout*', 'etc', 'f');
            end
            g = glob('*Localizer*', '-ignorecase')';
            if ~isempty(g)
                ensuredir('etc');
                movefile('*Localizer*', 'etc', 'f');
            end
        end
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
