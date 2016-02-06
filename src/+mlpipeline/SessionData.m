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
        vnumber
 		mriPath
        petPath
        hdrinfoPath
        fslPath
        
        aparcA2009sAseg
        ep2d
        fdg
        gluc
        ho
        mpr
        oc
        oo
        orig
        petAtlas
        petfov
        tof
        toffov
        tr
        T1
        wmparc
        
        aparcA2009sAseg_fqfn
        ep2d_fqfn
        fdg_fqfn
        gluc_fqfn
        ho_fqfn
        mpr_fqfn
        oc_fqfn
        oo_fqfn
        orig_fqfn
        pet_fqfns
        petfov_fqfn
        tof_fqfn
        toffov_fqfn
        tr_fqfn
        T1_fqfn
        wmparc_fqfn
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
            warning('off', 'mfiles:regexpNotFound');
            g = str2pnum(this.sessionFolder);
            warning('on', 'mfiles:regexpNotFound');
        end
        function g = get.snumber(this)
            g = this.snumber_;
        end
        function this = set.snumber(this, s)
            this.snumber_ = s;
        end
        function g = get.vnumber(this)
            g = this.vnumber_;
        end
        function this = set.vnumber(this, s)
            this.vnumber_ = s;
        end
        function g = get.mriPath(this)
            g = fullfile(this.sessionPath_, this.studyData_.mriFolder(this), '');
        end
        function g = get.petPath(this)
            g = fullfile(this.sessionPath_, this.studyData_.petFolder(this), '');
        end
        function g = get.hdrinfoPath(this)
            g = fullfile(this.sessionPath_, this.studyData_.hdrinfoFolder(this), '');
        end
        function g = get.fslPath(this)
            g = fullfile(this.sessionPath_, this.studyData_.fslFolder(this), '');
        end
        
        function g = get.aparcA2009sAseg(this)
            g = mlmr.MRImagingContext(this.aparcA2009sAseg_fqfn);
        end
        function g = get.ep2d(this)
            g = mlmr.MRImagingContext(this.ep2d_fqfn);
        end
        function g = get.fdg(this)
            g = mlpet.PETImagingContext(this.fdg_fqfn);
        end
        function g = get.gluc(this)
            g = mlpet.PETImagingContext(this.gluc_fqfn);
        end
        function g = get.ho(this)
            g = mlpet.PETImagingContext(this.ho_fqfn);
        end
        function g = get.mpr(this)
            g = mlmr.MRImagingContext(this.mpr_fqfn);
        end
        function g = get.oc(this)
            g = mlpet.PETImagingContext(this.oc_fqfn);
        end
        function g = get.oo(this)
            g = mlpet.PETImagingContext(this.oo_fqfn);
        end
        function g = get.orig(this)
            g = mlmr.MRImagingContext(this.orig_fqfn);
        end
        function g = get.petAtlas(this)
            g = mlpet.PETImagingContext(this.pet_fqfns);
            g = g.atlas;
        end
        function g = get.petfov(this)
            g = mlfourd.ImagingContext(this.petfov_fqfn);
        end
        function g = get.tof(this)
            g = mlmr.MRImagingContext(this.tof_fqfn);
        end
        function g = get.toffov(this)
            g = mlfourd.ImagingContext(this.toffov_fqfn);
        end
        function g = get.tr(this)
            g = mlpet.PETImagingContext(this.tr_fqfn);
        end
        function g = get.T1(this)
            g = mlmr.MRImagingContext(this.T1_fqfn);
        end
        function g = get.wmparc(this)
            g = mlmr.MRImagingContext(this.wmparc_fqfn);
        end
        
        function g = get.aparcA2009sAseg_fqfn(this)
            g = fullfile(this.mriPath, 'aparc.a2009s+aseg.mgz');
            if (2 ~= exist(g, 'file'))
                g = '';
                return
            end
        end
        function g = get.ep2d_fqfn(this)
            g = fullfile(this.fslPath, this.studyData_.ep2d_fn(this));
            if (2 ~= exist(g, 'file'))
                g = '';
                return
            end
        end
        function g = get.fdg_fqfn(this)
            g = fullfile(this.petPath, this.studyData_.fdg_fn(this));
            if (2 ~= exist(g, 'file'))
                g = '';
                return
            end
        end
        function g = get.gluc_fqfn(this)
            g = fullfile(this.petPath, this.studyData_.gluc_fn(this));
            if (2 ~= exist(g, 'file'))
                g = '';
                return
            end
        end
        function g = get.ho_fqfn(this)
            g = fullfile(this.petPath, this.studyData_.ho_fn(this));
            if (2 ~= exist(g, 'file'))
                g = '';
                return
            end
        end
        function g = get.mpr_fqfn(this)
            g = fullfile(this.fslPath, this.studyData_.mpr_fn(this));
            if (2 ~= exist(g, 'file'))
                g = '';
                return
            end
        end
        function g = get.oc_fqfn(this)
            g = fullfile(this.petPath, this.studyData_.oc_fn(this));
            if (2 ~= exist(g, 'file'))
                g = '';
                return
            end
        end
        function g = get.oo_fqfn(this)
            g = fullfile(this.petPath, this.studyData_.oo_fn(this));
            if (2 ~= exist(g, 'file'))
                g = '';
                return
            end
        end
        function g = get.orig_fqfn(this)
            g = fullfile(this.mriPath, 'orig.mgz');
        end
        function g = get.pet_fqfns(this)
            fqfns = { this.fdg_fqfn this.gluc_fqfn this.ho_fqfn this.oc_fqfn this.oo_fqfn this.tr_fqfn };
            g = {};
            for f = 1:length(fqfns)
                if (2 == exist(fqfns{f}, 'file'))
                    g = [g fqfns{f}];
                end
            end
        end
        function g = get.petfov_fqfn(this)
            g = fullfile(this.petPath, this.studyData_.petfov_fn);
            if (2 ~= exist(g, 'file'))
                g = '';
                return
            end
        end
        function g = get.tof_fqfn(this)
            g = fullfile(this.petPath, 'fdg', 'pet_proc', this.studyData_.tof_fn);
            if (2 ~= exist(g, 'file'))
                g = '';
                return
            end
        end
        function g = get.toffov_fqfn(this)
            g = fullfile(this.petPath, 'fdg', 'pet_proc', this.studyData_.toffov_fn);
            if (2 ~= exist(g, 'file'))
                g = '';
                return
            end
        end
        function g = get.tr_fqfn(this)
            g = fullfile(this.petPath, this.studyData_.tr_fn(this));
            if (2 ~= exist(g, 'file'))
                g = '';
                return
            end
        end
        function g = get.T1_fqfn(this)
            g = fullfile(this.mriPath, 'T1.mgz');
        end
        function g = get.wmparc_fqfn(this)
            g = fullfile(this.mriPath, 'wmparc.mgz');
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
            addParameter(ip, 'vnumber', 1, @isnumeric);
            parse(ip, varargin{:});
            
            this.studyData_   = ip.Results.studyData;
            this.sessionPath_ = ip.Results.sessionPath;
            this.snumber_     = ip.Results.snumber;
            this.vnumber_     = ip.Results.vnumber;
 		end
    end 
    
    %% PRIVATE
    
    properties (Access = private)
        studyData_
        sessionPath_
        snumber_ = 1
        vnumber_ = 1
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

