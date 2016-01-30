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
    
    properties
        comments
    end

	methods        
        function fn = fdg_fn(~, sessDat)
            fn = [sessDat.sessionFolder 'fdg.4dfp.nii.gz'];
        end
        function fn = gluc_fn(~, sessDat)
            fp = sprintf('%sgluc%i', sessDat.pnumber, sessDat.snumber);
            fn = fullfile([fp '_frames'], [fp '.nii.gz']);
        end
        function fn = ho_fn(~, sessDat)
            fp = sprintf('%sho%i', sessDat.pnumber, sessDat.snumber);
            fn = fullfile([fp '_frames'], [fp '.nii.gz']);
        end
        function fn = oc_fn(~, sessDat)
            frames = sprintf('%soc%i_frames', sessDat.pnumber, sessDat.snumber);
            dt = mlsystem.DirTool( ...
                fullfile(sessDat.petPath, frames, ...
                    sprintf('%soc%i*.nii.gz', sessDat.pnumber, sessDat.snumber))); 
            fn = fullfile(frames, dt.fns{1});
        end
        function fn = oo_fn(~, sessDat)
            fp = sprintf('%soo%i', sessDat.pnumber, sessDat.snumber);
            fn = fullfile([fp '_frames'], [fp '.nii.gz']);
        end
        function fn = tr_fn(~, sessDat)
            frames = sprintf('%str%i_frames', sessDat.pnumber, sessDat.snumber);
            dt = mlsystem.DirTool( ...
                fullfile(sessDat.petPath, frames, ...
                    sprintf('%str%i*.nii.gz', sessDat.pnumber, sessDat.snumber))); 
            fn = fullfile(frames, dt.fns{1});
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

