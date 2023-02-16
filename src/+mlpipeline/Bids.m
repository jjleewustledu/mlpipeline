classdef (Abstract) Bids < handle & mlpipeline.IBids  
	%% BIDS  
    %
	%  $Revision$
 	%  was created 13-Nov-2021 14:58:16 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.11.0.1769968 (R2021b) for MACI64.  Copyright 2021 John Joowon Lee.
 	
    properties (Abstract, Constant)
        PROJECT_FOLDER % e.g., 'CCIR_01211'
        SURFER_VERSION % e.g., '7.2.0'
    end

	properties (Dependent)
        anatFolder
        anatPath
        derivAnatPath
        derivativesPath
        derivPetPath
        destinationPath
        mriFolder
        mriPath
        petFolder
        petPath
        projectPath
        rawdataPath
        sessionFolderAnat
        sessionFolderPet
        sourcedataPath
        sourceAnatPath
        sourcePetPath
        subjectFolder
        surferFolder
 	end

	methods % GET

        function g = get.anatFolder(~)
            g = 'anat';
        end
        function g = get.anatPath(this)
            g = this.derivAnatPath;
        end
        function g = get.derivAnatPath(this)
            g = fullfile(this.derivativesPath, this.subjectFolder, this.sessionFolderAnat, this.anatFolder, '');
        end
        function g = get.derivativesPath(this)
            g = fullfile(this.projectPath, 'derivatives', '');
        end
        function g = get.derivPetPath(this)
            g = fullfile(this.derivativesPath, this.subjectFolder, this.sessionFolderPet, this.petFolder, '');
        end
        function g = get.destinationPath(this)
            g = this.destinationPath_;
        end
        function g = get.mriFolder(~)
            g = 'mri';
        end
        function g = get.mriPath(this)
            g = fullfile(this.derivativesPath, this.surferFolder, this.mriFolder, '');
        end
        function g = get.petFolder(~)
            g = 'pet';
        end
        function g = get.petPath(this)
            g = this.derivPetPath;
        end
        function g = get.projectPath(this)
            g = this.projectPath_;
        end
        function g = get.rawdataPath(this)
            g = fullfile(this.projectPath, 'rawdata', '');
        end
        function g = get.sessionFolderAnat(this)
            g = this.sessionFolderAnat_;
        end
        function g = get.sessionFolderPet(this)
            g = this.sessionFolderPet_;
        end
        function g = get.sourcedataPath(this)
            g = fullfile(this.projectPath, 'sourcedata', '');
        end
        function g = get.sourceAnatPath(this)
            g = fullfile(this.sourcedataPath, this.subjectFolder, this.sessionFolderAnat, this.anatFolder, '');
        end
        function g = get.sourcePetPath(this)
            g = fullfile(this.sourcedataPath, this.subjectFolder, this.sessionFolderPet, this.petFolder, '');
        end
        function g = get.subjectFolder(this)
            g = this.subjectFolder_;
        end
        function g = get.surferFolder(this)
            g = strcat(this.subjectFolder, '_ses-surfer-', this.SURFER_VERSION);
        end
    end
    
    methods
 		function this = Bids(varargin)
            %  Args:
            %      destinationPath (folder): will receive outputs.  Specify project ID & subject ID.
            %      projectPath (folder): belongs to a CCIR project.  
            %      subjectFolder (text): is the BIDS-adherent string for subject identity.
            %      sessionFolderAnat (text): is the BIDS-adherent string for session/anat identity; 
            %                                found by glob() as needed.
            %      sessionFolderPet (text): is the BIDS-adherent string for session/pet identity; 
            %                               found by glob() as needed.

            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'destinationPath', pwd, @isfolder)
            addParameter(ip, 'projectPath', fullfile(getenv('SINGULARITY_HOME'), this.PROJECT_FOLDER, ''), @istext)
            addParameter(ip, 'subjectFolder', '', @istext)
            addParameter(ip, 'sessionFolderAnat', '', @istext)
            addParameter(ip, 'sessionFolderPet', '', @istext)
            parse(ip, varargin{:})
            ipr = ip.Results;
            this.destinationPath_ = ipr.destinationPath;
            this.projectPath_ = ipr.projectPath;
            this.subjectFolder_ = ipr.subjectFolder;
            this.sessionFolderAnat_ = ipr.sessionFolderAnat;
            this.sessionFolderPet_ = ipr.sessionFolderPet;

            try
                if isempty(this.subjectFolder_)
                    this.subjectFolder_ = this.parseFolderFromPath('sub-', this.destinationPath_);
                end
            catch
                this.subjectFolder_ = '';
            end
            try
                if isempty(this.sessionFolderAnat_)
                    g = glob(fullfile(this.sourcedataPath, this.subjectFolder, 'ses-*', 'anat'));
                    this.sessionFolderAnat_ = this.parseFolderFromPath('ses-', g{end});
                end
            catch
                this.sessionFolderAnat_ = '';
            end
            try
                if isempty(this.sessionFolderPet_)
                    g = glob(fullfile(this.sourcedataPath, this.subjectFolder, 'ses-*', 'pet'));
                    this.sessionFolderPet_ = this.parseFolderFromPath('ses-', g{end});
                end
            catch
                this.sessionFolderPet_ = '';
            end
        end
        function icd = prepare_derivatives(this, ic)
            %% PREPARE_DERIVATIVES refreshes imaging in this.derivativesPath reoriented to the MNI standard and
            %  radiologic orientation.

            if ~isa(ic, 'mlfourd.ImagingContext2')
                ic = mlfourd.ImagingContext2(ic);
            end

            assert(isfile(ic.fqfn))

            icd = copy(ic);
            if ~contains(ic.filepath, this.derivativesPath) % copy to derivatives
                if contains(ic.filepath, this.anatFolder)
                    icd.filepath = this.derivAnatPath;
                end
                if contains(ic.filepath, this.petFolder)
                    icd.filepath = this.derivPetPath;
                end
                ensuredir(icd.filepath);
                mysystem(sprintf('cp -f %s %s', ic.fqfn, icd.filepath), '-echo');
                if isfile(strcat(ic.fqfp, '.json'))
                    mysystem(sprintf('cp -f %s %s', strcat(ic.fqfp, '.json'), icd.filepath), '-echo');
                end
                mysystem(sprintf('chmod -R 755 %s', icd.filepath));
            end
            if ~contains(icd.fileprefix, '_orient-std') && ~isfile(strcat(icd.fqfp, '_orient-std.nii.gz'))
                icd.reorient2std();  
                icd.selectNiftiTool();
                icd.save();
            end          
        end
    end
    
    methods (Static)
        function [s,r] = dcm2niix(varargin)
            %% https://github.com/rordenlab/dcm2niix
            %  Args:
            %      folder (folder):  for recursive searching
            %      f (text):  filename specification; default 'sub-%n_ses-%t-%d-%s';
            %           %a=antenna (coil) number, 
            %           %b=basename, 
            %           %c=comments, 
            %           %d=description, 
            %           %e=echo number, 
            %           %f=folder name, 
            %           %i=ID of patient, 
            %           %j=seriesInstanceUID, 
            %           %k=studyInstanceUID, 
            %           %m=manufacturer, 
            %           %n=name of patient, 
            %           %p=protocol, 
            %           %r=instance number, 
            %           %s=series number, 
            %           %t=time, 
            %           %u=acquisition number, 
            %           %v=vendor, 
            %           %x=study ID; 
            %           %z=sequence name
            %      i (y/n):  ignore derived, localizer and 2D images (y/n; default n)
            %      o (folder):  output directory (omit to save to input folder); default pwd
            %      fourdfp (logical):  also create 4dfp
            %      version (numeric):  [] | 20180622 | 20180627
            %      terse (logical):

            ip = inputParser;
            addOptional(ip, 'folder', pwd, @isfolder)
            addParameter(ip, 'f', 'sub-%n_ses-%t-%d-%s', @istext) 
            addParameter(ip, 'i', 'n', @istext) % 
            addParameter(ip, 'o', pwd, @isfolder) % 
            addParameter(ip, 'fourdfp', false, @islogical) % 
            addParameter(ip, 'version', [], @isnumeric)
            addParameter(ip, 'terse', false, @islogical)
            parse(ip, varargin{:})
            ipr = ip.Results;
            
            exe = 'dcm2niix';
            if isempty(ipr.version)
                switch computer
                    case 'MACI64'
                        exe = 'dcm2niix';
                    case 'GLNXA64'
                        exe = fullfile(getenv('RELEASE'), 'dcm2niix');
                    case 'PCWIN64'
                        exe = 'dcm2niix.exe';
                    otherwise
                end
            end
            if ~isempty(ipr.version) && (ipr.version == 20180622 || ipr.version == 20180627)
                switch computer
                    case 'MACI64'
                        exe = 'dcm2niix_20180622';
                    case 'GLNXA64'
                        exe = 'dcm2niix_20180627';
                    otherwise
                end
            end

            [~,wd] = mlbash(['which ' exe]);
            assert(~isempty(wd))            
            [~,wp] = mlbash('which pigz');
            if ~isempty(wp)
                z = 'y';
            else
                z = 'n';
            end
            ensuredir(ipr.o)
            
            if ipr.terse && isempty(ipr.version)
                exe = sprintf('%s --terse', exe);
            end
            [s,r] = mlbash(sprintf('%s -f %s -i %s -o %s -z %s %s', exe, ipr.f, ipr.i, ipr.o, z, ipr.folder));
            for g = globT(fullfile(ipr.o, '*.*'))
                if contains(g{1}, '(') || contains(g{1}, ')') 
                    fn = strrep(g{1}, '(', '_');
                    fn = strrep(fn,   ')', '_');
                    movefile(g{1}, fn)
                end
            end
            if ipr.fourdfp
                for g = globT(fullfile(ipr.o, '*.nii.gz'))
                    if ~isfile(strcat(myfileprefix(g{1}), '.4dfp.hdr'))
                        ic = mlfourd.ImagingContext2(g{1});
                        ic.fourdfp.save()
                    end
                end
            end
        end
        function fld = parseFolderFromPath(patt, pth)
            %  Args:
            %      patt (text): e.g., 'sub-', 'ses-'.
            %      pth (folder): from which to find 1st folder name matching patt.

            if contains(pth, patt)
                ss = strsplit(pth, filesep);
                fld = ss{contains(ss, patt)}; % picks first occurance
            end
        end
        function obj = sourcedata2derivatives(obj)
            %% Replaces specification for sourcedata folder with derivatives folder.
            %  Args:
            %      obj (various)
            %  Returns:
            %      obj: sourcedata folder replaced with derivatives folder.

            if isa(obj, 'mlfourd.ImagingContext2')
                obj.selectImagingTool();
                obj.filepath = strrep(obj.filepath, 'sourcedata', 'derivatives');
                return
            end
            if isa(obj, 'mlfourd.ImagingFormatContext2')
                obj.filepath = strrep(obj.filepath, 'sourcedata', 'derivatives');
                return
            end
            if istext(obj)
                obj = strrep(obj, 'sourcedata', 'derivatives');
            end
        end

        function dt = filename2datetime(fn)
            s = mlpipeline.Bids.filename2struct(fn);
            re = regexp(s.ses, 'ses-(?<dt>\d{14})', 'names');
            assert(~isempty(re))
            dt = datetime(re.dt, InputFormat="yyyyMMddHHmmss");
        end
        function s = filename2struct(fn)
            fn = convertStringsToChars(fn);
            re_sub = '';
            re_ses = '';
            re_modal = '';
            re_proc = '';
            re_orient = '';
            re_modal2 = '';
            re_tag = '';

            [~,fp,ext] = myfileparts(fn);
            [re_on,start_on] = regexp(fp, '_on_[^_]+', 'match');
            if ~isempty(re_on)
                re_on = re_on{1};
                fp = fp(1:start_on-1); % remove '_on_modality'
            else
                re_on = '';
            end

            re = regexp(fp, '(?<sub>sub-[^_]+)_(?<ses>ses-[^_]+)_\S+', 'names');
            if ~isempty(re)
                re_sub = re.sub;
                re_ses = re.ses;
                end_ses = regexp(fp, re.ses, 'end');
                if ~isempty(end_ses)
                    fp = fp(end_ses+1:end); % remove 'sub-*_ses-*'
                end
            end
            if contains(fp, '_acq-')
                re = regexp(fp, ...
                    '_(?<modal>acq-[^_]+)_(?<proc>proc-[^_]+)_(?<orient>orient-[^_]+)_(?<modal2>\S+)', 'names');
                re_modal = re.modal;
                re_proc = re.proc;
                re_orient = re.orient;
                re_modal2 = re.modal2;
            end
            if contains(fp, '_T1w_MPR_vNav_4e_RMS_')
                re = regexp(fp, ...
                    '_(?<modal>T1w_MPR_vNav_4e_RMS[^_]*)_(?<orient>orient-[^_]+)(?<tag>\S*)', 'names');
                re_modal = re.modal;
                re_orient = re.orient;
                re_tag = re.tag;
            end
            if contains(fp, '_tof_fl3d_tra_p2_multi-slab_')
                re = regexp(fp, ...
                    '_(?<modal>tof_fl3d_tra_p2_multi-slab[^_]*)_(?<orient>orient-[^_]+)', 'names');
                re_modal = re.modal;
                re_orient = re.orient;
            end
            if contains(fp, '_trc-')
                re = regexp(fp, ...
                    '_(?<modal>trc-[^_]+)_(?<proc>proc-[^_]+)_(?<modal2>[^_]+)', 'names');
                re_modal = re.modal;
                re_proc = re.proc;
                re_modal2 = re.modal2;
            end

            s.sub = re_sub;
            s.ses = re_ses;
            s.modal = re_modal;
            s.proc = re_proc;
            s.orient = re_orient;
            s.modal2 = re_modal2;
            s.on = re_on;
            if ~isempty(re_tag) && re_tag(1) == '_'
                re_tag = re_tag(2:end);
            end
            s.tag = re_tag;
            s.ext = ext;
        end
        function fn = struct2filename(s)
            if isempty(s.tag)
                fn = sprintf('%s_%s_%s_%s_%s%s%s%s', ...
                    s.sub, s.ses, s.modal, s.proc, s.orient, s.modal2, s.on, s.ext);
            else
                fn = sprintf('%s_%s_%s_%s_%s%s%s_%s%s', ...
                    s.sub, s.ses, s.modal, s.proc, s.orient, s.modal2, s.on, s.tag, s.ext);
            end
            fn = convertStringsToChars(fn);
        end
    end
    
    %% PROTECTED
    
    properties (Access = protected)
        destinationPath_
        projectPath_
        sessionFolderAnat_
        sessionFolderPet_
        subjectFolder_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
end

