classdef ProjectData < mlpipeline.IProjectData
	%% PROJECTDATA  

	%  $Revision$
 	%  was created 08-May-2019 19:15:11 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.5.0.1067069 (R2018b) Update 4 for MACI64.  Copyright 2019 John Joowon Lee.
 	
	properties (Dependent)
        projectsDir 		
 	end

	methods 
        
        %% GET
        
        function g = get.projectsDir(~)
            g = getenv('PROJECTS_DIR');
        end
        
        %%
        
        function g = getProjectFolder(varargin)
            g = '';
        end
        function g = getProjectPath(this, s)
            g = fullfile(this.projectsDir, this.getProjectFolder(s), '');
        end
		  
 		function this = ProjectData(varargin)
 			%% PROJECTDATA
 			%  @param .
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

