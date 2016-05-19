classdef SessionData < mlpipeline.ISessionData
	%% SESSIONDATA  

	%  $Revision$
 	%  was created 21-Jan-2016 22:20:41
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	
    
    properties
        suffix = ''
    end

	properties (Dependent)
        subjectsDir
        sessionPath
        sessionFolder
        pnumber
        rnumber
        snumber
        vnumber
 		mriPath
        petPath
        hdrinfoPath
        fslPath
    end
    
    methods %% GET 
        function g    = get.subjectsDir(this)
            g = fileparts(this.sessionPath_); % by definition
        end
        function g    = get.sessionPath(this)
            g = this.sessionPath_;
        end
        function g    = get.sessionFolder(this)
            [~,f] = myfileparts(this.sessionPath_);
            g = f;
        end
        function g    = get.pnumber(this)
            warning('off', 'mfiles:regexpNotFound');
            g = str2pnum(this.sessionFolder);
            warning('on', 'mfiles:regexpNotFound');
        end
        function g    = get.rnumber(this)
            g = this.rnumber_;
        end
        function this = set.rnumber(this, r)
            this.rnumber_ = r;
        end
        function g    = get.snumber(this)
            g = this.snumber_;
        end
        function this = set.snumber(this, s)
            this.snumber_ = s;
        end
        function g    = get.vnumber(this)
            g = this.vnumber_;
        end
        function this = set.vnumber(this, s)
            this.vnumber_ = s;
        end
        function g    = get.mriPath(this)
            g = fullfile(this.sessionPath_, this.studyData_.mriFolder(this), '');
        end
        function g    = get.petPath(this)
            g = fullfile(this.sessionPath_, this.studyData_.petFolder(this), '');
        end
        function g    = get.hdrinfoPath(this)
            g = fullfile(this.sessionPath_, this.studyData_.hdrinfoFolder(this), '');
        end
        function g    = get.fslPath(this)
            g = fullfile(this.sessionPath_, this.studyData_.fslFolder(this), '');
        end
    end    
    
    methods (Static)
        function ic = cropImaging(ic, varargin)
            ip = inputParser;
            addRequired(ip, 'ic', @(x) isa(x, 'mlfourd.ImagingContext'));
            addOptional(ip, 'fractions', [0.5 0.5 1 1], @(x) isnumeric(x) && (4 == length(x)));
            parse(ip, ic, varargin{:});
            fr = ip.Results.fractions;
            
            niid = ic.niftid;
            for r = 1:niid.rank
                if (fr(r) < 1)
                    cropping{r} = ceil(0.5*fr(r)*niid.size(r)):floor((1-0.5*fr(r))*niid.size(r));
                else
                    cropping{r} = 1:niid.size(r);
                end
            end
            niid.img = niid.img(cropping{:});            
            niid = niid.append_fileprefix('_crop');
            ic = mlpipeline.SessionData.repackageImagingContext(niid, class(ic));
        end
        function ic = flip(ic, dim)
            niid = ic.niftid;
            niid.img = flip(niid.img, dim);
            niid = niid.append_fileprefix(sprintf('_flip%i', dim));
            ic = mlpipeline.SessionData.repackageImagingContext(niid, class(ic));
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
                    cropping{r} = ceil(0.5*fr(r)*niid.size(r)):floor((1-0.5*fr(r))*niid.size(r));
                else
                    cropping{r} = 1:niid.size(r);
                end
            end
            niid.img = niid.img(cropping{:});
            if (lstrfind(niid.fileprefix, '.4dfp'))
                niid.fileprefix = niid.fileprefix(1:strfind(niid.fileprefix, '.4dfp')-1);
            end
            niid = niid.append_fileprefix(sprintf('_flip%i_crop', ip.Results.flipdim));
            ic = mlpipeline.SessionData.repackageImagingContext(niid, class(ic));
            ic.save;
        end
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
        function fn = niigzFilename(fn)
            [p,f] = myfileparts(fn);
            fn = fullfile(p, [f '.nii.gz']);
        end
        function ic = repackageImagingContext(obj, oriClass)
            switch (oriClass)
                case 'mlfourd.ImagingContext'
                    ic = mlfourd.ImagingContext(obj);
                case 'mlmr.MRImagingContext'
                    ic = mlmr.MRImagingContext(obj);
                case 'mlpet.PETImagingContext'
                    ic = mlpet.PETImagingContext(obj);
                otherwise
                    error('mlfsl:unsupportedSwitchCase', ....
                          'SessionData.repackageImagingContext.oriClass->%s is not supported', oriClass);
            end
        end
    end
    
	methods
 		function this = SessionData(varargin)
 			%% SESSIONDATA
 			%  @param [param-name, param-value[, ...]]
            %         'studyData'   is a mlpipeline.StudyDataSingleton
            %         'sessionPath' is a path to the session data

            ip = inputParser;
            addParameter(ip, 'studyData', [], @(x) isa(x, 'mlpipeline.StudyDataSingleton'));
            addParameter(ip, 'sessionPath', pwd, @isdir);
            addParameter(ip, 'rnumber', 1, @isnumeric);
            addParameter(ip, 'snumber', 1, @isnumeric);
            addParameter(ip, 'vnumber', 1, @isnumeric);
            addParameter(ip, 'suffix', '', @ischar);
            parse(ip, varargin{:});
            
            this.studyData_   = ip.Results.studyData;
            this.sessionPath_ = ip.Results.sessionPath;
            this.rnumber_     = ip.Results.rnumber;
            this.snumber_     = ip.Results.snumber;
            this.vnumber_     = ip.Results.vnumber;
            this.suffix       = ip.Results.suffix;
        end
        
        function ic   = assembleImagingWeight(this, ic1, rng1, ic2, rng2)
            nn1 = ic1.numericalNiftid;
            nn2 = ic2.numericalNiftid;
            nn  = nn1*rng1 + nn2*rng2;
            ic  = this.repackageImagingContext(nn, class(ic1));
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
                    otherwise
                        fqfn = fullfile(p, [f '.nii.gz']);
                        this.mri_convert(obj, fqfn)
                        return
                end
            end            
            error('mlpipeline:unsupportedTypeclass', ...
                  'class(SessionData.ensureNIFTI_GZ.obj) -> %s', class(obj));
        end
        function f    = fullfile(this, varargin)
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
            f = fullfile(path, sprintf('%s.4dfp.hdr',    varargin{end}));
            if (lexist(f, 'file')); return; end
            f = '';
            return
        end
    end 

    %% PROTECTED
    
    properties (Access = protected)
        studyData_
        sessionPath_
        rnumber_ = 1
        snumber_ = 1
        vnumber_ = 1
    end
    
    methods (Static, Access = protected)
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

