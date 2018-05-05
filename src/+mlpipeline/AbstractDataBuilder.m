classdef AbstractDataBuilder < mlpipeline.RootDataBuilder & mlpipeline.IDataBuilder
	%% ABSTRACTDATABUILDER  

	%  $Revision$
 	%  was created 01-Feb-2017 22:41:34
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.1.0.441655 (R2016b) for MACI64.  Copyright 2017 John Joowon Lee.
 	

	properties
 		keepForensics
        neverTouchFinishfile
        ignoreFinishfile
    end
    
    properties (Dependent)
        buildVisitor
        finished
        logger
        product        
        sessionData
        studyData
 	end

	methods 
        
        %% GET/SET
        
        function g = get.buildVisitor(this)
            g = this.buildVisitor_;
        end
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
        
        function this = set.buildVisitor(this, v)
            assert(~isempty(v));
            this.buildVisitor_ = v;
        end
        function this = set.finished(this, s)
            assert(isa(s, 'mlpipeline.Finished'));
            this.finished_ = s;
        end
        function this = set.sessionData(this, s)
            assert(isa(s, 'mlpipeline.SessionData'));
            this.sessionData_ = s;
        end
        
        %%
        
        function g    = getNeverTouch(this)
            g = this.finished_.neverTouchFinishfile;            
        end
        function this = setNeverTouch(this, s)
            assert(islogical(s));
            this.finished_.neverTouchFinishfile = s;
        end
        
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
            if (isempty(this.finished) || this.ignoreFinishfile)
                tf = false; 
                return
            end
            tf = this.finished.isfinished;
        end        
        function this = updateFinished(this, varargin)
            ip = inputParser;
            addParameter(ip, 'tag', sprintf('%s_%s', lower(this.sessionData.tracerRevision('typ','fp')), class(this)), @ischar);
            addParameter(ip, 'tag2', '', @ischar);
            parse(ip, varargin{:});
            
            ensuredir(this.logPath);
            this.finished_ = mlpipeline.Finished(this, ...
                'path', this.logPath, ...
                'tag', sprintf('%s%s', ip.Results.tag, ip.Results.tag2), ...
                'neverTouchFinishfile', this.neverTouchFinishfile, ...
                'ignoreFinishfile', this.ignoreFinishfile);
        end  
        function pth  = logPath(this)
            pth = fullfile(this.sessionData.tracerLocation, 'Log', '');
            ensuredir(pth);
        end      
        function this = packageProduct(this, prod)
            %  @param prod, an objects understood by mlfourd.ImagingContext.
            %  @return this.product packaged as an ImagingContext if nontrivial; otherwise this.product := [].
            
            if (isempty(prod))
                this.product_ = [];
                return
            end
            if (iscell(prod))
                this.product_ = prod;
                return
            end
            
            this.product_ = mlfourd.ImagingContext(prod);
            if (lstrfind(this.product_.filesuffix, '4dfp'))
                this.product_.filesuffix = '.4dfp.ifh';
            end
        end
        
        function this = AbstractDataBuilder(varargin)
            %% ABSTRACTDATABUILDER
            %  @param named logger is an mlpipeline.AbstractLogger.
            %  @param named product is the initial state of the product to build; default := [].
            %  @param named sessionData is an mlpipeline.ISessionData; default := [].
            %  @param named buildVisitor ...
            
 			ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'logger', mlpipeline.Logger, @(x) isa(x, 'mlpipeline.AbstractLogger'));
            addParameter(ip, 'product', []);
            addParameter(ip, 'sessionData', [], @(x) isa(x, 'mlpipeline.ISessionData'));
            addParameter(ip, 'buildVisitor',  mlfourdfp.FourdfpVisitor);
            addParameter(ip, 'keepForensics', false, @islogical);
            addParameter(ip, 'neverTouchFinishfile', false, @islogical);
            addParameter(ip, 'ignoreFinishfile', false, @islogical);
            parse(ip, varargin{:});
            
            if (this.receivedCtor(varargin{:}))
                this = this.copyCtor(varargin{:});
                return
            end
            this.logger_         = ip.Results.logger;
            this.product_        = ip.Results.product;
            this.sessionData_    = ip.Results.sessionData;
            this.buildVisitor_   = ip.Results.buildVisitor;
            this.keepForensics   = ip.Results.keepForensics;
            this.neverTouchFinishfile = ip.Results.neverTouchFinishfile;
            this.ignoreFinishfile = ip.Results.ignoreFinishfile;            
        end
        function tf   = receivedCtor(~, varargin)
            tf = (1 == length(varargin)) && ...
                 isa(varargin{1}, 'mlpipeline.AbstractDataBuilder');
        end
        function this = copyCtor(this, varargin)
            aCopy = varargin{1};
            this.logger_ = aCopy.logger;
            this.product_ = aCopy.product_;
            this.sessionData_ = aCopy.sessionData_;
            this.buildVisitor_ = aCopy.buildVisitor_;
            this.keepForensics = aCopy.keepForensics;
            this.neverTouchFinishfile = aCopy.neverTouchFinishfile;
            this.ignoreFinishfile = aCopy.ignoreFinishfile;
            this.finished_ = aCopy.finished;
        end
    end
    
    %% PROTECTED
    
    properties (Access = protected)
        buildVisitor_
        finished_
        logger_
        product_
        sessionData_
    end
    
    methods (Access = protected)
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

