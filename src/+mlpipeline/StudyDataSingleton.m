classdef StudyDataSingleton < mlpipeline.StudyDataSingletonHandle
	%% STUDYDATASINGLETON  

	%  $Revision$
 	%  was created 21-Jan-2016 15:29:29
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	
    
    properties
        comments
    end

    methods (Static)
        function d   = freesurfersDir
            d = this.subjectsDir;
        end
        function im  = imagingType(typ, obj)
            %% IMAGINGTYPE returns imaging data cast as a requested representative type detailed below.
            %  @param typ is the requested representation:  'filename', 'fn', fqfilename', 'fqfn', 'fileprefix', 'fp',
            %  'fqfileprefix', 'fqfp', 'folder', 'path', 'ext', 'imagingContext', 
            %  '4dfp.hdr', '4dfp.ifh', '4dfp.img', '4dfp.img.rec', 'v', 'v.hdr', 'v.mhdr'. 
            %  @param obj is the representation of imaging data provided by the client.  
            %  @returns im is the imaging data obj cast as the requested representation.
            %  See also mlfourd.ImagingContext
            
            if (ischar(obj) && isdir(obj))
                im = mlpipeline.StudyDataSingleton.locationType(typ, obj);
                return
            end
            obj = mlfourd.ImagingContext(obj);
            switch (typ)
                case  'ext'
                    [~,~,im] = myfileparts(obj.filename);
                case {'filename' 'fn'}
                    im = obj.filename;
                case {'fqfilename' 'fqfn'}
                    im = obj.fqfilename;
                case {'fileprefix' 'fp'}
                    im = obj.fileprefix;
                case {'fqfileprefix' 'fqfp' 'fdfp'}
                    im = obj.fqfileprefix;
                case  'folder'
                    [~,im] = fileparts(obj.filepath);
                case {'imagingContext' 'mlfourd.ImagingContext'}
                    im = mlfourd.ImagingContext(obj);
                case  'mgh'
                    im = [obj.fqfileprefix '.mgh'];
                case  'mgz'
                    im = [obj.fqfileprefix '.mgz'];
                case  'mhdr'                    
                    im = [obj.fqfileprefix '.mhdr'];
                case {'mrImagingContext', 'mlmr.MRImagingContext'}
                    im = mlmr.MRImagingContext(obj);                    
                case  'nii'
                    im = [obj.fqfileprefix '.nii'];
                case  'nii.gz'
                    im = [obj.fqfileprefix '.nii.gz'];
                case  'path'
                    im = obj.filepath;
                case {'petImagingContext', 'mlpet.PETImagingContext'}
                    im = mlpet.PETImagingContext(obj);  
                case  'v'
                    im = [obj.fqfileprefix '.v'];
                case  'v.hdr'
                    im = [obj.fqfileprefix '.v.hdr'];
                case  'v.mhdr'
                    im = [obj.fqfileprefix '.v.mhdr'];
                case  '4dfp.hdr'
                    im = [obj.fqfileprefix '.4dfp.hdr'];
                case  '4dfp.ifh'
                    im = [obj.fqfileprefix '.4dfp.ifh'];
                case  '4dfp.img'
                    im = [obj.fqfileprefix '.4dfp.img'];
                case  '4dfp.img.rec'
                    im = [obj.fqfileprefix '.4dfp.img.rec'];
                otherwise
                    error('mlpipeline:insufficientSwitchCases', ...
                          'StudyDataSingleton.imagingType.obj->%s not recognized', obj);
            end
        end
        function tf  = isImagingType(t)
            tf = lstrcmp(t, mlpipeline.StudyDataSingletonHandle.IMAGING_TYPES);
        end
        function tf  = isLocationType(t)
            tf = lstrcmp(t, mlpipeline.StudyDataSingletonHandle.LOCATION_TYPES);
        end
        function loc = locationType(typ, loc0)
            %% LOCATIONTYPE returns location data cast as a requested representative type detailed below.
            %  @param typ is the requested representation:  'folder', 'path'.
            %  @param loc0 is the representation of location data provided by the client.  
            %  @returns loc is the location data loc0 cast as the requested representation.
            
            %assert(isdir(loc0));
            switch (typ)
                case 'folder'
                    [~,loc] = fileparts(loc0);
                case 'path'
                    loc = loc0;
                otherwise
                    error('mlpipeline:insufficientSwitchCases', ...
                          'StudyDataSingleton.locationType.loc0->%s not recognized', loc0);
            end
        end
        function d   = rawdataDir
            d = this.subjectsDir;
        end
    end
    
	methods
        function iter = createIteratorForSessionData(this)
            iter = this.sessionDataComposite_.createIterator;
        end
        function        diaryOff(~)
            diary off;
        end
        function        diaryOn(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.subjectsDir, @isdir);
            parse(ip, varargin{:});
            
            diary(fullfile(ip.Results.path, sprintf('%s_diary_%s.log', mfilename, datestr(now, 30))));
        end
        function tf   = isChpcHostname(~)
            [~,hn] = mlbash('hostname');
            tf = lstrfind(hn, 'gpu') || lstrfind(hn, 'node') || lstrfind(hn, 'login');
        end
        function loc  = loggingLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'type', 'path', @(x) this.isLocationType(x));
            parse(ip, varargin{:});
            
            switch (ip.Results.type)
                case 'folder'
                    [~,loc] = fileparts(this.subjectsDir);
                case 'path'
                    loc = this.subjectsDir;
                otherwise
                    error('mlpipeline:insufficientSwitchCases', ...
                          'StudyDataSingleton.loggingLocation.ip.Results.type->%s not recognized', ip.Results.type);
            end
        end
        function this = replaceSessionData(this, varargin)
            %% REPLACESESSIONDATA
            %  @param [parameter name,  parameter value, ...] as expected by mlpipeline.SessionData are optional;
            %  'studyData' and this are always internally supplied.
            %  @returns this.

            this.sessionDataComposite_ = mlpatterns.CellComposite({ ...
                mlpipeline.SessionData('studyData', this, varargin{:})});
        end
        function loc  = saveWorkspace(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.subjectsDir, @isdir);
            parse(ip, varargin{:});
            
            loc = fullfile(ip.Results.path, sprintf('%s_workspace_%s.mat', mfilename, datestr(now, 30)));
            if (this.isChpcHostname)
                save(loc, '-v7.3');
                return
            end
            save(loc);
        end
        function sess = sessionData(varargin)
            %% SESSIONDATA
            %  @param [parameter name,  parameter value, ...] as expected by mlpipeline.SessionData are optional;
            %  'studyData' and this are always internally supplied.
            %  @returns for empty param:  mlpatterns.CellComposite object or it's first element when singleton, 
            %  which are instances of mlpipeline.SessionData.
            %  @returns for non-empty param:  instance of mlraichle.SessionData corresponding to supplied params.
            
            if (isempty(varargin))
                sess = this.sessionDataComposite_;
                if (1 == length(sess))
                    sess = sess.get(1);
                end
                return
            end
            sess = mlpipeline.SessionData('studyData', this, varargin{:});
        end
    end
    
    %% PROTECTED
    
    properties (Access = protected)
        sessionDataComposite_
    end
    
    methods (Access = protected)
        function this = StudyDataSingleton(varargin)
            this.sessionDataComposite_ = mlpatterns.CellComposite;
            for v = 1:length(varargin)
                if (isa(varargin{v}, 'mlpatterns.CellComposite'))
                    this.sessionDataComposite_ = varargin{v};
                    return
                end
                if (isa(varargin{v}, 'mlpipeline.SessionData'))
                    this.sessionDataComposite_ = this.sessionDataComposite_.add(varargin{v});
                end
            end
            this = this.assignSessionDataCompositeFromPaths(varargin{:});
            this = this.assignSessionDataCompositeFromPaths(this.subjectsDirFqdns{:});
                   this.register;
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

