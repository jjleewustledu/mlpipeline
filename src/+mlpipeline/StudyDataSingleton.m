classdef StudyDataSingleton < handle
	%% STUDYDATASINGLETON  

	%  $Revision$
 	%  was created 21-Jan-2016 15:29:29
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

	properties (Abstract)
        loggingPath
    end
    
    methods (Static, Abstract)
        instance(qualifier)
        register(varargin)
    end
    
    methods (Abstract)
        f = fslFolder(    this, sessDat)
        f = hdrinfoFolder(this, sessDat)
        f = mriFolder(    this, sessDat)
        f = petFolder(    this, sessDat)
    end
    
    properties
        comments
    end

	methods    
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
                fp = sprintf('%sfdg', sessDat.sessionFolde);
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
        function iter = createIteratorForSessionData(this)
            iter = this.sessionDataComposite_.createIterator;
        end  
        
        function diaryOff(~)
            diary off;
        end
        function diaryOn(this)     
            diary(fullfile(this.loggingPath, sprintf('%s_diary_%s.log', mfilename, datestr(now, 30))));
        end
        function tf = isLocalhost(~)
            [~,hn] = mlbash('hostname');
            tf = lstrfind(hn, 'innominate');
        end
        function tf = isHostname(hn0)
            [~,hn] = mlbash('hostname');
            tf = lstrfind(hn, hn0);
        end
        function tf = isChpcHostname(~)
            [~,hn] = mlbash('hostname');
            tf = lstrfind(hn, 'gpu') || lstrfind(hn, 'node') || lstrfind(hn, 'login');
        end
        function saveWorkspace(this)
            if (this.isChpcHostname)
                save(fullfile(this.loggingPath, sprintf('%s_workspace_%s.mat', mfilename, datestr(now, 30))), '-v7.3');
                return
            end
            save(fullfile(this.loggingPath, sprintf('%s_workspace_%s.mat', mfilename, datestr(now, 30))));
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

