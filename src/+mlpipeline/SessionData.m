classdef SessionData < mlpipeline.ISessionData & mlmr.IMRData & mlpet.IPETData
	%% SESSIONDATA  
    %  @param builder is an mlpipeline.IDataBuilder.

	%  $Revision$
 	%  was created 21-Jan-2016 22:20:41
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.  Copyright 2017 John Joowon Lee.
 	
    
    properties
        allowDirNotYetExisting = true
    end
    
	properties (Dependent)
        freesurfersDir
        sessionFolder
        sessionPath
        studyData
        subjectsDir
        subjectsFolder
        
        absScatterCorrected
        attenuationCorrected
        builder
        isotope
        pnumber
        rnumber
        region
        snumber
        tracer
        vnumber
    end
    
    methods (Static)
        function fn    = fslchfiletype(fn, varargin)
            ip = inputParser;
            addRequired(ip, 'fn', @(x) lexist(x, 'file'));
            addOptional(ip, 'type', 'NIFTI_GZ', @ischar);
            parse(ip, fn, varargin{:});
            
            fprintf('mlpipeline.SessionData.fslchfiletype is working on %s\n', ip.Results.fn);
            mlpipeline.PipelineVisitor.cmd('fslchfiletype', 'NIFTI_GZ', ip.Results.fn);
            [p,f] = myfileparts(fn);
            fn = fullfile(p, [f mlfourd.INIfTI.FILETYPE_EXT]);
        end
        function fn    = mri_convert(fn, varargin)
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
        
        %% GET/SET
        
        function g    = get.freesurfersDir(this)
            g = this.studyData_.freesurfersDir;
        end
        function g    = get.subjectsDir(this)
            g = this.studyData_.subjectsDir;
        end
        function this = set.subjectsDir(this, s)
            this.assertIsdir(s);
            newStudyData_ = this.studyData_;
            newStudyData_.subjectsDir = s;
            this.studyData_ = newStudyData_;
        end
        function g    = get.subjectsFolder(this)
            g = this.studyData_.subjectsFolder;
        end
        function this = set.subjectsFolder(this, s)
            newStudyData_ = this.studyData_;
            newStudyData_.subjectsFolder = s;
            this.studyData_ = newStudyData_;
            this.assertIsdir(this.subjectsDir);
        end
        function g    = get.sessionFolder(this)
            g = this.sessionFolder_;
        end
        function this = set.sessionFolder(this, s)
            this.sessionFolder_ = s;            
            this.assertIsdir(this.sessionPath);
        end
        function g    = get.sessionPath(this)
            g = fullfile(this.subjectsDir, this.sessionFolder_);
        end
        function this = set.sessionPath(this, s)
            this.assertIsdir(s);
            [this.subjectsDir,this.sessionFolder] = fileparts(s);
        end
        function g    = get.studyData(this)
            g = this.studyData_;
        end
        function this = set.studyData(this, s)
            assert(isa(s, 'mlpipeline.StudyData'));
            this.studyData_ = s;
        end
        
        function g    = get.absScatterCorrected(this)
            g = this.absScatterCorrected_;
        end
        function this = set.absScatterCorrected(this, s)
            assert(islogical(s));
            this.absScatterCorrected_ = s;
        end
        function g    = get.attenuationCorrected(this)
            g = this.attenuationCorrected_;
        end
        function this = set.attenuationCorrected(this, s)
            assert(islogical(s));
            this.attenuationCorrected_ = s;
        end
        function g    = get.builder(this)
            g = this.builder_;
        end
        function this = set.builder(this, s)
            assert(isa(s, 'mlpipeline.IDataBuilder'));
            this.builder_ = s;
        end
        function g    = get.isotope(this)
            tr = lower(this.tracer);
            
            % N.B. order of testing by lstrfind
            if (lstrfind(tr, {'ho' 'oo' 'oc' 'co'}))
                g = '15O';
                return
            end
            if (lstrfind(tr, 'fdg'))
                g = '18F';
                return
            end 
            if (lstrfind(tr, 'g'))
                g = '11C';
                return
            end            
            error('mlpipeline:indeterminatePropertyValue', ...
                'SessionData.isotope could not recognize tracer %s', this.sessionData.tracer);
        end
        function g    = get.pnumber(this)
            if (~isempty(this.pnumber_))
                g = this.pnumber_;
                return
            end
            warning('off', 'mfiles:regexpNotFound');
            g = str2pnum(this.sessionLocation('typ', 'folder'));
            warning('on', 'mfiles:regexpNotFound');
        end
        function this = set.pnumber(this, s)
            assert(ischar(s));
            this.pnumber_ = s;
        end
        function g    = get.rnumber(this)
            g = this.rnumber_;
        end
        function this = set.rnumber(this, r)
            assert(isnumeric(r));
            this.rnumber_ = r;
        end
        function g    = get.region(this)
            g = this.region_;
        end
        function this = set.region(this, s)
            assert(isa(s, 'mlfourd.ImagingContext'));
            this.region_ = s;
        end
        function g    = get.snumber(this)
            g = this.snumber_;
        end
        function this = set.snumber(this, s)
            assert(isnumeric(s));
            this.snumber_ = s;
        end
        function g    = get.tracer(this)
            g = this.tracer_;
        end
        function this = set.tracer(this, t)
            assert(ischar(t));
            this.tracer_ = t;
        end
        function g    = get.vnumber(this)
            g = this.vnumber_;
        end
        function this = set.vnumber(this, v)
            assert(isnumeric(v));
            this.vnumber_ = v;
        end
        
        %% IMRData
                
        function obj = adc(~, obj)
        end
        function obj = aparcA2009sAseg(this, varargin)
            obj = this.freesurferObject('aparc.a2009s+aseg', varargin{:});
        end
        function obj = aparcAseg(this, varargin)
            obj = this.freesurferObject('aparc+aseg', varargin{:});
        end
        function obj = asl(this, varargin)
            obj = this.mrObject('pcasl', varargin{:});
        end
        function obj = atlas(this, varargin)
            ip = inputParser;
            addParameter(ip, 'desc', 'TRIO_Y_NDC', @ischar);
            addParameter(ip, 'suffix', '', @ischar);
            addParameter(ip, 'typ', 'mlmr.MRImagingContext', @ischar);
            parse(ip, varargin{:});
            
            obj = imagingType(ip.Results.typ, ...
                fullfile(getenv('REFDIR'), ...
                         sprintf('%s%s%s', ip.Results.desc, ip.Results.suffix, this.filetypeExt)));
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
        function obj = brainmask(this, varargin)
            obj = this.freesurferObject('brainmask', varargin{:});
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
            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'suffix', '', @ischar);
            parse(ip, varargin{:});
            
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
            obj = this.mrObject('t2', varargin{:});
        end
        function obj = tof(~, obj)
        end
        function obj = wmparc(this, varargin)
            obj = this.freesurferObject('wmparc', varargin{:});
        end
                        
        %% IPETData
        
        function obj = cbf(this, varargin)
            this.tracer = 'HO';
            obj = this.petObject('cbf', varargin{:});
        end
        function obj = cbv(this, varargin)
            this.tracer = 'OC';
            obj = this.petObject('cbv', varargin{:});
        end
        function obj = cmro2(this, varargin)
            this.tracer = 'OO';
            obj = this.petObject('cmro2', varargin{:});
        end
        function obj = ct(~, obj)
        end
        function obj = fdg(this, varargin)
            this.tracer = 'FDG';
            obj = this.petObject('fdg', varargin{:});
        end
        function obj = gluc(this, varargin)
            obj = this.petObject('gluc', varargin{:});
        end 
        function obj = ho(this, varargin)
            this.tracer = 'HO';
            obj = this.petObject('ho', varargin{:});
        end
        function obj = oc(this, varargin)
            this.tracer = 'OC';
            obj = this.petObject('oc', varargin{:});
        end
        function obj = oef(this, varargin)
            this.tracer = 'OO';
            obj = this.petObject('oef', varargin{:});
        end
        function obj = oo(this, varargin)
            this.tracer = 'OO';
            obj = this.petObject('oo', varargin{:});
        end
        function obj = tr(this, varargin)
            obj = this.petObject('tr', varargin{:});
        end
        function obj = umap(~, obj)
        end       
    
        %%  
        
        function obj  = ctObject(this, varargin)
            ip = inputParser;
            ip.KeepUnmatched = true;
            addRequired( ip, 'desc', @ischar);
            addParameter(ip, 'suffix', '', @ischar);
            addParameter(ip, 'typ', 'fqfp', @ischar);
            parse(ip, varargin{:});
            
            fqfn = fullfile(this.sessionLocation, ...
                            sprintf('%s%s%s', ip.Results.desc, ip.Results.suffix, this.filetypeExt));
            this.ensureCTFqfilename(fqfn);
            obj = imagingType(ip.Results.typ, fqfn);
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
        function loc  = fourdfpLocation(this, varargin)
            loc = this.vLocation(varargin{:});
        end
        function obj  = fqfilenameObject(~, varargin)
            %  @param named typ has default 'mlfourd.ImagingContext'
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addRequired( ip, 'fqfn', @(x) lexist(x, 'file'));
            addParameter(ip, 'suffix', '', @ischar);
            addParameter(ip, 'typ', 'mlfourd.ImagingContext', @ischar);
            parse(ip, varargin{:});
            
            obj = imagingType(ip.Results.typ, ip.Results.fqfn);
        end
        function obj  = fqfileprefixObject(~, varargin)
            ip = inputParser;
            ip.KeepUnmatched = true;
            addRequired( ip, 'fqfp', @ischar);
            addParameter(ip, 'suffix', '', @ischar);
            addParameter(ip, 'typ', 'fqfp', @ischar);
            parse(ip, varargin{:});
            
            obj = imagingType(ip.Results.typ, ip.Results.fqfp);
        end
        function loc  = freesurferLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, ...
                fullfile(this.freesurfersDir, this.sessionLocation('typ', 'folder'), ''));
        end
        function obj  = freesurferObject(this, varargin)
            ip = inputParser;
            addRequired( ip, 'desc', @ischar);
            addParameter(ip, 'suffix', '', @ischar);
            addParameter(ip, 'typ', 'mlmr.MRImagingContext', @ischar);
            parse(ip, varargin{:});
            
            obj = imagingType(ip.Results.typ, ...
                fullfile(this.mriLocation, ...
                         sprintf('%s%s.mgz', ip.Results.desc, ip.Results.suffix)));
        end
        function loc  = fslLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, ...
                fullfile(this.vLocation, 'fsl', ''));
        end
        function loc  = hdrinfoLocation(this, varargin)
            loc = this.vLocation(varargin{:});
        end   
        function [ipr,schar,this] = iprLocation(this, varargin)
            %% IPRLOCATION
            %  @param named tracer is a string identifier.
            %  @param named snumber is the scan number; is numeric.
            %  @param named typ is string identifier:  folder path, fn, fqfn, ...  
            %  See also:  imagingType.
            %  @param named frame is numeric.
            %  @param named rnumber is the revision number; is numeric.
            %  @returns ipr, the struct ip.Results obtained by parse.            
            %  @returns schr, the s-number as a string.
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'ac', this.attenuationCorrected, @islogical);
            addParameter(ip, 'tracer', this.tracer, @ischar);
            addParameter(ip, 'frame', nan, @isnumeric);
            addParameter(ip, 'rnumber', this.rnumber, @isnumeric);
            addParameter(ip, 'snumber', this.snumber, @isnumeric);
            addParameter(ip, 'vnumber', this.vnumber, @isnumeric);
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});            
            ipr = ip.Results;
            this.attenuationCorrected = ip.Results.ac;
            this.tracer  = ip.Results.tracer; 
            this.rnumber = ip.Results.rnumber;
            this.snumber = ip.Results.snumber;
            this.vnumber = ip.Results.vnumber;            
            if (~lstrfind(upper(ipr.tracer), 'OC') && ...
                ~lstrfind(upper(ipr.tracer), 'OO') && ...
                ~lstrfind(upper(ipr.tracer), 'HO'))
                ipr.snumber = nan;
            end
            if (isnan(ipr.snumber))
                schar = '';
            else
                schar = num2str(ip.Results.snumber);
            end
        end     
        function tf   = isequal(this, obj)
            tf = this.isequaln(obj);
        end
        function tf   = isequaln(this, obj)
            if (isempty(obj)); tf = false; return; end
            tf = this.classesequal(obj);
            if (tf)
                tf = this.fieldsequaln(obj);
            end
        end 
        function loc  = mriLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, ...
                fullfile(this.freesurferLocation, 'mri', ''));
        end
        function obj  = mrObject(this, varargin)
            ip = inputParser;
            ip.KeepUnmatched = true;
            addRequired( ip, 'desc', @ischar);
            addParameter(ip, 'suffix', '', @ischar);
            addParameter(ip, 'typ', 'mlmr.MRImagingContext', @ischar);
            parse(ip, varargin{:});
            
            obj = imagingType(ip.Results.typ, ...
                fullfile(this.fslLocation, ...
                         sprintf('%s%s%s', ip.Results.desc, ip.Results.suffix, this.filetypeExt)));
        end 
        function loc  = petLocation(this, varargin)
            loc = this.vLocation(varargin{:});
        end
        function obj  = petObject(this, varargin)
            ip = inputParser;
            addRequired( ip, 'tracer', @ischar);
            addParameter(ip, 'suffix', '', @ischar);
            addParameter(ip, 'typ', 'mlpet.PETImagingContext', @ischar);
            parse(ip, varargin{:});
            suff = ip.Results.suffix;
            if (~isempty(suff) && ~strcmp(suff(1),'_'))
                suff = ['_' suff];
            end
            
            if (lstrfind(lower(ip.Results.tracer), 'fdg'))
                fqfn = fullfile(this.petLocation, ...
                       sprintf('%sv%ir%i%s%s', ip.Results.tracer, this.vnumber, this.rnumber, suff, this.filetypeExt));
            else
                fqfn = fullfile(this.petLocation, ...
                       sprintf('%s%iv%ir%i%s%s', ip.Results.tracer, this.snumber, this.vnumber, this.rnumber, suff, this.filetypeExt));
            end
            obj = imagingType(ip.Results.typ, fqfn);
        end   
        function loc  = regionLocation(this, varargin)
            loc = this.vLocation(varargin{:});
        end   
        function a    = seriesDicomAsterisk(this, varargin)
            a = this.studyData.seriesDicomAsterisk(varargin{:});
        end
        function loc  = sessionLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, this.sessionPath);
        end
        function loc  = vLocation(this, varargin)
            loc = this.sessionLocation(varargin{:});
        end 
        
 		function this = SessionData(varargin)
 			%% SESSIONDATA
 			%  @param [param-name, param-value[, ...]]
            %         'abs'          is logical
            %         'ac'           is logical
            %         'intervention' is char
            %         'pnumber'      is char
            %         'rnumber'      is numeric
            %         'sessionPath'  is a path to the session data
            %         'snumber'      is numeric
            %         'studyData'    is a mlpipeline.StudyData
            %         'subjectsDir'  is dir
            %         'tracer'       is char
            %         'vnumber'      is numeric

            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'abs', false,       @islogical);
            addParameter(ip, 'ac', false,        @islogical);
            addParameter(ip, 'intervention',     @(x) ischar(x) || isnumeric(x));
            addParameter(ip, 'pnumber', '',      @ischar);
            addParameter(ip, 'rnumber', 1,       @isnumeric);
            addParameter(ip, 'sessionPath', pwd, @ischar);
            addParameter(ip, 'snumber', 1,       @isnumeric);
            addParameter(ip, 'studyData',        @(x) isa(x, 'mlpipeline.StudyDataHandle'));
            addParameter(ip, 'subjectsDir', '',  @(x) isdir(x) || isempty(x));
            addParameter(ip, 'tracer', 'FDG',    @ischar);
            addParameter(ip, 'vnumber', 1,       @isnumeric);
            parse(ip, varargin{:});
            
            this.studyData_ = ip.Results.studyData;
            if (~isempty(ip.Results.subjectsDir))
                this.studyData_.subjectsDir = ip.Results.subjectsDir;
            end
            
            this.absScatterCorrected_  = ip.Results.abs;
            this.attenuationCorrected_ = ip.Results.ac;
            this.intervention_         = ip.Results.intervention;
            this.pnumber_              = ip.Results.pnumber;
            this.rnumber_              = ip.Results.rnumber;
            [this.studyData_.subjectsDir,this.sessionFolder] = fileparts(ip.Results.sessionPath);
            this.snumber_              = ip.Results.snumber;
            this.tracer_               = ip.Results.tracer;
            this.vnumber_              = ip.Results.vnumber;
        end
    end

    %% PROTECTED
    
    properties (Access = protected)
        absScatterCorrected_
        attenuationCorrected_
        builder_
        intervention_
        pnumber_
        rnumber_
        region_
        sessionFolder_
        studyData_
        snumber_
        tracer_
        vnumber_
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
    
    methods (Access = protected)    
        function ensureCTFqfilename(~, fqfn) %#ok<INUSD>
            %assert(lexist(fqfn, 'file'));
        end
    end
    
    %% PRIVATE
    
    methods (Static, Access = private)
        function [tf,msg] = checkFields(obj1, obj2)
            tf = true; 
            msg = '';
            flds = fieldnames(obj1);
            for f = 1:length(flds)
                try
                    if (~isequaln(obj1.(flds{f}), obj2.(flds{f})))
                        tf = false;
                        msg = sprintf('SessionData.checkFields:  mismatch at field %s.', flds{f});
                        return
                    end
                catch ME %#ok<NASGU>
                    sprintf('SessionData.checkFields:  ignoring %s', flds{f});
                end
            end
        end 
    end
    
    methods (Access = private)
        function assertIsdir(this, d)
            if (this.allowDirNotYetExisting)
                return
            end
            assert(isdir(d));
        end
        function [tf,msg] = classesequal(this, c)
            tf  = true; 
            msg = '';
            if (~isa(c, class(this)))
                tf  = false;
                msg = sprintf('class(this)-> %s but class(compared)->%s', class(this), class(c));
            end
            if (~tf)
                warning('mlpipeline:isequal:mismatchedClass', msg);
            end
        end        
        function [tf,msg] = fieldsequaln(this, obj)
            [tf,msg] = mlpipeline.SessionData.checkFields(this, obj);
        end
    end
    
    %% HIDDEN
    %  @deprecated
    
    properties (Hidden)
        parcellation
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

