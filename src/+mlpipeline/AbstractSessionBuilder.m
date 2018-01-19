classdef AbstractSessionBuilder < mlpipeline.AbstractDataBuilder & mlpipeline.ISessionData
	%% ABSTRACTSESSIONBUILDER provides convenience methods that return information from this.sessionData.

	%  $Revision$
 	%  was created 03-Oct-2017 20:06:31 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlpet/src/+mlpet.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.
 	

    properties (Dependent)
        filetypeExt
        freesurfersDir
        sessionFolder
        sessionPath
        subjectsDir
        subjectsFolder
        
        attenuationCorrected
        pnumber
        rnumber
        snumber
        tracer
        vnumber
    end
    
    methods (Static)        
        function fn    = fslchfiletype(varargin)
            fn = mlpipeline.SessionData.fslchfiletype(varargin{:});
        end
        function fn    = mri_convert(varargin)
            %% MRI_CONVERT
            %  @param fn is the source possessing a filename extension recognized by mri_convert
            %  @param fn is the destination, also recognized by mri_convert.  Optional.  Default is [fileprefix(fn) '.nii.gz'] 
                                    
            fn = mlpipeline.SessionData.mri_convert(varargin{:});
        end
        function [s,r] = nifti_4dfp_4(varargin)
            [s,r] = mlpipeline.SessionData.nifti_4dfp_4(varargin{:});
        end
        function [s,r] = nifti_4dfp_n(varargin)
            [s,r] = mlpipeline.SessionData.nifti_4dfp_n(varargin{:});
        end
        function [s,r] = nifti_4dfp_ng(varargin)
            [s,r] = mlpipeline.SessionData.nifti_4dfp_ng(varargin{:});
        end
        function fn = niigzFilename(varargin)
            fn = mlpipeline.SessionData.niigzFilename(varargin{:});
        end
    end
    
	methods
        
        %% GET
        
        function g  = get.filetypeExt(this)
            g = this.sessionData.filetypeExt;
        end
        function g  = get.freesurfersDir(this)
            g = this.sessionData.freesurfersDir;
        end
        function g  = get.sessionFolder(this)
            g = this.sessionData.sessionFolder;
        end
        function g  = get.sessionPath(this)
            g = this.sessionData.sessionPath;
        end
        function g  = get.subjectsDir(this)
            g = this.sessionData.subjectsDir;
        end
        function g  = get.subjectsFolder(this)
            g = this.sessionData.subjectsFolder;
        end
        function g  = get.attenuationCorrected(this)
            g = this.sessionData.attenuationCorrected;
        end
        function g  = get.pnumber(this)
            g = this.sessionData.pnumber;
        end
        function g  = get.rnumber(this)
            g = this.sessionData.rnumber;
        end
        function this = set.rnumber(this, s)
            assert(isnumeric(s));
            this.sessionData_.rnumber = s;
        end
        function g  = get.snumber(this)
            g = this.sessionData.snumber;
        end
        function g  = get.tracer(this)
            g = this.sessionData.tracer;
        end
        function g  = get.vnumber(this)
            g = this.sessionData.vnumber;
        end
        
        %%
        
        function obj  = freesurferLocation(this, varargin)
            obj = this.sessionData.freesurferLocation(varargin{:});
        end
        function obj  = fslLocation(this, varargin)
            obj = this.sessionData.fslLocation(varargin{:});
        end
        function obj  = mriLocation(this, varargin)
            obj = this.sessionData.mriLocation(varargin{:});
        end
        function obj  = petLocation(this, varargin)
            obj = this.sessionData.petLocation(varargin{:});
        end
        function obj  = sessionLocation(this, varargin)
            obj = this.sessionData.sessionLocation(varargin{:});
        end
        function obj  = tracerEpoch(this, varargin)
            obj = this.sessionData.tracerEpoch(varargin{:});
        end
        function obj  = tracerLocation(this, varargin)
            obj = this.sessionData.tracerLocation(varargin{:});
        end
        function obj  = tracerResolved(this, varargin)
            obj = this.sessionData.tracerResolved(varargin{:});
        end
        function obj  = tracerResolvedFinal(this, varargin)
            obj = this.sessionData.tracerResolvedFinal(varargin{:});
        end
        function obj  = tracerResolvedFinalSumt(this, varargin)
            obj = this.sessionData.tracerResolvedFinalSumt(varargin{:});
        end
        function obj  = tracerResolvedSumt(this, varargin)
            obj = this.sessionData.tracerResolvedSumt(varargin{:});
        end
        function obj  = tracerRevision(this, varargin)
            obj = this.sessionData.tracerRevision(varargin{:});
        end
        function obj  = tracerRevisionSumt(this, varargin)
            obj = this.sessionData.tracerRevisionSumt(varargin{:});
        end
        function obj  = T1(this, varargin)
            obj = this.sessionData.T1(varargin{:});
        end
        function obj  = T1001(this, varargin)
            obj = this.sessionData.T1(varargin{:});
        end
        function obj  = t1(this, varargin)
            obj = this.sessionData.T1(varargin{:});
        end
        function obj  = t2(this, varargin)
            obj = this.sessionData.t2(varargin{:});
        end
        function obj  = tof(this, varargin)
            obj = this.sessionData.tof(varargin{:});
        end
        function fqfp = umap(this, varargin)
            fqfp = this.sessionData.umap(varargin{:});
        end 
        function fqfp = umapSynth(this, varargin)
            fqfp = this.sessionData.umapSynth(varargin{:});
        end
        function obj  = vLocation(this, varargin)
            obj = this.sessionData.vLocation(varargin{:});
        end
        
 		function this = AbstractSessionBuilder(varargin)
 			%% ABSTRACTSESSIONBUILDER

 			this = this@mlpipeline.AbstractDataBuilder(varargin{:});
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end
