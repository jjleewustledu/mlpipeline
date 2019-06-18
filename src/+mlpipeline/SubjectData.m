classdef SubjectData < mlpipeline.ISubjectData
	%% SUBJECTDATA  

	%  $Revision$
 	%  was created 05-May-2019 22:07:32 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.5.0.1067069 (R2018b) Update 4 for MACI64.  Copyright 2019 John Joowon Lee.
 	
	properties (Dependent)
        subjectsDir
        subjectPath
 		subjectFolder
 	end

	methods 
        
        %% GET/SET

        function g    = get.subjectFolder(this)
            g = this.subjectFolder_;
        end
        function this = set.subjectFolder(this, s)
            this.subjectFolder_ = s;
        end
        function g    = get.subjectPath(this)
            g = fullfile(this.subjectsDir, this.subjectFolder, '');
        end
        function this = set.subjectPath(this, s)
           assert(isdir(s)); 
           [this.subjectsDir,this.subjectFolder] = fileparts(s);
        end
        function g    = get.subjectsDir(this)
            g = this.studyRegistry_.subjectsDir;
        end
        function this = set.subjectsDir(this, s)
            assert(isdir(s));
            this.studyRegistry_.subjectsDir = s;
        end
        
        %%
        
        function        diaryOff(~)
            diary off;
        end
        function        diaryOn(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.subjectPath, @isdir);
            parse(ip, varargin{:});
            loc = fullfile(ip.Results.path, diaryfilename('obj', class(this)));
            diary(loc);
        end
        function loc  = saveWorkspace(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.subjectPath, @isdir);
            parse(ip, varargin{:});
            loc = fullfile(ip.Results.path, matfilename('obj', class(this)));
            save(loc);
        end
		  
 		function this = SubjectData(varargin)
 			%% SUBJECTDATA
 			%  @param subjectFolder is char.

            ip = inputParser;
            addParameter(ip, 'subjectFolder', '', @ischar);
            parse(ip, varargin{:});
            
            this.subjectFolder_ = ip.Results.subjectFolder;
 		end
    end 
    
    %% PROTECTED
    
    properties (Access = protected)
        studyRegistry_
        subjectFolder_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

