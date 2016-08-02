classdef StudyDataSingleton < mlpipeline.StudyDataSingletonHandle
	%% STUDYDATASINGLETON  
    %  Override empty loggingLocation, sessionData and empty methods from IMRData and IPETData

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
                case  'imagingContext'
                    im = mlfourd.ImagingContext(obj);
                case  'mgh'
                    im = [obj.fqfileprefix '.mgh'];
                case  'mgz'
                    im = [obj.fqfileprefix '.mgz'];
                case  'nii'
                    im = [obj.fqfileprefix '.nii'];
                case  'nii.gz'
                    im = [obj.fqfileprefix '.nii.gz'];
                case  'path'
                    im = obj.filepath;
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
        function tf  = isImagingType(t)
            tf = lstrcmp(t, mlpipeline.StudyDataSingletonHandle.IMAGING_TYPES);
        end
        function tf  = isLocationType(t)
            tf = lstrcmp(t, mlpipeline.StudyDataSingletonHandle.LOCATION_TYPES);
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
            %  @param parameter names and values expected by mlpipeline.SessionData;
            %  'studyData' and this are implicitly supplied.
            %  @returns mlpipeline.SessionData object
            
            sess = mlpipeline.SessionData('studyData', this, varargin{:});
        end
        
        %% IMRData
        
        function loc  = freesurferLocation(~) %#ok<STOUT>
        end
        function loc  = fslLocation(~) %#ok<STOUT>
        end
        function loc  = mriLocation(~) %#ok<STOUT>
        end
        
        function obj  = adc(~) %#ok<STOUT>
        end
        function obj  = aparcA2009sAseg(~) %#ok<STOUT>
        end
        function obj  = asl(~) %#ok<STOUT>
        end
        function obj  = bold(~) %#ok<STOUT>
        end
        function obj  = brain(~) %#ok<STOUT>
        end
        function obj  = dwi(~) %#ok<STOUT>
        end
        function obj  = ep2d(~) %#ok<STOUT>
        end
        function obj  = fieldmap(~) %#ok<STOUT>
        end
        function obj  = localizer(~) %#ok<STOUT>
        end
        function obj  = mpr(~) %#ok<STOUT>
        end
        function obj  = orig(~) %#ok<STOUT>
        end
        function obj  = t1(~) %#ok<STOUT>
        end
        function obj  = t2(~) %#ok<STOUT>
        end
        function obj  = tof(~) %#ok<STOUT>
        end
        function obj  = wmparc(~) %#ok<STOUT>
        end
                
        %% IPETData
        
        function loc  = hdrinfoLocation(~) %#ok<STOUT>
        end
        function loc  = petLocation(~) %#ok<STOUT>
        end        
        
        function obj  = ct(~) %#ok<STOUT>
        end
        function obj  = fdg(~) %#ok<STOUT>
        end
        function obj  = gluc(~) %#ok<STOUT>
        end
        function obj  = ho(~) %#ok<STOUT>
        end
        function obj  = oc(~) %#ok<STOUT>
        end
        function obj  = oo(~) %#ok<STOUT>
        end
        function obj  = tr(~) %#ok<STOUT>
        end
        function obj  = umap(~) %#ok<STOUT>
        end
    end
    
    %% DEPRECATED, HIDDEN
    
    methods (Hidden)        
        function fn = ep2d_fn(~, ~, varargin)
            ip = inputParser;
            addOptional(ip, 'suff', '', @ischar);
            parse(ip, varargin{:})
            try
                fn = sprintf('ep2d_default%s.nii.gz', ip.Results.suff);
            catch ME
                handwarning(ME);
                fn = '';
            end
        end
        function fn = fdg_fn(~, sessDat, varargin)
            ip = inputParser;
            addOptional(ip, 'suff', '', @ischar);
            parse(ip, varargin{:})
            try                
                fp = sprintf('%sfdg', sessDat.sessionFolder);
                fn = fullfile([fp '_frames'], [fp ip.Results.suff '.nii.gz']);
            catch ME
                handwarning(ME);
                fn = '';
            end
        end
        function fn = gluc_fn(~, sessDat, varargin)
            ip = inputParser;
            addOptional(ip, 'suff', '', @ischar);
            parse(ip, varargin{:})
            try
                fp = sprintf('%sgluc%i', sessDat.pnumber, sessDat.snumber);
                fn = fullfile([fp '_frames'], [fp ip.Results.suff '.nii.gz']);
            catch ME
                handwarning(ME);
                fn = '';
            end
        end
        function fn = ho_fn(~, sessDat, varargin)
            ip = inputParser;
            addOptional(ip, 'suff', '', @ischar);
            parse(ip, varargin{:})
            try
                fp = sprintf('%sho%i', sessDat.pnumber, sessDat.snumber);
                fn = fullfile([fp '_frames'], [fp ip.Results.suff '.nii.gz']);
            catch ME
                handwarning(ME);
                fn = '';
            end
        end
        function fn = oc_fn(~, sessDat, varargin)
            ip = inputParser;
            addOptional(ip, 'suff', '', @ischar);
            parse(ip, varargin{:})
            try
                frames = sprintf('%soc%i_frames', sessDat.pnumber, sessDat.snumber);
                if (~isempty(ip.Results.suff))
                    fn = fullfile(frames, sprintf('%soc%i%s.nii.gz', sessDat.pnumber, sessDat.snumber, ip.Results.suff));
                    return
                end
                
                dt = mlsystem.DirTool( ...
                    fullfile(sessDat.petPath, frames, ...
                        sprintf('%soc%i*.nii.gz', sessDat.pnumber, sessDat.snumber))); 
                if (isempty(dt.fns))
                    fn = '';
                    return
                end
                fn = fullfile(frames, dt.fns{1});
            catch ME
                handwarning(ME);
                fn = '';
            end
        end
        function fn = oo_fn(~, sessDat, varargin)
            ip = inputParser;
            addOptional(ip, 'suff', '', @ischar);
            parse(ip, varargin{:})
            try
                fp = sprintf('%soo%i', sessDat.pnumber, sessDat.snumber);
                fn = fullfile([fp '_frames'], [fp ip.Results.suff '.nii.gz']);
            catch ME
                handwarning(ME);
                fn = '';
            end
        end
        function fn = tr_fn(~, sessDat, varargin)
            ip = inputParser;
            addOptional(ip, 'suff', '', @ischar);
            parse(ip, varargin{:})
            try
                frames = sprintf('%str%i_frames', sessDat.pnumber, sessDat.snumber);
                if (~isempty(ip.Results.suff))
                    fn = fullfile(frames, sprintf('%str%i%s.nii.gz', sessDat.pnumber, sessDat.snumber, ip.Results.suff));
                    return
                end
                
                dt = mlsystem.DirTool( ...
                    fullfile(sessDat.petPath, frames, ...
                        sprintf('%str%i*.nii.gz', sessDat.pnumber, sessDat.snumber))); 
                if (isempty(dt.fns))
                    fn = '';
                    return
                end
                fn = fullfile(frames, dt.fns{1});
            catch ME
                handwarning(ME);
                fn = '';
            end
        end        
    end
    
    %% PROTECTED

    properties (Access = protected)
        sessionDataComposite_
    end
    
    methods (Access = protected)
        function this = StudyDataSingleton()
        end
    end 
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

