classdef AbstractDataBuilder < mlpipeline.RootDataBuilder & mlpipeline.IDataBuilder
	%% ABSTRACTDATABUILDER  

	%  $Revision$
 	%  was created 01-Feb-2017 22:41:34
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.1.0.441655 (R2016b) for MACI64.  Copyright 2017 John Joowon Lee.
 	

	properties 		
 		keepForensics = true
    end
    
    properties (Dependent)
        finished
        logger
        product        
        sessionData
        studyData
 	end

	methods 
        
        %% GET/SET
        
        function g = get.finished(this)
            g = this.finished_;
        end
        function g = get.logger(this)
            g = this.logger_;
        end  
        function g = get.product(this)
            g = this.product_;
        end
        function g = get.sessionData(this)
            g = this.sessionData_;
        end
        function g = get.studyData(this)
            g = this.sessionData.studyData;
        end
        
        function this = set.sessionData(this, s)
            assert(isa(s, 'mlpipeline.SessionData'));
            this.sessionData_ = s;
        end
        
        %%
        
        function tf   = isequal(this, obj)
            %  @param obj any object
            %  @return tf := operational equivalence of this and obj.
            
            tf = this.isequaln(obj);
        end
        function tf   = isequaln(this, obj)
            %  @param obj any object
            %  @return tf := operational equivalence of this and obj.
            
            if (isempty(obj)); tf = false; return; end
            tf = this.classesequal(obj);
            if (tf)
                tf = this.sessionData.isequal(obj.sessionData);
            end
        end   
        function tf   = isfinished(this, varargin)
            if (isempty(this.finished))
                tf = false; 
                return
            end
            tf = this.finished.isfinished;
        end
        function tag  = resolveTagFrame(this, varargin)
            tag = this.sessionData.resolveTagFrame(varargin{:});
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
        function this = updateFinished(this, varargin)
            ip = inputParser;
            addParameter(ip, 'tag', ...
                sprintf('updateFinished_%s', lower(this.sessionData.sessionFolder)), ...
                @ischar);
            parse(ip, varargin{:});
            
            this.finished_ = mlpipeline.Finished(this, 'path', this.logger.filepath, 'tag', ip.Results.tag);
        end
        function obj  = vLocation(this, varargin)
            obj = this.sessionData.vLocation(varargin{:});
        end
        
        function this = AbstractDataBuilder(varargin)
            %% ABSTRACTDATABUILDER
            %  @param named 'logger' is an mlpipeline.AbstractLogger.
            %  @param named 'product' is the initial state of the product to build; default := [].
            %  @param named 'sessionData' is an mlpipeline.ISessionData; default := [].
            
 			ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'logger', mlpipeline.Logger, @(x) isa(x, 'mlpipeline.AbstractLogger'));
            addParameter(ip, 'product', []);
            addParameter(ip, 'sessionData', [], @(x) isa(x, 'mlpipeline.ISessionData'));
            parse(ip, varargin{:});
            
            this.logger_      = ip.Results.logger;
            this.product_     = ip.Results.product;
            this.sessionData_ = ip.Results.sessionData;
        end
    end
    
    %% PROTECTED
    
    properties (Access = protected)
        finished_
        logger_
        product_
        sessionData_
    end
    
    %% PRIVATE
    
    methods (Access = private)        
        function [tf,msg] = classesequal(this, c)
            tf  = true; 
            msg = '';
            if (~isa(c, class(this)))
                tf  = false;
                msg = sprintf('class(this)-> %s but class(compared)->%s', class(this), class(c));
            end
            if (~tf)
                warning('mlpipeline:isequal:mismatchedClass', msg);
            end
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

