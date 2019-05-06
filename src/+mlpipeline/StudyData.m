classdef (Abstract) StudyData < handle & mlpipeline.IStudyHandle
	%% STUDYDATA  

	%  $Revision$
 	%  was created 21-Jan-2016 15:29:29
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	
    
    properties
        comments
    end
    
	methods        
        
        %%
        
        function        diaryOff(~)
            diary off;
        end
        function        diaryOn(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.subjectsDir, @isdir);
            parse(ip, varargin{:});            
            diary( ...
                fullfile(ip.Results.path, sprintf('%s_diary_%s.log', mfilename, mydatetimestr(now))));
        end
        function tf   = isChpcHostname(~)
            [~,hn] = hostname;
            tf = lstrfind(hn, 'gpu') || lstrfind(hn, 'node') || lstrfind(hn, 'login') || lstrfind(hn, 'cluster');
        end
        function loc  = saveWorkspace(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.subjectsDir, @isdir);
            parse(ip, varargin{:});
            loc = fullfile(ip.Results.path, sprintf('%s_workspace_%s.mat', mfilename, mydatetimestr(now)));
            save(loc);
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

