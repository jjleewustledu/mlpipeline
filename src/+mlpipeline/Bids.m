classdef (Abstract) Bids < handle & mlpipeline.IBids  
	%% BIDS  
    %
	%  $Revision$
 	%  was created 13-Nov-2021 14:58:16 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.11.0.1769968 (R2021b) for MACI64.  Copyright 2021 John Joowon Lee.
 	
    properties (Abstract, Constant)
        BIDS_MODALITIES % e.g., 'DLICV'
        DLICV_TAG
        PROJECT_FOLDER % e.g., 'CCIR_01211'
        SURFER_VERSION % e.g., '7.2.0'
    end

    %%

    properties (Constant)
        TAGS = ["sub", "ses", "acq", "trc", "proc", "orient"]
    end

	properties (Dependent)
        anatFolder
        anatPath
        derivAnatPath
        derivativesPath
        derivPetPath
        destinationPath
        mriFolder % for FreeSurfer
        mriPath % for FreeSurfer
        originationPath
        petFolder
        petPath
        projectPath
        rawAnatPath
        rawdataPath
        rawPetPath
        schaefferPath
        sessionFolderForAnat
        sessionFolderForPet
        sourceAnatPath
        sourcedataPath
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
            g = fullfile(this.derivativesPath, this.subjectFolder, this.sessionFolderForAnat, this.anatFolder);
        end
        function g = get.derivativesPath(this)
            g = fullfile(this.projectPath, "derivatives");
        end
        function g = get.derivPetPath(this)
            % re = regexp(this.sessionFolderForPet, "ses-(?<date>\d{8})(?<time>(|\d{6}))", "names");            
            % g = fullfile(this.derivativesPath, this.subjectFolder, "ses-"+re.date, this.petFolder);
            g = fullfile(this.derivativesPath, this.subjectFolder, this.sessionFolderForPet, this.petFolder);
        end
        function g = get.destinationPath(this)
            g = this.destinationPath_;
        end
        function g = get.mriFolder(~)
            g = "mri";
        end
        function g = get.mriPath(this)
            g = fullfile(this.derivativesPath, this.surferFolder, this.mriFolder);
        end
        function g = get.originationPath(this)
            g = this.originationPath_;
        end
        function g = get.petFolder(~)
            g = "pet";
        end
        function g = get.petPath(this)
            g = this.derivPetPath;
        end
        function g = get.projectPath(this)
            g = this.projectPath_;
        end
        function g = get.rawAnatPath(this)
            g = fullfile(this.rawdataPath, this.subjectFolder, this.sessionFolderForAnat, this.anatFolder);
        end
        function g = get.rawdataPath(this)
            g = fullfile(this.projectPath, "rawdata");
        end
        function g = get.rawPetPath(this)
            g = fullfile(this.rawdataPath, this.subjectFolder, this.sessionFolderForPet, this.petFolder);
        end
        function g = get.schaefferPath(this)
            g = fullfile(this.derivativesPath, this.subjectFolder, this.sessionFolderForAnat, "Parcellations");
        end
        function g = get.sessionFolderForAnat(this)
            if ~isempty(this.sessionFolderForAnat_)
                g = this.sessionFolderForAnat_;
                return
            end

            globbed = mglob( ...
                fullfile(this.sourcedataPath, this.subjectFolder, "ses-*", "anat"));
            if length(globbed) > 1
                globbed = globbed(1);
            end
            try
                g = this.parseFolderFromPath("ses-", globbed);
            catch ME
                fprintf("%s: %s\n", stackstr(), ME.message)
                g = "";
            end
            this.sessionFolderForAnat_ = g;
        end
        function g = get.sessionFolderForPet(this)
            if ~isempty(this.sessionFolderForPet_)
                g = this.sessionFolderForPet_;
                return
            end

            globbed = mglob( ...
                fullfile(this.sourcedataPath, this.subjectFolder, "ses-*", "pet"));
            globbed = this.selectOriginationSession(globbed);
            try
                g = this.parseFolderFromPath("ses-", globbed);
            catch ME
                fprintf("%s: %s\n", stackstr(), ME.message)
                g = "";
            end
            this.sessionFolderForPet_ = g;
        end
        function g = get.sourceAnatPath(this)
            try
                g = fullfile(this.sourcedataPath, this.subjectFolder, this.sessionFolderForAnat, this.anatFolder);
            catch
                fprintf("%s: folder not found; using pwd->%s\n", stackstr(), pwd);
            end
        end
        function g = get.sourcedataPath(this)
            g = fullfile(this.projectPath, "sourcedata");
        end
        function g = get.sourcePetPath(this)
            try
                g = fullfile(this.sourcedataPath, this.subjectFolder, this.sessionFolderForPet, this.petFolder);
            catch
                fprintf("%s: folder not found; using pwd->%s\n", stackstr(), pwd);
            end
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
            %      originationPath (folder): contains inputs.  Specify project ID & subject ID.
            %      projectPath (folder): belongs to a CCIR project.  
            %      subjectFolder (text): is the BIDS-adherent string for subject identity.
            %      sessionFolderForAnat (text): is the BIDS-adherent string for session/anat identity; 
            %                                found by glob() as needed.
            %      sessionFolderForPet (text): is the BIDS-adherent string for session/pet identity; 
            %                               found by glob() as needed.

            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'destinationPath', '', @istext)
            addParameter(ip, 'originationPath', pwd, @isfolder)
            addParameter(ip, 'projectPath', fullfile(getenv("SINGULARITY_HOME"), this.PROJECT_FOLDER), @istext)
            addParameter(ip, 'subjectFolder', '', @istext)
            addParameter(ip, 'sessionFolderForAnat', '', @istext)
            addParameter(ip, 'sessionFolderForPet', '', @istext)
            parse(ip, varargin{:})
            ipr = ip.Results;
            this.destinationPath_ = ipr.destinationPath;
            this.originationPath_ = ipr.originationPath;
            this.projectPath_ = ipr.projectPath;
            this.subjectFolder_ = ipr.subjectFolder;
            this.sessionFolderForAnat_ = ipr.sessionFolderForAnat;
            this.sessionFolderForPet_ = ipr.sessionFolderForPet;

            if isempty(this.destinationPath_)
                this.destinationPath_ = this.originationPath_;
            end
            if isempty(this.subjectFolder_)
                this.subjectFolder_ = this.parseFolderFromPath('sub-', this.originationPath_);
            end
            try
                if isempty(this.sessionFolderForAnat_)
                    g = mglob(fullfile(this.sourcedataPath, this.subjectFolder, "ses-*", "anat"));
                    if ~isempty(g)
                        this.sessionFolderForAnat_ = this.parseFolderFromPath("ses-", g(1));
                    end
                end
            catch ME
                handwarning(ME)
                this.sessionFolderForAnat_ = '';
            end
            try
                if isempty(this.sessionFolderForPet_)
                    this.sessionFolderForPet_ = this.parseFolderFromPath("ses-", this.originationPath);
                end
            catch ME
                handwarning(ME)
                this.sessionFolderForPet_ = '';
            end
        end
        function ic = prepare_derivatives(this, ic)
            %% PREPARE_DERIVATIVES prepares imaging in this.derivativesPath.

            arguments
                this mlpipeline.Bids
                ic {mustBeNonempty}
            end

            ic = mlfourd.ImagingContext2(ic);
            if ~isfile(ic.fqfn)
                ic.save();
            end

            if ~contains(ic.filepath, this.derivativesPath) % copy to derivatives
                ic.selectImagingTool();
                if contains(ic.filepath, this.anatFolder)
                    ic.filepath = this.derivAnatPath;
                end
                if contains(ic.filepath, this.petFolder)
                    ic.filepath = this.derivPetPath;
                end
                ensuredir(ic.filepath);

                if ~isfile(ic.fqfn)
                    ic.save();
                end
                if isunix
                    mysystem(sprintf('chmod -R 755 %s', ic.filepath));
                end
                if ispc
                    mysystem(sprintf("icacls %s /reset /t /c /q", ic.filepath));
                end
            end      
        end
        function ic = prepare_orient_std(~, ic)
            %% prepares imaging reoriented to the MNI standard and radiologic orientation.
            
            ic = mlfourd.ImagingContext2(ic);
            if ~isfile(ic.fqfn)
                ic.save();
            end
            
            if ~contains(ic.fileprefix, '_orient-std') && ~isfile(strcat(ic.fqfp, '_orient-std.nii.gz'))
                
                ic.afni_3dresample(orient_std=true);

                % adni_3dresample is more robust for pipelines than reorien2std
                % ic.reorient2std();
            end  
        end
        function pth = selectOriginationSession(this, pth)
            %% string (array) pth in; string (array) pth with origination session out.

            arguments
                this mlpipeline.Bids
                pth string {mustBeText}
            end
            orig_ses_fold = this.parseFolderFromPath("ses-", this.originationPath);
            pth = pth(contains(pth, orig_ses_fold));
        end
    end
    
    methods (Static)
        function s = adjust_fileprefix(s, opts)
            %% retains any filepath and filename extension understood by myfileparts
            %  Args:
            % s {mustBeTextScalar}
            % opts.new_proc {mustBeTextScalar} = ""
            % opts.pre_proc {mustBeTextScalar} = ""
            % opts.post_proc {mustBeTextScalar} = ""

            arguments
                s {mustBeTextScalar}
                opts.new_mode {mustBeTextScalar} = ""
                opts.pre_mode {mustBeTextScalar} = ""
                opts.post_mode {mustBeTextScalar} = ""
                opts.new_proc {mustBeTextScalar} = ""
                opts.pre_proc {mustBeTextScalar} = ""
                opts.post_proc {mustBeTextScalar} = ""
                opts.remove_substring {mustBeTextScalar} = ""
            end

            [pth,fp,x] = myfileparts(s);

            % adjust mode; add mode if no previous mode
            remo = regexp(fp, "\S+_(?<mode>[a-zA-Z0-9]+)$", "names");
            if ~isempty(remo)
                newmode = remo.mode;
                if ~isemptytext(opts.new_mode)
                    newmode = opts.new_mode;
                end
                if ~isemptytext(opts.pre_mode)
                    newmode = strcat(opts.pre_mode, "_", newmode);
                end
                if ~isemptytext(opts.post_mode)
                    newmode = strcat(newmode, "_", opts.post_mode);
                end
                fp = strrep(fp, remo.mode, newmode);
            end
            if isempty(remo) && ...
                    ~isemptytext(strcat(opts.pre_mode, opts.new_mode, opts.post_mode))
                fp = strcat(fp, "_", opts.pre_mode, opts.new_mode, opts.post_mode);
            end

            % adjust proc
            repr = regexp(fp, "\S+_proc-(?<proc>[a-zA-Z0-9\-]+)", "names");
            if ~isempty(repr)
                newproc = repr.proc;
                if ~isemptytext(opts.new_proc)
                    newproc = opts.new_proc;
                end
                if ~isemptytext(opts.pre_proc)
                    newproc = strcat(opts.pre_proc, "-", newproc);
                end
                if ~isemptytext(opts.post_proc)
                    newproc = strcat(newproc, "-", opts.post_proc);                
                end
                newproc = strrep(newproc, "_", "-");
                fp = strrep(fp, "proc-"+repr.proc, "proc-"+newproc);
            end

            % remove substring
            fp = strrep(fp, opts.remove_substring, "");

            s = fullfile(pth, strcat(fp, x));
        end
        function fn1 = afni_3dresample(fn, varargin)
            ic = mlfourd.ImagingContext2(fn);
            ic.afni_3dresample(varargin{:});
            fn1 = ic.fqfilename;
        end
        function [s,r] = dcm2niix(varargin)
            %% https://github.com/rordenlab/dcm2niix
            %  e.g., $ dcm2niix -f sub-%n_ses-%t_%d-%s -i 'n' -o $(pwd) -d 5 -v 0 -w 1 -z y $(pwd)
            %  Args:
            %      folder (folder):  for recursive searching
            %      d : directory search depth. Convert DICOMs in sub-folders of in_folder? (0..9, default 5)
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
            %      fourdfp (logical):  also create 4dfp
            %      i (y/n):  ignore derived, localizer and 2D images (y/n; default n)
            %      o (folder):  output directory (omit to save to input folder); default pwd
            %      terse : omit filename post-fixes (can cause overwrites)
            %      u : up-to-date check
            %      v : verbose (0/1/2, default 0) [no, yes, logorrheic]
            %      version (numeric):  [] | 20180622 | 20180627
            %      w : write behavior for name conflicts (0,1,2, default 2: 0=skip duplicates, 1=overwrite, 2=add suffix)
            %      z : gz compress images (y/o/i/n/3, default n) [y=pigz, o=optimal pigz, i=internal:zlib, n=no, 3=no,3D]

            ip = inputParser;
            addOptional(ip, 'folder', pwd, @isfolder)
            addParameter(ip, 'd', 5, @isscalar)
            addParameter(ip, 'f', 'sub-%n_ses-%t_%d-%s', @istext) 
            addParameter(ip, 'fourdfp', false, @islogical)
            addParameter(ip, 'i', 'n', @istext)
            addParameter(ip, 'o', pwd, @isfolder)
            addParameter(ip, 'terse', false, @islogical)
            addParameter(ip, 'u', false, @islogical)
            addParameter(ip, 'v', 0, @isscalar)
            addParameter(ip, 'version', [], @isnumeric)
            addParameter(ip, 'w', 1, @isscalar)
            parse(ip, varargin{:})
            ipr = ip.Results;
            
            exe = 'dcm2niix';
            if isempty(ipr.version)
                switch computer
                    case 'GLNXA64'
                        exe  = 'dcm2niix_20230411';
                    case 'PCWIN64'
                        exe = 'dcm2niix.exe';
                    otherwise
                end
            end

            [~,wd] = mysystem(sprintf('which %s', exe));
            assert(~isempty(wd))            
            [~,wp] = mysystem('which pigz');
            if ~isempty(wp)
                z = 'y';
            else
                z = 'n';
            end
            ensuredir(ipr.o)
            
            if ipr.terse && isempty(ipr.version)
                exe = sprintf('%s --terse', exe);
            end
            if ipr.u
                exe = sprintf('%s -u', exe);
            end
            [s,r] = mysystem(sprintf('%s -f %s -i %s -o %s -d %i -v %i -w %i -z %s %s', exe, ipr.f, ipr.i, ipr.o, ipr.d, ipr.v, ipr.w, z, ipr.folder));
            for g = globT(fullfile(ipr.o, '*.*'))
                if contains(g{1}, '(') || contains(g{1}, ')') 
                    fn = strrep(g{1}, '(', '_');
                    fn = strrep(fn,   ')', '_');
                    movefile(g{1}, fn);
                end
            end
            if ipr.fourdfp
                for g = globT(fullfile(ipr.o, '*.nii.gz'))
                    if ~isfile(strcat(myfileprefix(g{1}), '.4dfp.hdr'))
                        ic = mlfourd.ImagingContext2(g{1});
                        ic.fourdfp.save();
                    end
                end
            end
        end
        function linked_fqfn = link_for_3dresample(source_fqfn, opts)
            arguments
                source_fqfn {mustBeFile}
                opts.dest {mustBeFolder} = pwd
                opts.expression {mustBeTextScalar} = "T1w"  % "tof"
                opts.modality_folder {mustBeTextScalar} = "anat"
                opts.do_overwrite logical = true
            end
            if strcmp(opts.expression, "T1w")
                opts.expression = "(?<subid>108\d{3})_\S*(?<modality>T1w\S*)_(?<sesid>20\d{12})\S*";
            end
            if strcmp(opts.expression, "tof")
                opts.expression = "(?<subid>108\d{3})_\S*(?<modality>tof_fl3d\S*)_(?<sesid>20\d{12})\S*";
            end
            source_fqfn = convertCharsToStrings(source_fqfn);
            if numel(source_fqfn) > 1
                if contains(opts.expression, "T1w")
                    source_fqfn = source_fqfn(end);
                else
                    source_fqfn = source_fqfn(1);
                end
            end

            % construct linked_fqfn
            linked_fqfn = "";
            try
                [~,source_fp,x] = myfileparts(source_fqfn);
                re = regexp(source_fp, opts.expression, "names");
                target_fp = sprintf("sub-%s_ses-%s_%s", re.subid, re.sesid, re.modality);
                sesid8 = extractBefore(re.sesid, 9);
                target_pth = fullfile(opts.dest, "sub-"+re.subid, "ses-"+sesid8, opts.modality_folder);
                if opts.do_overwrite && ...
                        isfolder(target_pth) && ...
                        ~isempty(mglob(fullfile(target_pth, "*.nii.gz"))) && ...
                        ~isempty(mglob(fullfile(target_pth, "*.json")))
                    % linked files already exist
                    return
                end
            catch ME
                fprintf("%s\n", ME.message);
                fprintf("%s: could not parse %s\n", stackstr(), source_fqfn);
                fprintf("\n");
                return
            end
            ensuredir(target_pth);
            linked_fqfn = fullfile(target_pth, target_fp + x);

            % ln -s
            system(sprintf("ln -s %s %s", source_fqfn, linked_fqfn));

            % manage json
            if endsWith(source_fqfn, ".nii.gz")
                linked_fqfn = link_for_3dresample(strrep(source_fqfn, ".nii.gz", ".json"), dest=opts.dest);
            end
        end
        function fld = parseFolderFromPath(patt, pth)
            %  Args:
            %      patt string {mustBeText}, e.g., "sub-", "ses-".
            %      pth string {mustBeFolder}, from which to find 1st folder name matching patt.

            arguments
                patt string {mustBeText}
                pth string {mustBeFolder}
            end

            for pidx = 1:length(pth)
                if any(contains(pth(pidx), patt))
                    ss = strsplit(pth(pidx), filesep);
                    fld(pidx) = ss(contains(ss, patt)); %#ok<AGROW> % picks first occurance
                end
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
        function re = regexp_fileprefix(fp)
            %% Args:
            %      fp, text scalar or understood by mlfourd.ImagingContext2
            %
            %  Returns:
            %      re struct with e.g. fields
            %      sub: "108293"
            %      ses: "20210421154248"
            %      trc: "oo"
            %      proc: "delay0-BrainMoCo2-createNiftiMovingAvgFrames-ScannerKit-do-make-activity-density"
            %      suff: "_timeAppend-4_finite_pet"

            arguments
                fp
            end
            if ~istext(fp)
                ic = mlfourd.ImagingContext2(fp);
                fp = ic.fileprefix;
            end

            [~,fp] = myfileparts(fp);
            re = regexp(fp, "sub-(?<sub>\S+)_ses-(?<ses>\d+)_trc-(?<trc>\S+)_proc-(?<proc>[0-9a-zA-Z\-\+,;]+)(?<suff>\S*$)", "names");
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
        originationPath_
        projectPath_
        sessionFolderForAnat_
        sessionFolderForPet_
        subjectFolder_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
end

