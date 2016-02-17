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
        snumber
        vnumber
 		mriPath
        petPath
        hdrinfoPath
        fslPath
    end
    
    methods %% GET 
        function g = get.subjectsDir(this)
            g = fileparts(this.sessionPath_); % by definition
        end
        function g = get.sessionPath(this)
            g = this.sessionPath_;
        end
        function g = get.sessionFolder(this)
            [~,f] = myfileparts(this.sessionPath_);
            g = f;
        end
        function g = get.pnumber(this)
            warning('off', 'mfiles:regexpNotFound');
            g = str2pnum(this.sessionFolder);
            warning('on', 'mfiles:regexpNotFound');
        end
        function g = get.snumber(this)
            g = this.snumber_;
        end
        function this = set.snumber(this, s)
            this.snumber_ = s;
        end
        function g = get.vnumber(this)
            g = this.vnumber_;
        end
        function this = set.vnumber(this, s)
            this.vnumber_ = s;
        end
        function g = get.mriPath(this)
            g = fullfile(this.sessionPath_, this.studyData_.mriFolder(this), '');
        end
        function g = get.petPath(this)
            g = fullfile(this.sessionPath_, this.studyData_.petFolder(this), '');
        end
        function g = get.hdrinfoPath(this)
            g = fullfile(this.sessionPath_, this.studyData_.hdrinfoFolder(this), '');
        end
        function g = get.fslPath(this)
            g = fullfile(this.sessionPath_, this.studyData_.fslFolder(this), '');
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
            addParameter(ip, 'snumber', 1, @isnumeric);
            addParameter(ip, 'vnumber', 1, @isnumeric);
            addParameter(ip, 'suffix', '', @ischar);
            parse(ip, varargin{:});
            
            this.studyData_   = ip.Results.studyData;
            this.sessionPath_ = ip.Results.sessionPath;
            this.snumber_     = ip.Results.snumber;
            this.vnumber_     = ip.Results.vnumber;
            this.suffix       = ip.Results.suffix;
        end
%         function        disp(this)
%             fprintf('  %s with properties:\n\n', class(this));
%             fprintf('                  suffix: ''%s''\n', this.suffix);
%             fprintf('             subjectsDir: ''%s''\n', this.subjectsDir);
%             fprintf('             sessionPath: ''%s''\n', this.sessionPath);
%             fprintf('           sessionFolder: ''%s''\n', this.sessionFolder);
%             fprintf('                 pnumber: ''%s''\n', this.pnumber);
%             fprintf('                 snumber: ''%s''\n', this.snumber);
%             fprintf('                 vnumber: ''%s''\n', this.vnumber);
%             fprintf('                 mriPath: ''%s''\n', this.mriPath);
%             fprintf('                 petPath: ''%s''\n', this.petPath);
%             fprintf('             hdrinfoPath: ''%s''\n', this.hdrinfoPath);
%             fprintf('                 fslPath: ''%s''\n', this.fslPath);
%         end
        function        ensureNIFTI_GZ(this, fn)
            [p,f] = myfileparts(fn);
            analyzefn = fullfile(p, [f '.hdr']);
            niftifn   = fullfile(p, [f '.nii.gz']);
            if (lexist(analyzefn) && ~lexist(niftifn))
                this.fslchfiletype(analyzefn);
            end
        end
    end 

    %% PROTECTED
    
    properties (Access = protected)
        studyData_
        sessionPath_
        snumber_ = 1
        vnumber_ = 1
    end
    
    methods (Static, Access = protected)
        function ic   = cropImaging(ic, varargin)
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
        function ic  = flip(ic, dim)
            niid = ic.niftid;
            niid.img = flip(niid.img, dim);
            niid = niid.append_fileprefix(sprintf('_flip%i', dim));
            ic = mlpipeline.SessionData.repackageImagingContext(niid, class(ic));
        end
        function ic   = flipAndCropImaging(ic, varargin)
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
            niid.fileprefix = niid.fileprefix(1:strfind(niid.fileprefix, '.4dfp')-1);
            niid = niid.append_fileprefix(sprintf('_flip%i_crop', ip.Results.flipdim));
            ic = mlpipeline.SessionData.repackageImagingContext(niid, class(ic));
        end
        function fn   = fslchfiletype(fn, varargin)
            ip = inputParser;
            addRequired(ip, 'fn', @(x) lexist(x, 'file'));
            addOptional(ip, 'type', 'NIFTI_GZ', @ischar);
            parse(ip, fn, varargin{:});
            
            fprintf('mlpipeline.SessionData.fslchfiletype is working on %s\n', ip.Results.fn);
            mlpipeline.PipelineVisitor.cmd('fslchfiletype', 'NIFTI_GZ', ip.Results.fn);
            [p,f] = myfileparts(fn);
            fn = fullfile(p, [f mlfourd.INIfTI.FILETYPE_EXT]);
        end
        function ic  = repackageImagingContext(obj, oriClass)
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
    
    methods (Access = protected)
        function f = fullfile(this, varargin)
            ip = inputParser;
            addRequired(ip, 'path', @isdir);
            addOptional(ip, 'basename', '', @ischar);
            parse(ip, varargin{:})
            
            f = fullfile(ip.Results.path, sprintf('%s.nii.gz',      ip.Results.basename));
            if (lexist(f, 'file')); return; end
            f = fullfile(ip.Results.path, sprintf('%s.4dfp.nii.gz', ip.Results.basename));
            if (lexist(f, 'file')); return; end
            f = fullfile(ip.Results.path, sprintf('%s.4dfp.hdr',    ip.Results.basename));
            this.ensureNIFTI_GZ(f);            
            if (lexist(f, 'file')); return; end
            f = '';
            return
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

