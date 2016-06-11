classdef StudyDataSingleton < mlpipeline.StudyDataSingletonHandle %%%& mlmr.MRDataHandle & mlpet.PETDataHandle
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
            if (ischar(obj) && isdir(obj))
                im = mlpipeline.StudyDataSingleton.locationType(typ, obj);
                return
            end
            obj = mlfourd.ImagingContext(obj);
            switch (typ)
                case {'filename' 'fn'}
                    im = obj.filename;
                case {'fqfilename' 'fqfn'}
                    im = obj.fqfn;
                case {'fileprefix' 'fp'}
                    im = obj.fileprefix;
                case {'fqfileprefix' 'fqfp'}
                    im = obj.fqfp;
                case  'folder'
                    [~,im] = fileparts(obj.filepath);
                case  'path'
                    im = obj.filepath;
                case  'ext'
                    [~,~,im] = myfileparts(obj.filename);
                case  'imagingContext'
                    im = mlfourd.ImagingContext(obj);
                otherwise
                    error('mlpipeline:insufficientSwitchCases', ...
                          'StudyDataSingleton.imagingType.obj->%s not recognized', obj);
            end
        end
        function loc = locationType(typ, pth)
            assert(isdir(pth));
            switch (typ)
                case 'folder'
                    [~,loc] = fileparts(pth);
                case 'path'
                    loc = pth;
                otherwise
                    error('mlpipeline:insufficientSwitchCases', ...
                          'StudyDataSingleton.locationType.pth->%s not recognized', pth);
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
        function        diaryOn(this)
            diary(fullfile(this.loggingLocation('path'), sprintf('%s_diary_%s.log', mfilename, datestr(now, 30))));
        end
        function tf   = isChpcHostname(~)
            [~,hn] = mlbash('hostname');
            tf = lstrfind(hn, 'gpu') || lstrfind(hn, 'node') || lstrfind(hn, 'login');
        end
        function loc  = loggingLocation(~) %#ok<STOUT>
        end
        function loc  = saveWorkspace(this)
            loc = fullfile(this.loggingLocation('path'), sprintf('%s_workspace_%s.mat', mfilename, datestr(now, 30)));
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

