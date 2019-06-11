classdef (Abstract) SessionData < mlpipeline.ISessionData 
	%% SESSIONDATA  
    %  @param builder is an mlpipeline.IBuilder.

	%  $Revision$
 	%  was created 21-Jan-2016 22:20:41
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.  Copyright 2017 John Joowon Lee.
    
	properties (Dependent) 
        project
        subject
        session
        scan
        resources
        assessors
        
        rawdataPath
        rawdataFolder % \in sessionFolder
        
        scanPath
        scanFolder % \in sessionFolder
        
        sessionPath
        sessionFolder % \in projectFolder
        
        projectPath
        projectFolder % \in projectsFolder
        
        projectsPath
        projectsDir % homolog of __Freesurfer__ subjectsDir
        projectsFolder
        
        subjectPath
        subjectFolder % \in subjectsFolder
        
        subjectsPath 
        subjectsDir % __Freesurfer__ convention
        subjectsFolder   
        
        absScatterCorrected
        attenuationCorrected
        frame
        isotope
        noclobber
        pnumber
        region
        snumber
        taus
        times
        tracer
        
        studyData
        projectData
        subjectData
    end

    methods (Static)        
        function fn    = fslchfiletype(varargin)
            fn = mlfourdfp.AbstractBuilder.fslchfiletype(varargin{:});
        end
        function fn    = mri_convert(varargin)   
            fn = mlfourdfp.AbstractBuilder.mri_convert(varargin{:});
        end
        function [s,r] = nifti_4dfp_4(varargin)
            [s,r] = mlfourdfp.AbstractBuilder.nifti_4dfp_4(varargin{:});
        end
        function [s,r] = nifti_4dfp_n(varargin)
            [s,r] = mlfourdfp.AbstractBuilder.nifti_4dfp_n(varargin{:});
        end
    end
    
    methods 
        
        %% GET/SET
        
        function g    = get.project(this)
             g = this.projectFolder;
        end
        function g    = get.subject(this)
             g = this.subjectFolder;
        end
        function g    = get.session(this)
             g = this.sessionFolder;
        end
        function g    = get.scan(this)
            g = this.tracerRevision('typ', 'fp');
        end  
        function g    = get.resources(~)
             g = [];
        end
        function g    = get.assessors(~)
             g = [];
        end
                
        function g    = get.rawdataPath(this)
            g = fullfile(this.sessionPath, this.rawdataFolder);
        end
        function g    = get.rawdataFolder(~)
            g = 'rawdata';
        end
        
        function g    = get.scanPath(this)
            g = fullfile(this.sessionPath, this.scanFolder);
        end
        function this = set.scanPath(this, s)
            assert(ischar(s));
            [this.sessionPath,this.scanFolder] = myfileparts(s);
        end
        function g    = get.scanFolder(this)
            if (~isempty(this.scanFolder_))
                g = this.scanFolder_;
                return
            end
            assert(~isempty(this.tracer_),               'mlpipeline:AssertionError', 'SessionData.get.scanFolder');
            assert(~isempty(this.attenuationCorrected_), 'mlpipeline:AssertionError', 'SessionData.get.scanFolder')
            dtt = mlpet.DirToolTracer( ...
                'tracer', fullfile(this.sessionPath, this.tracer_), ...
                'ac', this.attenuationCorrected_);            
            assert(~isempty(dtt.dns));
            g = dtt.dns{1};
        end
        function this = set.scanFolder(this, s)
            assert(ischar(s));
            this.scanFolder_ = s;
            this = this.adjustAttenuationCorrectedFromScanFolder;
        end
        
        function g    = get.sessionPath(this)
            g = fullfile(this.projectPath, this.sessionFolder);
        end
        function this = set.sessionPath(this, s)
            assert(ischar(s));
            [this.projectPath,this.sessionFolder] = fileparts(s);
        end
        function g    = get.sessionFolder(this)
            g = this.sessionFolder_;
        end        
        function this = set.sessionFolder(this, s)
            assert(ischar(s));
            this.sessionFolder_ = s;            
        end
        
        function g    = get.projectPath(this)
            g = fullfile(this.projectsPath, this.projectFolder);
        end
        function g    = get.projectFolder(this)
            g = this.subjectData.getProjectFolder(this.sessionFolder);
        end
        
        function g    = get.projectsPath(this)
            g = this.projectsDir;
        end
        function this = set.projectsPath(this, s)
            this.projectsDir = s;
        end
        function g    = get.projectsDir(this)
            g = this.studyData_.projectsDir;
        end
        function this = set.projectsDir(this, s)
            assert(ischar(s));
            this.studyData_.projectsDir = s;
        end
        function g    = get.projectsFolder(this)
            g = this.projectsDir;
            if (strcmp(g(end), filesep))
                g = g(1:end-1);
            end
            g = mybasename(g);
        end
        function this = set.projectsFolder(this, s)
            assert(ischar(s));
            this.studyData_.projectsDir = fullfile(fileparts(this.projectsDir), s, '');
        end
        
        function g    = get.subjectPath(this)
            g = this.subjectData.subjectPath;
        end
        function this = set.subjectPath(this, s)
            assert(ischar(s));
            this.subjectData_.subjectPath = s;
        end
        function g    = get.subjectFolder(this)
            g = this.subjectData.subjectFolder;
        end        
        function this = set.subjectFolder(this, s)
            assert(ischar(s));
            this.subjectData_.subjectFolder = s;            
        end
        
        function g    = get.subjectsPath(this)
            g = this.subjectsDir;
        end
        function this = set.subjectsPath(this, s)
            this.subjectsDir = s;
        end
        function g    = get.subjectsDir(this)
            g = this.studyData_.subjectsDir;
        end
        function this = set.subjectsDir(this, s)
            assert(ischar(s));
            this.studyData_.subjectsDir = s;
        end
        function g    = get.subjectsFolder(this)
            g = this.subjectsDir;
            if (strcmp(g(end), filesep))
                g = g(1:end-1);
            end
            g = mybasename(g);
        end
        function this = set.subjectsFolder(this, s)
            assert(ischar(s));
            this.studyData_.subjectsDir = fullfile(fileparts(this.subjectsDir), s, '');            
        end
        
        function g    = get.absScatterCorrected(this)
            if (this.useNiftyPet)
                g = false;
                return
            end
            if (strcmpi(this.tracer, 'OC') || strcmp(this.tracer, 'OO'))
                g = true;
                return
            end
            g = this.absScatterCorrected_;
        end
        function this = set.absScatterCorrected(this, s)
            assert(islogical(s));
            this.absScatterCorrected_ = s;
        end
        function g    = get.attenuationCorrected(this)
            if (~isempty(this.attenuationCorrected_))
                g = this.attenuationCorrected_;
                return
            end
            g = mlpet.DirToolTracer.folder2ac(this.scanFolder);
        end
        function this = set.attenuationCorrected(this, s)
            assert(islogical(s));
            if (this.attenuationCorrected_ == s)
                return
            end
            this.scanFolder_ = this.scanFolderWithAC(s);
            this.attenuationCorrected_ = s;
        end        
        function g    = get.frame(this)
            g = this.frame_;
        end
        function this = set.frame(this, s)
            assert(isnumeric(s));
            this.frame_ = s;
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
        function g    = get.noclobber(this)
            g = this.studyData.noclobber;
        end
        function g    = get.pnumber(this)
            if (~isempty(this.pnumber_))
                g = this.pnumber_;
                return
            end
            warning('off', 'mfiles:regexpNotFound');
            g = str2pnum(this.sessionPath);
            warning('on', 'mfiles:regexpNotFound');
        end
        function this = set.pnumber(this, s)
            assert(ischar(s));
            this.pnumber_ = s;
        end
        function g    = get.region(this)
            g = this.region_;
        end
        function this = set.region(this, s)
            assert(isa(s, 'mlfourd.ImagingContext2'));
            this.region_ = s;
        end
        function g    = get.snumber(this)
            g = this.snumber_;
        end
        function this = set.snumber(this, s)
            assert(isnumeric(s));
            this.snumber_ = s;
        end
        function g    = get.taus(this)
            if (~isempty(this.taus_))
                g = this.taus_;
                return
            end
            if (lexist(this.tracerListmodeJson, 'file'))
                j = jsondecode(fileread(this.tracerListmodeJson));
                g = j.taus';
                return
            end
            g = this.alternativeTaus;
        end
        function g    = get.times(this)
            t = this.taus;
            g = zeros(size(t));
            for ig = 1:length(t)-1
                g(ig+1) = sum(t(1:ig));
            end
        end
        function g    = get.tracer(this)
            if (~isempty(this.tracer_))
                g = this.tracer_;
                return
            end   
            % ask forgiveness not permission
            try
                g = mlpet.DirToolTracer.folder2tracer(this.scanFolder);
            catch ME
                handwarning(ME);
                g = '';
            end
        end
        function this = set.tracer(this, t)
            assert(ischar(t));
            if (~strcmpi(this.tracer_, t))
                this.scanFolder_ = '';
            end
            this.tracer_ = t;
        end
        
        function g    = get.studyData(this)
            g = this.studyData_;
        end
        function this = set.studyData(this, s)
            assert(isa(s, 'mlpipeline.IStudyData'));
            this.studyData_ = s;
        end
        function g    = get.projectData(this)
            g = this.subjectData_.projectData;
        end
        function g    = get.subjectData(this)
            g = this.subjectData_;
        end
                
        %% IMRData
        
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
            addParameter(ip, 'tag', '', @ischar);
            addParameter(ip, 'typ', 'mlmr.MRImagingContext', @ischar);
            parse(ip, varargin{:});
            
            obj = imagingType(ip.Results.typ, ...
                fullfile(getenv('REFDIR'), ...
                         sprintf('%s%s%s', ip.Results.desc, ip.Results.tag, this.filetypeExt)));
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
        function obj = fieldmap(this, varargin)
            obj = this.mrObject('FieldMapping', varargin{:});
        end
        function obj = mpr(this, varargin)
            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'tag', '', @ischar);
            parse(ip, varargin{:});
            
            obj = this.mrObject('mpr', varargin{:});
        end    
        function obj = mprage(this, varargin)
            obj = this.mpr(varargin{:});
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
        function obj = T1001(this, varargin)
            obj = this.freesurferObject('T1', varargin{:});
        end
        function obj = t1(this, varargin)
            obj = this.mpr(varargin{:});
        end        
        function obj = t2(this, varargin)
            obj = this.mrObject('t2', varargin{:});
        end
        function obj = tof(this, varargin)
            obj = this.mrObject('tof', varargin{:});
        end
        function obj = wmparc(this, varargin)
            obj = this.freesurferObject('wmparc', varargin{:});
        end
        function obj = zeroZeroOne(this, varargin)
            obj = this.freesurferObject('orig/001', varargin{:});
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
        function obj = ct(this, varargin)
            obj = this.ctObject('ct', varargin{:});
        end
        function obj = ctMasked(this, varargin)
            obj = this.ctObject('ctMasked', varargin{:});
        end
        function obj = ctMask(this, varargin)
            obj = this.ctObject('ctMask', varargin{:});
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
        function [dt0_,date_] = readDatetime0(~)
            dt0_ = NaT;
            date_ = NaT;
        end
        function obj = tr(this, varargin)
            %% transmission scan
            obj = this.petObject('tr', varargin{:});
        end     
    
        %%  
        
        function obj  = ctObject(this, varargin)
            ip = inputParser;
            ip.KeepUnmatched = true;
            addRequired( ip, 'desc', @ischar);
            addParameter(ip, 'tag', '', @ischar);
            addParameter(ip, 'typ', 'fqfp', @ischar);
            parse(ip, varargin{:});
            
            fqfn = fullfile(this.sessionLocation, ...
                            sprintf('%s%s%s', ip.Results.desc, ip.Results.tag, this.filetypeExt));
            obj = imagingType(ip.Results.typ, fqfn);
        end
        function dt   = datetime(this)
            dt = mlpet.DirToolTracer.folder2datetime(this.scanFolder);
        end
        function fqfn = ensureNIFTI_GZ(this, obj)
            %% ENSURENIFTI_GZ ensures a .nii.gz file on the filesystem if at all possible.
            %  @param fn is a filename for an existing filesystem object; it may alternatively be an mlfourd.ImagingContext2.
            %  @returns changes on the filesystem so that input fn manifests as an imaging file of type NIFTI_GZ 
            %  per the notation of fsl's fslchfiletype.
            %  See also:  mlpipeline.SessionData.fslchfiletype, mlpipeline.SessionData.mri_convert.
            
            if (isa(obj, 'mlfourd.ImagingContext2'))   
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
                        this.nifti_4dfp_n(fqfp);
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
            loc = this.sessionLocation(varargin{:});
        end
        function obj  = fqfilenameObject(this, varargin)
            %  @param named typ has default 'fqfn'
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addRequired( ip, 'fqfn', @ischar);
            addParameter(ip, 'frame', nan, @isnumeric);
            addParameter(ip, 'tag', '', @ischar);
            addParameter(ip, 'typ', 'fqfn', @ischar);
            parse(ip, varargin{:});
            this.frame = ip.Results.frame;
            
            [pth,fp,ext] = myfileparts(ip.Results.fqfn);
            fqfn = fullfile(pth, [fp ip.Results.tag this.frameTag ext]);
            obj = imagingType(ip.Results.typ, fqfn);
        end
        function obj  = fqfileprefixObject(~, varargin)
            ip = inputParser;
            ip.KeepUnmatched = true;
            addRequired( ip, 'fqfp', @ischar);
            addParameter(ip, 'tag', '', @ischar);
            addParameter(ip, 'typ', 'fqfp', @ischar);
            parse(ip, varargin{:});
            
            obj = imagingType(ip.Results.typ, [ip.Results.fqfp ip.Results.tag]);
        end
        function loc  = freesurferLocation(this, varargin)
            loc = this.sessionLocation(varargin{:});
        end
        function obj  = freesurferObject(this, varargin)
            ip = inputParser;
            addRequired( ip, 'desc', @ischar);
            addParameter(ip, 'tag', '', @ischar);
            addParameter(ip, 'typ', 'mlfourd.ImagingContext2', @ischar);
            parse(ip, varargin{:});
            
            obj = imagingType(ip.Results.typ, ...
                fullfile(this.mriLocation, ...
                         sprintf('%s%s.mgz', ip.Results.desc, ip.Results.tag)));
        end
        function loc  = fslLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, fullfile(this.sessionPath, 'fsl', ''));
        end
        function loc  = hdrinfoLocation(this, varargin)
            loc = this.sessionLocation(varargin{:});
        end   
        function [ipr,this] = iprLocation(this, varargin)
            %% IPRLOCATION
            %  @param named ac is the attenuation correction; is logical
            %  @param named tracer is a string identifier.
            %  @param named frame is a frame identifier; is numeric.
            %  @param named rnumber is the revision number; is numeric.
            %  @param named snumber is the scan number; is numeric.
            %  @param named typ is string identifier:  folder path, fn, fqfn, ...  
            %  See also:  imagingType.
            %  @returns ipr, the struct ip.Results obtained by parse.            
            %  @returns schr, the s-number as a string.
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'ac',      this.attenuationCorrected, @islogical);
            addParameter(ip, 'tracer',  this.tracer, @ischar);
            addParameter(ip, 'frame',   this.frame, @isnumeric);
            addParameter(ip, 'rnumber', this.rnumber, @isnumeric);
            addParameter(ip, 'snumber', this.snumber, @isnumeric);
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});            
            ipr = ip.Results;
            this.attenuationCorrected_ = ip.Results.ac;
            this.tracer_  = ip.Results.tracer; 
            this.rnumber  = ip.Results.rnumber;
            this.snumber_ = ip.Results.snumber;
            this.frame_   = ip.Results.frame;
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
        function loc  = logLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            if (~isempty(this.scanFolder_))
                loc = locationType(ip.Results.typ, fullfile(this.scanPath, 'Log', ''));
            else
                loc = locationType(ip.Results.typ, fullfile(this.sessionPath, 'Log', ''));
            end
        end
        function obj  = logObject(this, varargin)
            obj = mlpipeline.Logger2(varargin{:});
            obj.filepath = this.logLocation;
        end  
        function loc  = mriLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, fullfile(this.freesurferLocation, 'mri', ''));
        end
        function obj  = mrObject(this, varargin)
            ip = inputParser;
            ip.KeepUnmatched = true;
            addRequired( ip, 'desc', @ischar);
            addParameter(ip, 'tag', '', @ischar);
            addParameter(ip, 'typ', 'fqfp', @ischar);
            parse(ip, varargin{:});
            
            obj = imagingType(ip.Results.typ, ...
                fullfile(this.fslLocation, ...
                         sprintf('%s%s%s', ip.Results.desc, ip.Results.tag, this.filetypeExt)));
        end 
        function loc  = onAtlasLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, fullfile(this.subjectsDir, 'OnAtlas'));
        end 
        function loc  = opAtlasLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, fullfile(this.subjectsDir, 'OpAtlas'));
        end 
        function loc  = petLocation(this, varargin)
            loc = this.tracerLocation(varargin{:});
        end
        function obj  = petObject(this, varargin)
            ip = inputParser;
            ip.KeepUnmatched = true;
            addRequired( ip, 'tracer', @ischar);
            addParameter(ip, 'tag', '', @ischar);
            addParameter(ip, 'typ', 'fqfp', @ischar);
            parse(ip, varargin{:});
            suff = ip.Results.tag;
            if (~isempty(suff) && ~strcmp(suff(1),'_'))
                suff = ['_' suff];
            end
            fqfn = fullfile(this.petLocation, ...
                   sprintf('%sr%i%s%s', ip.Results.tracer, this.rnumber, suff, this.filetypeExt));
            obj = imagingType(ip.Results.typ, fqfn);
        end    
        function loc  = projectLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, this.projectPath);
        end
        function loc  = regionLocation(this, varargin)
            loc = this.sessionLocation(varargin{:});
        end   
        function f    = scanFolderWithAC(this, varargin)
            ip = inputParser;
            addOptional(ip, 'b', true, @islogical);            
            parse(ip, varargin{:});
            if (ip.Results.b)
                if (this.attenuationCorrected_)
                    f = this.scanFolder;
                    return
                end
                fsplit = strsplit(this.scanFolder, '-NAC');
                f = [fsplit{1} '-AC'];
            else
                if (~this.attenuationCorrected_)
                    f = this.scanFolder;
                    return
                end
                fsplit = strsplit(this.scanFolder, '-AC');
                f = [fsplit{1} '-NAC'];
            end
        end
        function f    = scanPathWithAC(this, varargin)
            f = fullfile(this.sessionPath, this.scanFolderWithAC(varargin{:}));
        end
        function loc  = sessionLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, this.sessionPath);
        end
        function loc  = subjectLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, this.subjectPath);
        end  
        function obj  = tracerListmodeBf(this, varargin)
            dt   = mlsystem.DirTool(fullfile(this.scanPath, 'LM', '*.bf'));
            assert(1 == length(dt.fqfns));
            fqfn = dt.fqfns{1};            
            obj  = this.fqfilenameObject(fqfn, varargin{:});
        end
        function obj  = tracerListmodeDcm(this, varargin)
            dt   = mlsystem.DirTool(fullfile(this.scanPath, 'LM', '*.dcm'));
            assert(1 == length(dt.fqfns));
            fqfn = dt.fqfns{1};            
            obj  = this.fqfilenameObject(fqfn, varargin{:});
        end
        function f    = tracerListmodeJson(this)            
            glob_expr = fullfile(this.tracerOutputPetLocation, [upper(this.tracer) '_DT*.json']);
            try
                dt = mlsystem.DirTool(glob_expr);
                assert(1 == dt.length, [evalc('disp(dt)') '\n' evalc('disp(dt.fqfns)')]);
                f = dt.fqfns{1};
            catch ME
                warning('mlpipeline:RuntimeWarning', 'SessionData.tracerListmodeJson could not find %s', glob_expr);
                handwarning(ME);
                f = '';
            end
        end
        function loc  = tracerLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, this.scanPath);
        end
        function loc  = tracerOutputLocation(this, varargin)
            ipr = this.iprLocation(varargin{:});
            loc = locationType(ipr.typ, ...
                fullfile(this.scanPath, this.outfolder, ''));
        end
        function loc  = tracerOutputPetLocation(this, varargin)
            ipr = this.iprLocation(varargin{:});
            loc = locationType(ipr.typ, ...
                fullfile(this.scanPath, this.outfolder, 'PET', ''));
        end
        function loc  = tracerOutputSingleFrameLocation(this, varargin)
            ipr = this.iprLocation(varargin{:});
            loc = locationType(ipr.typ, ...
                fullfile(this.scanPath, this.outfolder, 'PET', 'single-frame', ''));
        end
        function loc  = vallLocation(this, varargin)
            loc = this.subjectLocation(varargin{:});
        end 
        
 		function this = SessionData(varargin)
 			%% SESSIONDATA
 			%  @param [param-name, param-value[, ...]]
            %         'abs'          is logical
            %         'ac'           is logical
            %         'frame'        is numeric
            %         'pnumber'      is char
            %         'snumber'      is numeric
            %         'tracer'       is char
            %
            %         'studyData'    is a mlpipeline.IStudyData; legacy support; prefer using subjectData
            %         'subjectsDir'  <-> env SUBJECTS_DIR
            %         'projectsDir'  <-> env PROJECTS_DIR
            %
            %         'projectPath'
            %         'projectFolder'
            %
            %         'subjectData'  is a mlpipeline.ISubjectData
            %         'subjectPath'
            %         'subjectFolder'
            %
            %         'sessionPath'
            %         'sessionFolder'
            %
            %        ('scanData'     is a mlpipeline.IScanData)
            %         'scanPath'
            %         'scanFolder'

            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'abs', false,        @islogical);
            addParameter(ip, 'ac', false,         @islogical);
            addParameter(ip, 'frame', nan,        @isnumeric);
            addParameter(ip, 'projectFolder', '', @ischar);
            addParameter(ip, 'projectPath', '',   @ischar);
            addParameter(ip, 'projectsDir', '',   @(x) isdir(x) || isempty(x));
            addParameter(ip, 'pnumber', '',       @ischar);
            addParameter(ip, 'sessionFolder', '', @ischar);
            addParameter(ip, 'sessionPath', '',   @ischar);
            addParameter(ip, 'snumber', nan,      @isnumeric);
            addParameter(ip, 'studyData', []); 
            addParameter(ip, 'subjectData', []);
            addParameter(ip, 'subjectFolder', '', @ischar);
            addParameter(ip, 'subjectPath', '',   @ischar);
            addParameter(ip, 'subjectsDir', '',   @(x) isdir(x) || isempty(x));
            addParameter(ip, 'tracer', '',        @ischar);
            addParameter(ip, 'scanFolder', '',    @ischar);
            addParameter(ip, 'scanPath', '',      @ischar);
            parse(ip, varargin{:}); 
            ipr = ip.Results;
            
            this.absScatterCorrected_ = ipr.abs;
            this.attenuationCorrected_ = ipr.ac;
            this.frame_ = ipr.frame;            
            this.pnumber_ = ipr.pnumber;  
            if ~isempty(ipr.projectsDir)
                setenv('PROJECTS_DIR', ipr.projectsDir)
            end          
            this.snumber_ = ipr.snumber;   
            if ~isempty(ipr.subjectsDir)
                setenv('SUBJECTS_DIR', ipr.subjectsDir)
            end
            this.tracer_ = ipr.tracer;
            
            %% mlpipeline.StudyData, some kind of registry; legacy support
            
            this.studyData_ = ipr.studyData;
            
            %% mlpipeline.SubjectData, implicitly mlpipeline.ProjectData
            
            this.subjectData_ = ipr.subjectData;
            if (~isempty(this.subjectData_))  
                if (~isempty(ipr.subjectFolder))
                    this.subjectData_.subjectFolder = ipr.subjectFolder;
                end
                if (~isempty(ipr.subjectPath))
                    this.subjectData_.subjectPath = ipr.subjectPath;
                end
            end
            
            %% mlpipeline.SessionData
            
            this.sessionFolder_ = ipr.sessionFolder;
            if (~isempty(ipr.sessionPath))
                [~,this.sessionFolder_] = fileparts(ipr.sessionPath);
            end 
            
            %% (proposing mlpipeline.ScanData)
            
            this.scanFolder_ = ipr.scanFolder;
            if (~isempty(ipr.scanPath))
                [~,this.scanFolder_] = fileparts(ipr.scanPath);
            end
            this = this.adjustAttenuationCorrectedFromScanFolder;            
            
            %% taus_
            
            if (~isempty(this.scanFolder_) && lexist(this.tracerListmodeJson, 'file'))
                j = jsondecode(fileread(this.tracerListmodeJson));
                this.taus_ = j.taus';
            end
        end
    end

    %% PROTECTED
    
    properties (Access = protected)
        absScatterCorrected_
        attenuationCorrected_
        frame_
        pnumber_
        projectFolder_
        region_
        scanFolder_
        sessionFolder_
        studyData_ % legacy support
        subjectData_
        snumber_
        taus_
        tracer_
    end
    
    methods (Static, Access = protected)
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
            f = fullfile(path, sprintf('%s.4dfp.hdr',    varargin{end}));
            if (lexist(f, 'file')); return; end
            f = '';
            return
        end        
    end
    
    methods (Access = protected)
        function alternativeTaus(~) 
            error('mlpipeline:NotImplementedError', 'SessionData.alternativeTaus');
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
                    dispwarning('mlpipelinen:RuntimeWarning', 'SessionData.checkFields will ignore %s', flds{f});
                end
            end
        end 
    end
    
    methods (Access = private)
        function this = adjustAttenuationCorrectedFromScanFolder(this)
            if (contains(this.scanFolder_, '-NAC'))
                this.attenuationCorrected_ = false;
            end
            if (contains(this.scanFolder_, '-AC'))
                this.attenuationCorrected_ = true;
            end
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

