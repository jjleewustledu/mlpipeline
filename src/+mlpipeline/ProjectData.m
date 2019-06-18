classdef ProjectData < mlpipeline.IProjectData
	%% PROJECTDATA  

	%  $Revision$
 	%  was created 08-May-2019 19:15:11 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.5.0.1067069 (R2018b) Update 4 for MACI64.  Copyright 2019 John Joowon Lee.
 	
	properties (Dependent)
        projectPath
        projectFolder
    end
    
	methods 
        
        %% GET
        
        function g    = get.projectPath(this)
            g = fullfile(this.projectsDir, this.projectFolder, '');
        end
        function g    = get.projectFolder(this)
            g = this.projectFolder_;
        end
        
        %%
        
        function        diaryOff(~)
            diary off;
        end
        function        diaryOn(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.projectsDir, @isdir);
            parse(ip, varargin{:});
            loc = fullfile(ip.Results.path, diaryfilename('obj', class(this)));
            diary(loc);
        end
        function loc  = saveWorkspace(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.projectsDir, @isdir);
            parse(ip, varargin{:});
            loc = fullfile(ip.Results.path, matfilename('obj', class(this)));
            save(loc);
        end
		  
 		function this = ProjectData(varargin)
            %  @param projectFolder is char.
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'projectFolder', '', @ischar)
            parse(ip, varargin{:})
            this.projectFolder_ = ip.Results.projectFolder;
 		end
    end 
    
    %% PROTECTED
    
    properties (Access = protected)
        projectFolder_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

