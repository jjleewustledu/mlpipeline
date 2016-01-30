classdef SessionData < mlpipeline.ISessionData
	%% SESSIONDATA  

	%  $Revision$
 	%  was created 21-Jan-2016 22:20:41
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

	properties (Dependent)
        subjectsDir
        sessionPath
        sessionFolder
        pnumber
        snumber
 		mriPath
        petPath
        hdrinfoPath
        fslPath
        
        fdg_fqfn
        gluc_fqfn
        ho_fqfn
        oc_fqfn
        oo_fqfn
        tr_fqfn
        pet_fqfns
        T1_fqfn
        aparcA2009sAseg_fqfn
    end
    
    methods %% GET
        function g = get.subjectsDir(this)
            g = fileparts(this.sessionPath_); % by definition
        end
        function g = get.sessionPath(this)
            g = this.sessionPath_;
        end
        function g = get.sessionFolder(this)
            [~,f] = myfileparts(this.sessionPath_);
            g = f;
        end
        function g = get.pnumber(this)
            g = str2pnum(this.sessionFolder);
        end
        function g = get.snumber(this)
            g = this.snumber_;
        end
        function this = set.snumber(this, s)
            this.snumber_ = s;
        end
        function g = get.mriPath(this)
            g = fullfile(this.sessionPath_, this.studyData_.mriFolder, '');
        end
        function g = get.petPath(this)
            g = fullfile(this.sessionPath_, this.studyData_.petFolder(this), '');
        end
        function g = get.hdrinfoPath(this)
            g = fullfile(this.sessionPath_, this.studyData_.hdrinfoFolder(this), '');
        end
        function g = get.fslPath(this)
            g = fullfile(this.sessionPath_, this.studyData_.fslFolder, '');
        end
        function g = get.fdg_fqfn(this)
            g = fullfile(this.petPath, this.studyData_.fdg_fn(this));
        end
        function g = get.gluc_fqfn(this)
            g = fullfile(this.petPath, this.studyData_.gluc_fn(this));
        end
        function g = get.ho_fqfn(this)
            g = fullfile(this.petPath, this.studyData_.ho_fn(this));
        end
        function g = get.oc_fqfn(this)
            g = fullfile(this.petPath, this.studyData_.oc_fn(this));
        end
        function g = get.oo_fqfn(this)
            g = fullfile(this.petPath, this.studyData_.oo_fn(this));
        end
        function g = get.tr_fqfn(this)
            g = fullfile(this.petPath, this.studyData_.tr_fn(this));
        end
        function g = get.pet_fqfns(this)
            fqfns = { this.fdg_fqfn this.gluc_fqfn this.ho_fqfn this.oc_fqfn this.oo_fqfn this.tr_fqfn };
            g = {};
            for f = 1:length(fqfns)
                if (lexist(fqfns{f}, 'file'))
                    g = [g fqfns{f}];
                end
            end
        end
        function g = get.T1_fqfn(this)
            g = fullfile(this.mriPath, 'T1.mgz');
        end
        function g = get.aparcA2009sAseg_fqfn(this)
            g = fullfile(this.mriPath, 'aparc.a2009s+aseg.mgz');
        end
    end

	methods
        
 		function this = SessionData(varargin)
 			%% SESSIONDATA
 			%  @param [param-name, param-value[, ...]]
            %         'studyData'   is a mlpipeline.StudyDataSingleton
            %         'sessionPath' is a path to the session data

            ip = inputParser;
            addParameter(ip, 'studyData', [], @(x) isa(x, 'mlpipeline.StudyDataSingleton'));
            addParameter(ip, 'sessionPath', pwd, @isdir);
            addParameter(ip, 'snumber', 1, @isnumeric);
            parse(ip, varargin{:});
            
            this.studyData_   = ip.Results.studyData;
            this.sessionPath_ = ip.Results.sessionPath;
 		end
    end 
    
    %% PRIVATE
    
    properties (Access = private)
        studyData_
        sessionPath_
        snumber_ = 1
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

