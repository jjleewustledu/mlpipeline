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
        rawdataPath
        rawdataFolder % \in sessionFolder
        
        studyData
        
        projectsDir % homolog of __Freesurfer__ subjectsDir
        projectsPath
        projectsFolder
        projectData
        projectPath
        projectFolder % \in projectsFolder        
        
        subjectsDir % __Freesurfer__ convention
        subjectsPath 
        subjectsFolder 
        subjectData
        subjectPath
        subjectFolder % \in subjectsFolder  
        
        sessionPath
        sessionFolder % \in projectFolder        
        
        scanPath
        scanFolder % \in sessionFolder
        
        frame
        metric
        noclobber
        parcellation
        pnumber
        region
        snumber
        taus
        times
        version
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
                
        function g    = get.rawdataPath(this)
            g = fullfile(this.sessionPath, this.rawdataFolder);
        end
        function g    = get.rawdataFolder(~)
            g = 'rawdata';
        end
        
        function g    = get.studyData(this)
            g = this.studyData_;
        end
        function this = set.studyData(this, s)
            warning('mlpipeline:RuntimeWarning', 'SessionData.set.studyData is DEPRECATED')
            assert(isa(s, 'mlpipeline.IStudyData'));
            this.studyData_ = s;
        end 
        
        function g    = get.projectsDir(this)
            if ~isempty(this.studyData_)
                g = this.studyData_.projectsDir;
                return
            end
            if ~isempty(this.projectData_)
                g = this.projectData_.projectsDir;
                return
            end
            error('mlpipeline:RuntimeError', 'SessionData.get.projectsDir')
        end
        function g    = get.projectsPath(this)
            g = this.projectsDir;
        end
        function g    = get.projectsFolder(this)
            g = this.projectsDir;
            if (strcmp(g(end), filesep))
                g = g(1:end-1);
            end
            g = mybasename(g);
        end     
        function g    = get.projectData(this)
            g = this.projectData_;
        end
        function g    = get.projectPath(this)
            g = fullfile(this.projectsPath, this.projectFolder);
        end
        function g    = get.projectFolder(this)
            g = this.projectData.projectFolder;
        end
        
        function g    = get.subjectsDir(this)
            g = this.studyData_.subjectsDir;
        end
        function this = set.subjectsDir(this, s)
            assert(ischar(s));
            this.studyData_.subjectsDir = s;
        end
        function g    = get.subjectsPath(this)
            g = this.subjectsDir;
        end
        function this = set.subjectsPath(this, s)
            this.subjectsDir = s;
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
        function g    = get.subjectData(this)
            g = this.subjectData_;
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
        
        function g    = get.scanPath(this)
            g = fullfile(this.sessionPath, this.scanFolder);
        end
        function this = set.scanPath(this, s)
            assert(ischar(s));
            [this.sessionPath,this.scanFolder] = myfileparts(s);
        end
        function g    = get.scanFolder(this)
            g = this.getScanFolder();
        end
        function this = set.scanFolder(this, s)
            this = this.setScanFolder(s);
        end
              
        function g    = get.frame(this)
            g = this.frame_;
        end
        function this = set.frame(this, s)
            assert(isnumeric(s));
            this.frame_ = s;
        end
        function g    = get.metric(this)
            g = this.metric_;
        end
        function this = set.metric(this, s)
            assert(ischar(s))
            this.metric_ = s;
        end
        function g    = get.noclobber(this)
            g = this.studyData.noclobber;
        end
        function g    = get.parcellation(this)
            g = this.region;
        end
        function this = set.parcellation(this, s)
           this.region = s; 
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
            if (lexist(this.jsonFilename, 'file'))
                j = jsondecode(fileread(this.jsonFilename));
                g = j.taus';
                return
            end
            g = this.alternativeTaus;
        end
        function g    = get.times(this)
            g = cumsum(this.taus);
        end
        function g    = get.version(this)
            g = this.version_;
        end
                
        %% IMRData
        
        function obj  = adc(this, varargin)
            obj = this.mrObject('ep2d_diff_26D_lgfov_nopat_ADC', varargin{:});
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
            addParameter(ip, 'tag', '', @ischar);
            addParameter(ip, 'typ', 'mlfourd.ImagingContext2', @ischar);
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
        function obj = dwi(this, varargin)
            obj = this.mrObject('ep2d_diff_26D_lgfov_nopat_TRACEW', varargin{:});
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
        function loc = mriLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, fullfile(this.freesurferLocation, 'mri', ''));
        end
        function obj = mrObject(this, varargin)
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
    
        %%
        
        function        alternativeTaus(~)
            error('mlpipeline:NotImplementedError', 'SessionData.alternativeTaus');
        end
        function        diaryOff(~)
            diary off;
        end
        function        diaryOn(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.sessionPath, @isfolder);
            parse(ip, varargin{:});
            loc = fullfile(ip.Results.path, diaryfilename('obj', class(this)));
            diary(loc);
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
        function g    = getScanFolder(this)
            g = this.scanFolder_;
        end
        function [ipr,this] = iprLocation(this, varargin)
            %% IPRLOCATION
            %  @param named frame is a frame identifier; is numeric.
            %  @param named rnumber is the revision number; is numeric.
            %  @param named snumber is the scan number; is numeric.
            %  @param named typ is string identifier:  folder path, fn, fqfn, ...  
            %  See also:  imagingType.
            %  @returns ipr, the struct ip.Results obtained by parse.            
            %  @returns schr, the s-number as a string.
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'frame',   this.frame, @isnumeric);
            addParameter(ip, 'rnumber', this.rnumber, @isnumeric);
            addParameter(ip, 'snumber', this.snumber, @isnumeric);
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});            
            ipr = ip.Results;
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
        function f    = jsonFilename(~) %#ok<STOUT>
            error('mlpipeline:NotImplementedError', 'SessionData.jsonFilename')
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
        function loc  = projectLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, this.projectPath);
        end
        function loc  = regionLocation(this, varargin)
            loc = this.sessionLocation(varargin{:});
        end   
        function loc  = sessionLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, this.sessionPath);
        end
        function this = setScanFolder(this, s)
            assert(ischar(s));
            this.scanFolder_ = s;
        end
        function loc  = subjectLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, this.subjectPath);
        end          
        function loc  = vallLocation(this, varargin)
            loc = this.subjectLocation(varargin{:});
        end 
        
 		function this = SessionData(varargin)
 			%% SESSIONDATA
 			%  @param [param-name, param-value[, ...]]
            %
            %         'studyData'    is a mlpipeline.IStudyData, simpler than projectData
            %
            %         'projectsDir'  <-> env PROJECTS_DIR
            %         'projectData'  is a mlpipeline.IProjectData
            %         'projectPath'
            %         'projectFolder'
            %
            %         'subjectsDir'  <-> env SUBJECTS_DIR
            %         'subjectData'  is a mlpipeline.ISubjectData
            %         'subjectPath'
            %         'subjectFolder'
            %
            %         'sessionPath'
            %         'sessionFolder'
            %
            %         'scanPath'
            %         'scanFolder'
            %
            %         'frame'        is numeric
            %         'pnumber'      is char
            %         'snumber'      is numeric
            %         'tauIndices'
            %         'tauMultiplier'

            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'frame', nan,        @isnumeric);
            addParameter(ip, 'metric', '',        @ischar);
            addParameter(ip, 'parcellation', '',  @ischar);
            addParameter(ip, 'projectData', []);
            addParameter(ip, 'projectFolder', '', @ischar);
            addParameter(ip, 'projectPath', '',   @ischar);
            addParameter(ip, 'projectsDir', '',   @(x) isfolder(x) || isempty(x));
            addParameter(ip, 'pnumber', '',       @ischar);
            addParameter(ip, 'region', '',        @ischar);
            addParameter(ip, 'scanFolder', '',    @ischar);
            addParameter(ip, 'scanPath', '',      @ischar);
            addParameter(ip, 'sessionFolder', '', @ischar);
            addParameter(ip, 'sessionPath', '',   @ischar);
            addParameter(ip, 'snumber', nan,      @isnumeric);
            addParameter(ip, 'studyData', []); 
            addParameter(ip, 'subjectData', []);
            addParameter(ip, 'subjectFolder', '', @ischar);
            addParameter(ip, 'subjectPath', '',   @ischar);
            addParameter(ip, 'subjectsDir', '',   @(x) isfolder(x) || isempty(x));
            addParameter(ip, 'tauIndices', [], @isnumeric);
            addParameter(ip, 'tauMultiplier', 1, @(x) isnumeric(x) && x >= 1);
            addParameter(ip, 'version', '20200102', @ischar);
            parse(ip, varargin{:}); 
            ipr = ip.Results;
            
            this.frame_ = ipr.frame;            
            this.pnumber_ = ipr.pnumber;  
            if ~isempty(ipr.projectsDir)
                setenv('PROJECTS_DIR', ipr.projectsDir)
            end          
            this.snumber_ = ipr.snumber;   
            if ~isempty(ipr.subjectsDir)
                setenv('SUBJECTS_DIR', ipr.subjectsDir)
            end
            this.version_ = ipr.version;
            
            %% mlpipeline.StudyData, containing some kind of registry; legacy support
            this.studyData_ = ipr.studyData;
            
            %% mlpipeline.ProjectData
            this.projectData_ = ipr.projectData;
            if (~isempty(this.projectData_))  
                if (~isempty(ipr.projectFolder))
                    this.projectData_.projectFolder = ipr.projectFolder;
                end
                if (~isempty(ipr.projectPath))
                    this.projectData_.projectPath = ipr.projectPath;
                end
            end
            
            %% mlpipeline.SubjectData
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
            
            %% taus 
            
            this.tauIndices_ = ipr.tauIndices;
            this.tauMultiplier_ = ipr.tauMultiplier;
            
            %%
            
            this.metric_ = ipr.metric;
            this.region_ = ipr.parcellation;
            this.region_ = ipr.region;
        end
    end

    %% PROTECTED
    
    properties (Access = protected)
        builder_
        frame_
        metric_
        pnumber_
        projectData_
        projectFolder_
        region_
        scanFolder_
        sessionFolder_
        studyData_
        subjectData_
        snumber_
        tauIndices_
        tauMultiplier_
        taus_
        version_
    end
    
    methods (Static, Access = protected)
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
        function f  = fullfile(~, varargin)
            assert(~isempty(varargin));
            if (1 == length(varargin))
                f = varargin{1};
                return
            end
            path = fullfile(varargin{1:end-1});
            assert(isfolder(path));
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
        function fqfn = ensureOrientation(this, fqfn, orient)
            assert(lstrcmp({'sagittal' 'transverse' 'coronal' ''}, orient)); 
            [pth,fp,ext] = myfileparts(fqfn);
            fqfp = fullfile(pth, fp);   
            orient0 = this.readOrientation(fqfp);
            fv = mlfourdfp.FourdfpVisitor;             

            if (isempty(orient))
                return
            end     
            if (strcmp(orient0, orient))
                return
            end       
            if (lexist([this.orientedFileprefix(fqfp, orient) ext]))
                fqfn = [this.orientedFileprefix(fqfp, orient) ext];
                return
            end

            pwd0 = pushd(pth);
            switch (orient0)
                case 'sagittal'
                    switch (orient)
                        case 'transverse'
                            fv.S2T_4dfp(fp, [fp 'T']);
                            fqfn = [fqfp 'T' ext];
                        case 'coronal'
                            fv.S2C_4dfp(fp, [fp 'C']);
                            fqfn = [fqfp 'C' ext];
                    end
                case 'transverse'
                    switch (orient)
                        case 'sagittal'
                            fv.T2S_4dfp(fp, [fp 'S']);
                            fqfn = [fqfp 'S' ext];
                        case 'coronal'
                            fv.T2C_4dfp(fp, [fp 'C']);
                            fqfn = [fqfp 'C' ext];
                    end
                case 'coronal'
                    switch (orient)
                        case 'sagittal'
                            fv.C2S_4dfp(fp, [fp 'S']);
                            fqfn = [fqfp 'S' ext];
                        case 'transverse'
                            fv.C2T_4dfp(fp, [fp 'T']);
                            fqfn = [fqfp 'T' ext];
                    end
            end
            popd(pwd0);
        end    
        function [tf,msg] = fieldsequaln(this, obj)
            [tf,msg] = mlpipeline.SessionData.checkFields(this, obj);
        end
        function fqfp = orientedFileprefix(~, fqfp, orient)
            assert(mlfourdfp.FourdfpVisitor.lexist_4dfp(fqfp));
            switch (orient)
                case 'sagittal'
                    fqfp = [fqfp 'S'];
                case 'transverse'
                    fqfp = [fqfp 'T'];
                case 'coronal'
                    fqfp = [fqfp 'C'];
                otherwise
                    error('mlnipet:switchCaseNotSupported', ...
                          'SesssionData.orientedFileprefix.orient -> %s', orient);
            end
        end
        function o    = readOrientation(this, varargin)
            ip = inputParser;
            addRequired(ip, 'fqfp', @mlfourdfp.FourdfpVisitor.lexist_4dfp);
            parse(ip, varargin{:});

            [~,o] = mlbash(sprintf('awk ''/orientation/{print $NF}'' %s%s', ip.Results.fqfp, this.filetypeExt));
            switch (strtrim(o))
                case '2'
                    o = 'transverse';
                case '3'
                    o = 'coronal';
                case '4'
                    o = 'sagittal';
                otherwise
                    error('mlnipet:switchCaseNotSupported', ...
                          'SessionData.readOrientation.o -> %s', o);
            end
        end
        function tf   = useDeprecatedVersion(this)
            try
                if datetime(this.version, 'InputFormat', 'yyyyMMdd') < ...
                   datetime('20200101', 'InputFormat', 'yyyyMMdd')
                    tf = true;
                else
                    tf = false;
                end
            catch %#ok<CTCH>
                warning('mlpipeline:RuntimeWarning', 'useDeprecatedVersion.version -> %s', this.version)
                tf = false;
            end
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

