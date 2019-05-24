classdef SubjectData 
	%% SUBJECTDATA  

	%  $Revision$
 	%  was created 05-May-2019 22:07:32 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.5.0.1067069 (R2018b) Update 4 for MACI64.  Copyright 2019 John Joowon Lee.
 	
	properties (Dependent)
 		subjectFolder
        subjectPath
        subjectsDir
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
        function g    = get.subjectsDir(~)
            g = getenv('SUBJECTS_DIR');
        end
        function this = set.subjectsDir(this, s)
            assert(isdir(s));
            setenv('SUBJECTS_DIR', s);
        end
        
        %%
		  
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
        subjectFolder_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

