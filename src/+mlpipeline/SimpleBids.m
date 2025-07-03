classdef SimpleBids < handle & mlpipeline.IBids
   %% Accomodates data not adhering to BIDS
    %  
    %  Created 07-Mar-2023 00:00:11 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.13.0.2126072 (R2022b) Update 3 for MACI64.  Copyright 2023 John J. Lee.
    
    properties
        flair_toglob
        pet_dyn_toglob
        pet_static_toglob
        t1w_toglob
        t2w_toglob
        tof_toglob
    end

    properties (Constant)
        BIDS_MODALITIES = {}
        DLICV_TAG = 'DLICV'
        SURFER_VERSION = ''
    end

	properties (Dependent)
        PROJECT_FOLDER

        atlas_ic
        dlicv_ic
        flair_ic
        T1_ic % FreeSurfer
        t1w_ic
        t2w_ic
        tof_ic
        tof_on_t1w_ic
        wmparc_ic % FreeSurfer

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
        rawAnatPath
        rawdataPath
        rawPetPath
        sessionFolderForAnat
        sessionFolderForPet
        sourcedataPath
        sourceAnatPath
        sourcePetPath
        subjectFolder
        surferFolder
    end

	methods % GET
        function g = get.PROJECT_FOLDER(this)
            [~,g] = fileparts(this.projectPath);
        end

        function g = get.atlas_ic(~)
            g = mlfourd.ImagingContext2( ...
                fullfile(getenv('FSLDIR'), 'data', 'standard', 'MNI152_T1_1mm.nii.gz'));
        end
        function g = get.dlicv_ic(this)
            if ~isempty(this.dlicv_ic_)
                g = copy(this.dlicv_ic_);
                return
            end
            try                
                if mysystem('which nvidia-docker') > 0
                    g = [];
                    return
                end
                this.dlicv_ic_ = mlfourd.ImagingContext2( ...
                    sprintf('%s_%s.nii.gz', this.t1w_ic.fqfileprefix, this.DLICV_TAG));
                if ~isfile(this.dlicv_ic_.fqfn)
                    try
                        r = '';
                        [~,r] = this.build_dlicv(this.t1w_ic, this.dlicv_ic_);
                        assert(isfile(this.dlicv_ic_))
                    catch ME
                        disp(r)
                        handwarning(ME)
                    end
                end
                g = copy(this.dlicv_ic_);
            catch ME
                handwarning(ME)
                g = [];
            end
        end
        function g = get.flair_ic(this)
            if ~isempty(this.flair_ic_)
                g = copy(this.flair_ic_);
                return
            end
            try
                globbed = globT(this.flair_toglob);
                globbed = globbed(~contains(globbed, '_orient-std'));
                fn = globbed{end};
                fn1 = fullfile(this.anatPath, strcat(mybasename(fn), '_orient-std.nii.gz'));
                if ~isfile(fn1)
                    this.build_orientstd(fn);
                end
                this.flair_ic_ = mlfourd.ImagingContext2(fn1);
                g = copy(this.flair_ic_);
            catch ME
                handwarning(ME)
            end
        end
        function     set.flair_ic(this, s)
            this.flair_ic_ = mlfourd.ImagingContext2(s);
            if ~contains(this.flair_ic_.fileprefix, '_orient_std')
                this.flair_ic_ = this.build_orientstd(this.flair_ic_.fqfn);
            end
        end
        function g = get.T1_ic(this)
            if ~isempty(this.T1_ic_)
                g = copy(this.T1_ic_);
                return
            end
            fn = fullfile(this.mriPath, 'T1.mgz');
            assert(isfile(fn))
            this.T1_ic_ = mlfourd.ImagingContext2(fn);
            this.T1_ic_.selectNiftiTool();
            this.T1_ic_.filepath = this.anatPath;
            this.T1_ic_.save();
            g = copy(this.T1_ic_);
        end
        function g = get.t1w_ic(this)
            if ~isempty(this.t1w_ic_)
                g = copy(this.t1w_ic_);
                return
            end
            try
                globbed = globT(this.t1w_toglob, '-ignorecase');
                globbed = globbed(~contains(globbed, this.DLICV_TAG));
                globbed = globbed(~contains(globbed, '_orient-std'));
                globbed = globbed(~contains(globbed, 'imdilate'));
                globbed = globbed(~contains(globbed, 'fslroi'));
                globbed = globbed(~contains(globbed, 'T1_'));
                globbed = globbed(~contains(globbed, 'wmparc'));
                globbed = globbed(~contains(globbed, 'mra'));
                globbed = globbed(~contains(globbed, 'flair'));
                globbed = globbed(~contains(globbed, 'CBF'));
                globbed = globbed(~contains(globbed, 'OEF'));
                globbed = globbed(~contains(globbed, 'FDG'));
                globbed = globbed(~contains(globbed, 'sample'));
                fn = globbed{end};
                fn1 = fullfile(this.anatPath, strcat(mybasename(fn), '_orient-std.nii.gz'));
                if ~isfile(fn1)
                    this.build_orientstd(fn);
                end
                this.t1w_ic_ = mlfourd.ImagingContext2(fn1);
                g = copy(this.t1w_ic_);
            catch ME
                handwarning(ME)
            end
        end
        function     set.t1w_ic(this, s)
            this.t1w_ic_ = mlfourd.ImagingContext2(s);
            if ~contains(this.t1w_ic_.fileprefix, '_orient_std')
                this.t1w_ic_ = this.build_orientstd(this.t1w_ic_.fqfn);
            end
        end
        function g = get.t2w_ic(this)
            if ~isempty(this.t2w_ic_)
                g = copy(this.t2w_ic_);
                return
            end
            try
                globbed = globT(this.t2w_toglob);
                globbed = globbed(~contains(globbed, '_orient-std'));
                fn = globbed{end};
                fn1 = fullfile(this.anatPath, strcat(mybasename(fn), '_orient-std.nii.gz'));
                if ~isfile(fn1)
                    this.build_orientstd(fn);
                end
                this.t2w_ic_ = mlfourd.ImagingContext2(fn1);
                g = copy(this.t2w_ic_);
            catch ME
                %handwarning(ME)
            end
        end
        function     set.t2w_ic(this, s)
            this.t2w_ic_ = mlfourd.ImagingContext2(s);
            if ~contains(this.t2w_ic_.fileprefix, '_orient_std')
                this.t2w_ic_ = this.build_orientstd(this.t2w_ic_.fqfn);
            end
        end
        function g = get.tof_ic(this)
            if ~isempty(this.tof_ic_)
                g = copy(this.tof_ic_);
                return
            end
            try
                globbed = globT(this.tof_toglob);
                globbed = globbed(~contains(globbed, '_orient-std'));
                globbed = globbed(~contains(globbed, 'imdilate'));
                globbed = globbed(~contains(globbed, 'fslroi'));
                globbed = globbed(~contains(globbed, 'T1_'));
                globbed = globbed(~contains(globbed, 'wmparc'));
                globbed = globbed(~contains(globbed, 'mpr'));
                globbed = globbed(~contains(globbed, 'flair'));
                globbed = globbed(~contains(globbed, 'CBF'));
                globbed = globbed(~contains(globbed, 'OEF'));
                globbed = globbed(~contains(globbed, 'FDG'));
                globbed = globbed(~contains(globbed, 'sample'));
                fn = globbed{end};
                fn1 = fullfile(this.anatPath, strcat(mybasename(fn), '_orient-std.nii.gz'));
                if ~isfile(fn1)
                    this.build_orientstd(fn);
                end
                this.tof_ic_ = mlfourd.ImagingContext2(fn1);
                g = copy(this.tof_ic_);
            catch ME
                handwarning(ME)
            end
        end
        function     set.tof_ic(this, s)
            this.tof_ic_ = mlfourd.ImagingContext2(s);
            if ~contains(this.tof_ic_.fileprefix, '_orient_std')
                this.tof_ic_ = this.build_orientstd(this.tof_ic_.fqfn);
            end
        end
        function g = get.tof_on_t1w_ic(this)
            if ~isempty(this.tof_on_t1w_ic_)
                g = copy(this.tof_on_t1w_ic_);
                return
            end
            try
                fn = strcat(this.tof_ic.fqfp, '_on_T1w.nii.gz');
                if isfile(fn)
                    this.tof_on_t1w_ic_ = mlfourd.ImagingContext2(fn);
                    g = copy(this.tof_on_t1w_ic_);
                    return
                end
                f = mlfsl.Flirt( ...
                    'in', this.tof_ic.fqfn, ...
                    'ref', this.t1w_ic.fqfn, ...
                    'out', fn, ...
                    'noclobber', true);
                f.flirt();
                this.tof_on_t1w_ic_ = mlfourd.ImagingContext2(fn);
                g = copy(this.tof_on_t1w_ic_);
            catch ME
                handwarning(ME)
            end
        end
        function g = get.wmparc_ic(this)
            if ~isempty(this.wmparc_ic_)
                g = copy(this.wmparc_ic_);
                return
            end
            try
                fn = fullfile(this.mriPath, 'wmparc.mgz');
                assert(isfile(fn))
                this.wmparc_ic_ = mlfourd.ImagingContext2(fn);
                this.wmparc_ic_.selectNiftiTool();
                this.wmparc_ic_.filepath = this.anatPath;
                this.wmparc_ic_.save();
                g = copy(this.wmparc_ic_);
            catch ME
                handwarning(ME)
            end
        end

        function g = get.anatFolder(~)
            g = '';
        end
        function g = get.anatPath(this)
            g = this.derivAnatPath;
        end
        function g = get.derivAnatPath(this)
            g = fullfile(this.derivativesPath, this.subjectFolder, this.sessionFolderForAnat, this.anatFolder, '');
        end
        function g = get.derivativesPath(this)
            g = fullfile(this.projectPath, '', '');
        end
        function g = get.derivPetPath(this)
            g = fullfile(this.derivativesPath, this.subjectFolder, this.sessionFolderForPet, this.petFolder, '');
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
            g = '';
        end
        function g = get.petPath(this)
            g = this.derivPetPath;
        end
        function g = get.projectPath(this)
            g = this.projectPath_;
        end
        function g = get.rawAnatPath(this)
            g = fullfile(this.rawdataPath, this.subjectFolder, this.sessionFolderForAnat, this.anatFolder, '');
        end
        function g = get.rawdataPath(this)
            g = fullfile(this.projectPath, '', '');
        end
        function g = get.rawPetPath(this)
            g = fullfile(this.rawdataPath, this.subjectFolder, this.sessionFolderForPet, this.petFolder, '');
        end
        function g = get.sessionFolderForAnat(this)
            g = this.sessionFolderAnat_;
        end
        function g = get.sessionFolderForPet(this)
            g = this.sessionFolderPet_;
        end
        function g = get.sourceAnatPath(this)
            g = fullfile(this.sourcedataPath, this.subjectFolder, this.sessionFolderForAnat, this.anatFolder, '');
        end
        function g = get.sourcedataPath(this)
            g = fullfile(this.projectPath, '', '');
        end
        function g = get.sourcePetPath(this)
            g = fullfile(this.sourcedataPath, this.subjectFolder, this.sessionFolderForPet, this.petFolder, '');
        end
        function g = get.subjectFolder(this)
            g = this.subjectFolder_;
        end
        function g = get.surferFolder(this)
            g = this.subjectFolder;
        end
    end

    methods
        function [s,r] = build_dlicv(~, t1w, dlicv)
            %% nvidia-docker run -it -v $(pwd):/data --rm jjleewustledu/deepmrseg_image:20220615 --task dlicv --inImg fileprefix.nii.gz --outImg fileprefix_DLICV.nii.gz

            try
                warning('off', 'mfiles:ChildProcessWarning')
                image = 'jjleewustledu/deepmrseg_image:20220615';
                pwd0 = pushd(t1w.filepath);
                cmd = sprintf('nvidia-docker run -it -v %s:/data --rm %s --task dlicv --inImg %s --outImg %s', ...
                    t1w.filepath, image, t1w.filename, dlicv.filename);
                [s,r] = mlbash(cmd);
                popd(pwd0)
                warning('on', 'mfiles:ChildProcessWarning')
            catch
            end
        end
        function [ic,s,r] = build_orientstd(this, varargin)
            %  Args:
            %      patt (text): e.g., this.t1w_toglob ~ fullfile(this.sourceAnatPath, 'sub-*_T1w_MPR_vNav_4e_RMS.nii.gz')

            ip = inputParser;
            addOptional(ip, 'patt', this.t1w_toglob, @istext)
            addOptional(ip, 'destination_path', this.anatPath, @isfolder)
            parse(ip, varargin{:});
            ipr = ip.Results;

            ic = [];
            for g = glob(ipr.patt)

                ensuredir(ipr.destination_path);
                ic = mlfourd.ImagingContext2(g{1});
                ic.afni_3dresample(orient_std=true);
                if ~strcmp(ipr.destination_path, ic.filepath)
                    movefile(ic.fqfileprefix + ".*", ipr.destination_path);
                end

                %% afni_3dresample is more robust for pipelines than fslreorient2std

                % [~,fp] = myfileparts(g{end});
                % fqfn = fullfile(ipr.destination_path, strcat(fp, '_orient-std.nii.gz'));
                % ensuredir(strrep(myfileparts(g{1}), 'sourcedata', 'derivatives'));
                % ic = mlfourd.ImagingContext2(g{1});                
                % cmd = sprintf('fslreorient2std %s %s', g{1}, fqfn);
                % [s,r] = mlbash(cmd);
                % ic = mlfourd.ImagingContext2(fqfn);
                % ic.selectNiftiTool();
                % ic.save();
            end
            s = [];
            r = "";
        end
        function [s,r] = build_robustfov(this, varargin)
            %  Args:
            %      patt (text): e.g., this.t1w_toglob ~ fullfile(this.sourceAnatPath, 'sub-*_T1w_MPR_vNav_4e_RMS.nii.gz')

            ip = inputParser;
            addOptional(ip, 'patt', this.t1w_toglob, @istext)
            addOptional(ip, 'destination_path', this.anatPath, @isfolder)
            parse(ip, varargin{:});
            ipr = ip.Results;

            for g = glob(ipr.patt)
                [~,fp] = myfileparts(g{end});
                fqfp = fullfile(ipr.destination_path, fp);
                cmd = sprintf('robustfov -i %s -r %s_robustfov.nii.gz -m %s_robustfov.mat', g{1}, fqfp, fqfp);
                [s,r] = mlbash(cmd);
            end
        end
        function ic = flirt_dyn_to_t1w(this, dyn, t1w, opts)
            %% FLIRT_DYN_TO_T1W time-averages dyn to static PET (as needed),
            %  saves the static, then forwards the static to flirt_static_to_t1w().
            %  Input:
            %      dyn {mustBeNonempty}  % understood by mlfourd.ImagingContext2
            %      t1w {mustBeNonempty}  % "
            %      opts.taus double = [] % provided to ImagingContext2.timeAveraged(taus=opts.taus)
            %  Output:
            %      ic mlfourd.ImagingContext2

            arguments %(Input)
                this mlpipeline.SimpleBids
                dyn {mustBeNonempty}
                t1w {mustBeNonempty}
                opts.taus double = []
            end
            %arguments (Output)
            %     ic mlfourd.ImagingContext2
            %end
            dyn = mlfourd.ImagingContext2(dyn); % ensures copy
            t1w = mlfourd.ImagingContext2(t1w); % "
            assert(isfile(dyn))

            isdyn = 4 == length(size(dyn));
            if isdyn
                if isempty(opts.taus)
                    opts.taus = 1:size(dyn, 4);
                end
                static = dyn.timeAveraged(taus=opts.taus);
            end
            static.save();
            ic = this.flirt_static_to_t1w(static, t1w);
        end
        function ic = flirt_static_to_t1w(this, static, t1w)
            %% FLIRT_STATIC_TO_T1W flirts static PET to t1w, preferably high-quality MPRAGE.
            %  Attempts to update json with flirted cost_final.
            %  Input:
            %      static {mustBeNonempty}  % understood by mlfourd.ImagingContext2
            %      t1w {mustBeNonempty}  % "
            %  Output:
            %      ic mlfourd.ImagingContext2

            arguments % (Input)
                this mlpipeline.SimpleBids
                static {mustBeNonempty}
                t1w {mustBeNonempty}
            end
            %arguments (Output)
            %     ic mlfourd.ImagingContext2
            %end
            static = mlfourd.ImagingContext2(static); % ensures copy
            t1w = mlfourd.ImagingContext2(t1w);       % "
            assert(isfile(static))
            assert(isfile(t1w))
            
            ic = mlfourd.ImagingContext2(this.on(static, t1w));
            flirted = mlfsl.Flirt( ...
                'in', static.fqniigz, ...
                'ref', t1w.fqniigz, ...
                'out', ic.fqniigz, ...
                'omat', ic.fqmat, ...
                'bins', 256, ...
                'cost', 'mutualinfo', ...
                'dof', 6, ...
                'searchrx', 180, ...
                'interp', 'trilinear');
            flirted.flirt();

            try
                j0 = fileread(static.fqjson);
                [~,j1] = flirted.cost_final();
                jsonrecode(ic, j0, j1);
            catch
            end
        end
        function f = fqon(~, a, b)
            a = mlfourd.ImagingContext2(a);
            b = mlfourd.ImagingContext2(b);
            if endsWith(b.fileprefix, 't1w', IgnoreCase=true)
                f = strcat(a.fqfp, '_on_T1w', a.filesuffix);
                return
            end
            if endsWith(b.fileprefix, 't2w', IgnoreCase=true)
                f = strcat(a.fqfp, '_on_T2w', a.filesuffix);
                return
            end
            if contains(b.fileprefix, 'flair', IgnoreCase=true)
                f = strcat(a.fqfp, '_on_flair', a.filesuffix);
                return
            end
            if contains(b.fileprefix, 'tof', IgnoreCase=true)
                f = strcat(a.fqfp, '_on_tof', a.filesuffix);
                return
            end

            f = strcat(a.fqfp, '_on_', b.fileprefix, a.filesuffix);
        end        
        function r = registry(~)
            r = mlpipeline.SimpleRegistry.instance();
        end
        function g = taus(this, trc)
            g = this.registry.tausMap(trc);
        end

        function this = SimpleBids(varargin)
            %  Args:
            %      destinationPath (folder): will receive outputs.  
            %      projectPath (folder): contains subject folders
            %      subjectFolder (text): is the string for subject identity.
            %      sessionFolderForAnat (text): is the string for session/anat identity.
            %      sessionFolderForPet (text): is the string for session/pet identity.

            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'destinationPath', pwd, @isfolder)
            addParameter(ip, 'projectPath', '', @istext)
            addParameter(ip, 'subjectFolder', '', @istext)
            addParameter(ip, 'sessionFolderForAnat', '', @istext)
            addParameter(ip, 'sessionFolderForPet', '', @istext)
            addParameter(ip, 'flair_fn_toglob', '*flair*.nii.gz', @istext)
            addParameter(ip, 'pet_dyn_fn_toglob', '*FDG*.nii.gz', @istext)
            addParameter(ip, 'pet_static_fn_toglob', '*mFDG*.nii.gz', @istext)
            addParameter(ip, 't1w_fn_toglob', '*mpr*.nii.gz', @istext)
            addParameter(ip, 't2w_fn_toglob', '*t2*.nii.gz', @istext)
            addParameter(ip, 'tof_fn_toglob', '*mra*.nii.gz', @istext)
            parse(ip, varargin{:})
            ipr = ip.Results;
            this.destinationPath_ = ipr.destinationPath;
            this.projectPath_ = ipr.projectPath;
            this.subjectFolder_ = ipr.subjectFolder;
            this.sessionFolderAnat_ = ipr.sessionFolderForAnat;
            this.sessionFolderPet_ = ipr.sessionFolderForPet;

            this.flair_toglob = fullfile(this.sourceAnatPath, ipr.flair_fn_toglob);
            this.pet_dyn_toglob = fullfile(this.sourcePetPath, ipr.pet_dyn_fn_toglob);
            this.pet_static_toglob = fullfile(this.sourcePetPath, ipr.pet_static_fn_toglob);
            this.t1w_toglob = fullfile(this.sourceAnatPath, ipr.t1w_fn_toglob);
            this.t2w_toglob = fullfile(this.sourceAnatPath, ipr.t2w_fn_toglob);
            this.tof_toglob = fullfile(this.sourceAnatPath, ipr.tof_fn_toglob);

        end
    end

    methods (Static)
        function fn1 = afni_3dresample(fn, varargin)
            fn1 = mlpipeline.Bids.afni_3dresample(fn, varargin{:});
        end
        function this = create(varargin)
            this = mlpipeline.SimpleBids(varargin{:});
        end
        function [s,r] = dcm2niix(varargin)
            [s,r] = mlpipeline.Bids.dcm2niix(varargin{:});
        end
        function txt = info2json(info)
            for f = asrow(fields(info))
                if numel(info.(f{1})) > 100
                    large = info.(f{1}); 
                    info.(f{1}) = large(1:20);
                end
            end
            txt = jsonencode(info, 'PrettyPrint', true);
            txt = strrep(txt, '\', '_');
        end
        function fld = parseFolderFromPath(patt, pth)
            fld = mlpipeline.Bids.parseFolderFromPath(patt, pth);
        end
    end
    
    %% PROTECTED

    methods (Access = protected)
        function that = copyElement(this)
            that = copyElement@matlab.mixin.Copyable(this);
            if ~isempty(this.atlas_ic_)
                that.atlas_ic_ = copy(this.atlas_ic_);
            end
            if ~isempty(this.dlicv_ic_)
                that.dlicv_ic_ = copy(this.dlicv_ic_);
            end
            if ~isempty(this.flair_ic_)
                that.flair_ic_ = copy(this.flair_ic_);
            end
            if ~isempty(this.T1_ic_)
                that.T1_ic_ = copy(this.T1_ic_);
            end
            if ~isempty(this.t1w_ic_)
                that.t1w_ic_ = copy(this.t1w_ic_);
            end
            if ~isempty(this.t2w_ic_)
                that.t2w_ic_ = copy(this.t2w_ic_);
            end
            if ~isempty(this.tof_ic_)
                that.tof_ic_ = copy(this.tof_ic_);
            end
            if ~isempty(this.wmparc_ic_)
                that.wmparc_ic_ = copy(this.wmparc_ic_);
            end
        end
    end

    properties (Access = protected)
        atlas_ic_
        dlicv_ic_
        flair_ic_
        T1_ic_
        t1w_ic_
        t2w_ic_
        tof_ic_
        tof_on_t1w_ic_
        wmparc_ic_

        destinationPath_
        projectPath_
        sessionFolderAnat_
        sessionFolderPet_
        subjectFolder_
    end

    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
