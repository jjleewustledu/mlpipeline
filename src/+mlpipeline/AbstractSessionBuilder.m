classdef AbstractSessionBuilder < mlfourdfp.AbstractBuilder
	%% ABSTRACTSESSIONBUILDER provides convenience methods that return information from this.sessionData.

	%  $Revision$
 	%  was created 03-Oct-2017 20:06:31 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlpet/src/+mlpet.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.
 	

    properties (Dependent)
        census
        dbgTag
        filetypeExt
        freesurfersDir
        rawdataDir
        sessionData
        sessionFolder
        sessionPath
        subjectsDir
        subjectsFolder
        vfolder
        
        attenuationCorrected
        pnumber
        rnumber
        snumber
        tracer
        vnumber
    end
    
	methods
        
        %% GET
        
        function g    = get.dbgTag(this)
            g = this.sessionData.dbgTag;
        end
        function g    = get.census(this)
            g = this.census_;
        end
        function g    = get.filetypeExt(this)
            g = this.sessionData.filetypeExt;
        end
        function g    = get.freesurfersDir(this)
            g = this.sessionData.freesurfersDir;
        end
        function g    = get.rawdataDir(this)
            g = this.sessionData_.rawdataDir;
        end
        function g    = get.sessionData(this)
            g = this.sessionData_;
        end
        function this = set.sessionData(this, s)
            assert(isa(s, 'mlpipeline.SessionData'));
            this.sessionData_ = s;
        end
        function g    = get.sessionFolder(this)
            g = this.sessionData.sessionFolder;
        end
        function g    = get.sessionPath(this)
            g = this.sessionData.sessionPath;
        end
        function g    = get.subjectsDir(this)
            g = this.sessionData.subjectsDir;
        end
        function g    = get.subjectsFolder(this)
            g = this.sessionData.subjectsFolder;
        end
        function g    = get.attenuationCorrected(this)
            g = this.sessionData.attenuationCorrected;
        end
        function g    = get.pnumber(this)
            g = this.sessionData.pnumber;
        end
        function g    = get.rnumber(this)
            g = this.sessionData.rnumber;
        end
        function this = set.rnumber(this, s)
            this.sessionData_.rnumber = s;
        end
        function g    = get.snumber(this)
            g = this.sessionData.snumber;
        end
        function this = set.snumber(this, s)
            this.sessionData_.snumber = s;
        end  
        function g    = get.tracer(this)
            g = this.sessionData.tracer;
        end
        function this = set.tracer(this, s)
            this.sessionData_.tracer = s;
        end  
        function g    = get.vfolder(this)
            g = this.sessionData_.vfolder;
        end
        function g    = get.vnumber(this)
            g = this.sessionData.vnumber;
        end
        
        %%
        
        function obj  = freesurferLocation(this, varargin)
            obj = this.sessionData.freesurferLocation(varargin{:});
        end
        function obj  = fslLocation(this, varargin)
            obj = this.sessionData.fslLocation(varargin{:});
        end
        function obj  = sessionLocation(this, varargin)
            obj = this.sessionData.sessionLocation(varargin{:});
        end
        function this = prepareMprToAtlasT4(this)
            %% PREPAREMPRTOATLAST4
            %  @param this.sessionData.{mprage,atlas} are valid.
            %  @return this.product_ := [mprage '_to_' atlas '_t4'], existing in the same folder as mprage.
            
            sess       = this.sessionData;
            mpr        = sess.mprage('typ', 'fp');
            mprToAtlT4 = [mpr '_to_' sess.atlas('typ', 'fp') '_t4'];            
            if (~lexist(fullfile(sess.mprage('typ', 'path'), mprToAtlT4)))
                pwd0 = pushd(sess.mprage('typ', 'path'));
                this.buildVisitor.msktgenMprage(mpr);
                popd(pwd0);
            end
            this.product_ = mprToAtlT4;
        end
        
        function a    = atlas(this, varargin) 
            a = this.sessionData.atlas(varargin{:});
        end
        function obj  = mpr(this, varargin)
            obj = this.sessionData.mpr(varargin{:});
        end
        function obj  = mriLocation(this, varargin)
            obj = this.sessionData.mriLocation(varargin{:});
        end
        function obj  = petLocation(this, varargin)
            obj = this.sessionData.petLocation(varargin{:});
        end
        function sessd = refreshTracerResolvedFinalSumt(this, sessd)
            while (~lexist(sessd.tracerResolvedFinalSumt) && sessd.supEpoch > 0)
                sessd.supEpoch = sessd.supEpoch - 1;
            end
            if (lexist(sessd.tracerResolvedFinalSumt))                
                delete(                        [sessd.tracerResolvedFinalSumt('typ','fp') '.4dfp.*']);
                this.buildVisitor.copyfile_4dfp(sessd.tracerResolvedFinalSumt('typ','fqfp'));
                return
            end
            error('mlpipeline:pipelinePrerequisiteMissing', ...
                '%s may be missing; consider running constructResolved(''tracer'', ''%s'') and retry', ...
                sessd.tracerResolvedFinalSumt('typ','fqfp'), sessd.tracer);
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
        function obj  = tracerResolvedSubj(this, varargin)
            obj = this.sessionData.tracerResolvedSubj(varargin{:});
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
            obj = this.sessionData.T1001(varargin{:});
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
        function obj  = vallLocation(this, varargin)
            obj = this.sessionData.vallLocation(varargin{:});
        end
        function obj  = vLocation(this, varargin)
            obj = this.sessionData.vLocation(varargin{:});
        end
        
 		function this = AbstractSessionBuilder(varargin)
 			%% ABSTRACTSESSIONBUILDER

 			this = this@mlfourdfp.AbstractBuilder(varargin{:});            
            ip = inputParser;
            ip.KeepUnmatched = true;            
            addParameter(ip, 'census', [], @(x) isa(x, 'mlpipeline.IStudyCensus') || isempty(x));
            addParameter(ip, 'sessionData', [], @(x) isa(x, 'mlpipeline.ISessionData'));
            parse(ip, varargin{:});            
            this.census_ = ip.Results.census;
            this.sessionData_ = ip.Results.sessionData;
 		end
    end 
    
    %% PROTECTED
    
    properties (Access = protected)
        sessionData_
    end
    
    %% PRIVATE
    
    properties (Access = private)
        census_
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

