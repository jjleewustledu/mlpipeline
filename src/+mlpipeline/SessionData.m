classdef SessionData < mlpipeline.ISessionData & mlmr.IMRData & mlpet.IPETData
	%% SESSIONDATA  

	%  $Revision$
 	%  was created 21-Jan-2016 22:20:41
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	
    
	properties (Dependent)
        freesurfersDir
        subjectsDir
        sessionPath
        sessionFolder
        
        nacSuffix
        pnumber
        rnumber
        snumber
        vnumber
        tag
    end
    
    methods %% GET/SET
        function g    = get.freesurfersDir(this)
            g = this.studyData_.freesurfersDir;
        end        
        function g    = get.nacSuffix(this)
            if (this.nac_)
                g = '_NAC';
            else
                g = '';
            end
        end
        function g    = get.pnumber(this)
            warning('off', 'mfiles:regexpNotFound');
            g = str2pnum(this.sessionLocation('typ', 'folder'));
            warning('on', 'mfiles:regexpNotFound');
        end
        function g    = get.rnumber(this)
            g = this.rnumber_;
        end
        function this = set.rnumber(this, r)
            assert(isnumeric(r));
            this.rnumber_ = r;
        end
        function g    = get.sessionFolder(this)
            [~,g] = myfileparts(this.sessionPath_);
        end
        function g    = get.sessionPath(this)
            g = this.sessionPath_;
        end
        function this = set.sessionPath(this, s)
            assert(isdir(s));
            this.sessionPath_ = s;
        end
        function g    = get.subjectsDir(this)
            g = this.studyData_.subjectsDir;
        end
        function g    = get.snumber(this)
            g = this.snumber_;
        end
        function this = set.snumber(this, s)
            assert(isnumeric(s));
            this.snumber_ = s;
        end
        function g    = get.vnumber(this)
            g = this.vnumber_;
        end
        function this = set.vnumber(this, v)
            assert(isnumeric(v));
            this.vnumber_ = v;
        end
        function g    = get.tag(this)
            g = this.tag_;
        end
        function this = set.tag(this, t)
            assert(ischar(t));
            this.tag_ = t;
        end
    end
    
    methods (Static)
        function fn = fslchfiletype(fn, varargin)
            ip = inputParser;
            addRequired(ip, 'fn', @(x) lexist(x, 'file'));
            addOptional(ip, 'type', 'NIFTI_GZ', @ischar);
            parse(ip, fn, varargin{:});
            
            fprintf('mlpipeline.SessionData.fslchfiletype is working on %s\n', ip.Results.fn);
            mlpipeline.PipelineVisitor.cmd('fslchfiletype', 'NIFTI_GZ', ip.Results.fn);
            [p,f] = myfileparts(fn);
            fn = fullfile(p, [f mlfourd.INIfTI.FILETYPE_EXT]);
        end
        function fn = mri_convert(fn, varargin)
            import mlpipeline.*;
            ip = inputParser;
            addRequired(ip, 'fn',                                 @(x) lexist(x, 'file'));
            addOptional(ip, 'fn2', SessionData.niigzFilename(fn), @ischar);
            parse(ip, fn, varargin{:});            
            
            fprintf('mlpipeline.SessionData.mri_convert is working on %s\n', ip.Results.fn);
            mlpipeline.PipelineVisitor.cmd('mri_convert', ip.Results.fn, ip.Results.fn2);
            fn = ip.Results.fn2;
        end
        function [s,r] = nifti_4dfp_4(varargin)
            vtor = mlfourdfp.FourdfpVisitor;
            [s,r] = vtor.nifti_4dfp_4(varargin{:});
        end
        function [s,r] = nifti_4dfp_n(varargin)
            vtor = mlfourdfp.FourdfpVisitor;
            [s,r] = vtor.nifti_4dfp_n(varargin{:});
        end
        function [s,r] = nifti_4dfp_ng(varargin)
            vtor = mlfourdfp.FourdfpVisitor;
            [s,r] = vtor.nifti_4dfp_ng(varargin{:});
        end
    end
    
	methods
 		function this = SessionData(varargin)
 			%% SESSIONDATA
 			%  @param [param-name, param-value[, ...]]
            %         'nac'         is logical
            %         'rnumber'     is numeric
            %         'sessionPath' is a path to the session data
            %         'studyData'   is a mlpipeline.StudyDataSingleton
            %         'snumber'     is numeric
            %         'tracer'      is char
            %         'vnumber'     is numeric
            %         'tag'         is appended to the fileprefix

            ip = inputParser;
            addParameter(ip, 'nac', true,        @islogical);
            addParameter(ip, 'rnumber', 1,       @isnumeric);
            addParameter(ip, 'sessionPath', pwd, @isdir);
            addParameter(ip, 'studyData', [],    @(x) isa(x, 'mlpipeline.StudyDataSingletonHandle'));
            addParameter(ip, 'snumber', 1,       @isnumeric);
            addParameter(ip, 'tracer', '',       @ischar);
            addParameter(ip, 'vnumber', 1,       @isnumeric);
            addParameter(ip, 'tag', '',          @ischar);
            parse(ip, varargin{:});
            
            this.nac_         = ip.Results.nac;
            this.rnumber_     = ip.Results.rnumber;
            this.sessionPath_ = ip.Results.sessionPath;
            this.studyData_   = ip.Results.studyData;
            this.snumber_     = ip.Results.snumber;
            this.tracer_      = ip.Results.tracer;
            this.vnumber_     = ip.Results.vnumber;
            this.tag          = ip.Results.tag;
        end
        function fqfn = ensureNIFTI_GZ(this, obj)
            %% ENSURENIFTI_GZ ensures a .nii.gz file on the filesystem if at all possible.
            %  @param fn is a filename for an existing filesystem object; it may alternatively be an mlfourd.ImagingContext.
            %  @returns changes on the filesystem so that input fn manifests as an imaging file of type NIFTI_GZ 
            %  per the notation of fsl's fslchfiletype.
            %  See also:  mlpipeline.SessionData.fslchfiletype, mlpipeline.SessionData.mri_convert.
            
            if (isa(obj, 'mlfourd.ImagingContext'))   
                fqfn = obj.fqfilename;             
                if (~lexist(fqfn, 'file'))
                    obj.save;
                end
                return
            end
            if (ischar(obj))
                if (~lexist(obj, 'file'))
                    fprintf('Info: SessionData.ensureNIFTI_GZ could not find file %s\n', obj);
                    fqfn = obj;
                    return
                end
                [p,f,e] = myfileparts(obj);
                switch (e)
                    case '.nii.gz'
                        fqfn = obj;
                        return
                    case '.hdr'
                        analyzefn = fullfile(p, [f '.hdr']);
                        fqfn      = fullfile(p, [f '.nii.gz']);
                        if (~lexist(fqfn))
                            this.fslchfiletype(analyzefn);
                        end
                        return
                    case {'.4dfp.ifh' '.4dfp.hdr' '.4dfp.img' '.4dfp.img.rec'}
                        fqfp = fullfile(p, f);
                        this.nifti_4dfp_ng(fqfp);
                        return
                    otherwise
                        fqfn = fullfile(p, [f '.nii.gz']);
                        this.mri_convert(obj, fqfn)
                        return
                end
            end            
            error('mlpipeline:unsupportedTypeclass', ...
                  'class(SessionData.ensureNIFTI_GZ.obj) -> %s', class(obj));
        end
        function loc  = sessionLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = this.studyData_.locationType(ip.Results.typ, this.sessionPath_);
        end
        function loc  = vLocation(this, varargin)
            loc = this.sessionLocation(varargin{:});
        end
        
        %% IMRData
        
        function loc = fourdfpLocation(this, varargin)
            loc = this.vLocation(varargin{:});
        end
        function loc = freesurferLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = this.studyData_.locationType(ip.Results.typ, ...
                fullfile(this.freesurfersDir, this.sessionLocation('typ', 'folder'), ''));
        end
        function loc = fslLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = this.studyData_.locationType(ip.Results.typ, ...
                fullfile(this.vLocation, 'fsl', ''));
        end
        function loc = mriLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = this.studyData_.locationType(ip.Results.typ, ...
                fullfile(this.freesurferLocation, 'mri', ''));
        end
        
        function obj = adc(~, obj)
        end
        function obj = aparcA2009sAseg(this, varargin)
            obj = this.freesurferObject('aparc.a2009s+aseg', varargin{:});
        end
        function obj = asl(this, varargin)
            obj = this.mrObject('pcasl', varargin{:});
        end
        function obj = atlas(~, obj)
        end
        function obj = boldResting(this, varargin)
            obj = this.mrObject('ep2d_bold_150', varargin{:});
        end
        function obj = boldTask(this, varargin)
            obj = this.mrObject('ep2d_bold_154', varargin{:});
        end
        function obj = brain(this, varargin)
            obj = this.freesurferObject('brain', varargin{:});
        end
        function obj = dwi(~, obj)
        end
        function obj = fieldmap(this, varargin)
            obj = this.mrObject('FieldMapping', varargin{:});
        end
        function obj = localizer(this, varargin)
            obj = this.mrObject('localizer', varargin{:});
        end
        function obj = mpr(this, varargin)
            obj = this.mprage(varargin{:});
        end        
        function obj = mprage(this, varargin)
            obj = this.mrObject('mpr', varargin{:});
        end
        function obj = orig(this, varargin)
            obj = this.freesurferObject('orig', varargin{:});
        end        
        function obj = perf(this, varargin)
            obj = this.mrObject('ep2d_perf', varargin{:});
        end
        function obj = T1(this, varargin)
            obj = this.freesurferObject('T1', varargin{:});
        end
        function obj = t1(this, varargin)
            obj = this.mprage(varargin{:});
        end        
        function obj = t2(this, varargin)
            obj = this.mrObject('', varargin{:});
            
            obj = this.studyData_.imagingType(typ, ...
                fullfile(this.fourdfpLocation, ['t2' this.filetypeExt]));
        end
        function obj = tof(~, obj)
        end
        function obj = wmparc(this, varargin)
            obj = this.freesurferObject('wmparc', varargin{:});
        end
                
        %% IPETData
        
        function loc = hdrinfoLocation(this, varargin)
            loc = this.vLocation(varargin{:});
        end
        function loc = petLocation(this, varargin)
            loc = this.vLocation(varargin{:});
        end
        function loc = scanLocation(this, varargin)
            loc = this.vLocation(varargin{:});
        end
        
        function obj = ct(~, obj)
        end
        function obj = fdg(this, varargin)
            obj = this.petObject('fdg', 'noSnumber', true, varargin{:});
        end
        function obj = gluc(this, varargin)
            obj = this.petObject('gluc', varargin{:});
        end 
        function obj = ho(this, varargin)
            obj = this.petObject('ho', varargin{:});
        end
        function obj = oc(this, varargin)
            obj = this.petObject('oc', varargin{:});
        end
        function obj = oo(this, varargin)
            obj = this.petObject('oo', varargin{:});
        end
        function obj = tr(this, varargin)
            obj = this.petObject('tr', varargin{:});
        end
        function obj = umap(~, obj)
        end       
    end 

    %% PROTECTED
    
    properties (Access = protected)
        nac_
        rnumber_
        sessionPath_
        studyData_
        snumber_
        tracer_
        vnumber_
        tag_
    end
    
    methods (Access = protected)
        function obj = fqfilenameObject(this, varargin)
            ip = inputParser;
            addRequired( ip, 'fqfn', @(x) lexist(x, 'file'));
            addParameter(ip, 'suffix', '', @ischar);
            addParameter(ip, 'typ', 'mlfourd.ImagingContext', @ischar);
            parse(ip, varargin{:});
            
            obj = this.studyData_.imagingType(ip.Results.typ, ip.Results.fqfn);
        end
        function obj = freesurferObject(this, varargin)
            ip = inputParser;
            addRequired( ip, 'desc', @ischar);
            addParameter(ip, 'suffix', '', @ischar);
            addParameter(ip, 'typ', 'mlmr.MRImagingContext', @ischar);
            parse(ip, varargin{:});
            
            obj = this.studyData_.imagingType(ip.Results.typ, ...
                fullfile(this.mriLocation, ...
                         sprintf('%s%s.mgz', ip.Results.desc, ip.Results.suffix)));
        end
        function obj = mrObject(this, varargin)
            ip = inputParser;
            addRequired( ip, 'desc', @ischar);
            addParameter(ip, 'suffix', '', @ischar);
            addParameter(ip, 'typ', 'mlmr.MRImagingContext', @ischar);
            parse(ip, varargin{:});
            
            obj = this.studyData_.imagingType(ip.Results.typ, ...
                fullfile(this.fslLocation, ...
                         sprintf('%s%s%s', ip.Results.desc, ip.Results.suffix, this.filetypeExt)));
        end 
        function obj = petObject(this, varargin)
            ip = inputParser;
            addRequired( ip, 'tracer', @ischar);
            addParameter(ip, 'suffix', '', @ischar);
            addParameter(ip, 'typ', 'mlpet.PETImagingContext', @ischar);
            parse(ip, varargin{:});
            
            obj = this.studyData_.imagingType(ip.Results.typ, ...
                fullfile(this.petLocation, ...
                         sprintf('%s%i%s%s%s', ip.Results.tracer, this.snumber, ip.Results.suffix, this.nacSuffix, this.filetypeExt)));
        end
    end
    
    methods (Static, Access = protected)
        function ic = cropImaging(ic, varargin)
            ip = inputParser;
            addRequired(ip, 'ic', @(x) isa(x, 'mlfourd.ImagingContext'));
            addOptional(ip, 'fractions', [0.5 0.5 1 1], @(x) isnumeric(x) && (4 == length(x)));
            parse(ip, ic, varargin{:});
            fr = ip.Results.fractions;
            
            niid = ic.niftid;
            for r = 1:niid.rank
                if (fr(r) < 1)
                    cropping{r} = ceil(0.5*fr(r)*niid.size(r)):floor((1-0.5*fr(r))*niid.size(r)); %#ok<AGROW>
                else
                    cropping{r} = 1:niid.size(r); %#ok<AGROW>
                end
            end
            niid.img = niid.img(cropping{:});            
            niid = niid.append_fileprefix('_crop');
            ic = mlfourd.ImagingContext.repackageImagingContext(niid, class(ic));
        end
        function ic = flip(ic, dim)
            niid = ic.niftid;
            niid.img = flip(niid.img, dim);
            niid = niid.append_fileprefix(sprintf('_flip%i', dim));
            ic = mlfourd.ImagingContext.repackageImagingContext(niid, class(ic));
        end
        function ic = flipAndCropImaging(ic, varargin)
            ip = inputParser;
            addRequired( ip, 'ic', @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(ip, 'fractions', [0.5 0.5 1 1], @(x) isnumeric(x) && (4 == length(x)));
            addParameter(ip, 'flipdim', 2, @isnumeric);
            parse(ip, ic, varargin{:});
            fr = ip.Results.fractions;
            
            niid = ic.niftid;
            fprintf('SessionData.flipAndCropImaging is flipping %s\n', niid.fqfilename);
            niid.img = flip(niid.img, ip.Results.flipdim);
            
            fprintf('SessionData.flipAndCropImaging is cropping %s\n', niid.fqfilename);
            for r = 1:niid.rank
                if (fr(r) < 1)
                    cropping{r} = ceil(0.5*fr(r)*niid.size(r)):floor((1-0.5*fr(r))*niid.size(r)); %#ok<AGROW>
                else
                    cropping{r} = 1:niid.size(r); %#ok<AGROW>
                end
            end
            niid.img = niid.img(cropping{:});
            if (lstrfind(niid.fileprefix, '.4dfp'))
                niid.fileprefix = niid.fileprefix(1:strfind(niid.fileprefix, '.4dfp')-1);
            end
            niid = niid.append_fileprefix(sprintf('_flip%i_crop', ip.Results.flipdim));
            ic = mlfourd.ImagingContext.repackageImagingContext(niid, class(ic));
            ic.save;
        end
        function f  = fullfile(~, varargin)
            assert(~isempty(varargin));
            if (1 == length(varargin))
                f = varargin{1};
                return
            end
            path = fullfile(varargin{1:end-1});
            assert(isdir(path));
            assert(ischar(varargin{end}));
            
            f = fullfile(path,                           varargin{end});
            if (lexist(f, 'file')); return; end            
            f = fullfile(path, sprintf('%s.nii.gz',      varargin{end}));
            if (lexist(f, 'file')); return; end
            f = fullfile(path, sprintf('%s.4dfp.nii.gz', varargin{end}));
            if (lexist(f, 'file')); return; end
            f = fullfile(path, sprintf('%s.4dfp.ifh',    varargin{end}));
            if (lexist(f, 'file')); return; end
            f = '';
            return
        end        
        function fn = niigzFilename(fn)
            [p,f] = myfileparts(fn);
            fn = fullfile(p, [f '.nii.gz']);
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

