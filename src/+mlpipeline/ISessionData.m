classdef (Abstract) ISessionData
	%% ISESSIONDATA  

	%  $Revision$
 	%  was created 28-Jan-2016 22:45:12
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
	
	properties (Abstract)
        freesurfersDir
        freesurfersFolder
        rawdataDir % homolog of subjectsDir
        rawdataFolder
        scan
        sessionDate
        sessionFolder
        sessionPath
        study
        subjectsDir % Freesurfer convention
        subjectsFolder  
        vfolder
        vnumber
    end
    
    properties (Dependent)
        freesurfersPath
        project      % alias
        rawdataPath  % alias
        session 
        sessionDir   % alias
        subject      % alias
        subjectsPath % alias
    end
    
	methods (Abstract)
        tf  = isequal(this)
        tf  = isequaln(this)
 	end 
    
    methods 
        
        %% GET
        
        function g = get.freesurfersPath(this)
            g = this.freesurfersDir;
        end
        function g = get.project(this)
            g = this.study;
        end
        function g = get.rawdataPath(this)
            g = this.rawdataDir;
        end
        function g = get.session(this)
            g = sprintf('%s_%s', this.sessionFolder, this.vfolder);
        end
        function g = get.sessionDir(this)
            g = this.sessionPath;
        end
        function g = get.subject(this)
            g = this.subjectsFolder;
        end
        function g = get.subjectsPath(this)
            g = this.subjectsDir;
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
    
 end

