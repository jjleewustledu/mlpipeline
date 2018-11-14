classdef AbstractBuilder < mlpipeline.RootBuilder & mlpipeline.IBuilder
	%% ABSTRACTDATABUILDER  

	%  $Revision$
 	%  was created 01-Feb-2017 22:41:34
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.1.0.441655 (R2016b) for MACI64.  Copyright 2017 John Joowon Lee.
 	

	properties
 		keepForensics 
    end
    
    properties (Dependent)
        buildVisitor
        finished
        ignoreFinishfile     % KLUDGE to configure finished
        neverTouchFinishfile %
        logger
        product        
 	end

	methods 
        
        %% GET/SET
        
        function g = get.buildVisitor(this)
            g = this.buildVisitor_;
        end
        function g = get.finished(this)
            g = this.finished_;
        end
        function g = get.ignoreFinishfile(this)
            if (~isempty(this.finished_))
                g = this.finished_.ignoreFinishfile;
            end
        end
        function g = get.neverTouchFinishfile(this)
            if (~isempty(this.finished_))
                g = this.finished_.neverTouchFinishfile;
            end
        end
        function g = get.logger(this)
            g = this.logger_;
        end 
        function g = get.product(this)
            g = this.product_;
        end
        
        function this = set.buildVisitor(this, v)
            assert(~isempty(v));
            this.buildVisitor_ = v;
        end
        function this = set.finished(this, s)
            assert(isa(s, 'mlpipeline.Finished'));
            this.finished_ = s;
        end
        function this = set.ignoreFinishfile(this, s)
            assert(islogical(s));
            if (~isempty(this.finished_))
                this.finished_.ignoreFinishfile = s;
            end
        end
        function this = set.neverTouchFinishfile(this, s)
            assert(islogical(s));
            if (~isempty(this.finished_))
                this.finished_.neverTouchFinishfile = s;
            end
        end
        
        %%
        
        function g    = getLogPath(this)
            %% may be overridden
            
            assert(~isempty(this.logger), ...
                'mlpipeline:RuntimeError', ...
                'AbstractBuilder.getLogPath:  this.prepareLogger may have failed');
            g = this.logger.filepath;
        end  
        function this = setLogPath(this, s)
            %% may be overridden
            
            assert(~isempty(this.logger), ...
                'mlpipeline:RuntimeError', ...
                'AbstractBuilder.setLogPath:  this.prepareLogger may have failed');
            this.logger.filepath = s;
        end
        function g    = getNeverTouch(this)
            %% may be overridden
            
            g = this.finished_.neverTouchFinishfile;            
        end
        function this = setNeverTouch(this, s)
            %% may be overridden
            
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
            
            if (isempty(obj))
                tf = false; 
                return
            end
            tf  = true; 
            msg = '';
            if (~isa(obj, class(this)))
                tf  = false;
                msg = sprintf('class(this)-> %s but class(compared)->%s', class(this), class(obj));
            end
            if (~tf)
                warning('mlpipeline:classesequal:mismatchedClass', msg);
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
            %% UPDATEFINISHED, the protected superclass property which is an mlpipeline.Finished
            %  @param tag containing information such as this.session.tracerRevision, class(this).
            %  @param tag2.
            %  @param neverTouchFinishfile is boolean.
            %  @param ignoreFinishfile is boolean.
            %  @return property this.finished instantiated with path, tags, the booleans.
            
            ip = inputParser;
            addParameter(ip, 'tag', sprintf('%s_%s', lower(this.session.tracerRevision('typ','fp')), class(this)), @ischar);
            addParameter(ip, 'tag2', '', @ischar);
            addParameter(ip, 'neverTouchFinishfile', false, @islogical);
            addParameter(ip, 'ignoreFinishfile', false, @islogical);
            parse(ip, varargin{:});
            
            ensuredir(this.getLogPath);
            this.finished_ = mlpipeline.Finished(this, ...
                'path', this.getLogPath, ...
                'tag', [ip.Results.tag ip.Results.tag2], ...
                'neverTouchFinishfile', ip.Results.neverTouchFinishfile, ...
                'ignoreFinishfile', ip.Results.ignoreFinishfile);
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
                this.product_.filesuffix = '.4dfp.hdr';
            end
        end
        
        function this = AbstractBuilder(varargin)
            %% ABSTRACTDATABUILDER
            %  @param named logger is an mlpipeline.AbstractLogger.
            %  @param named buildVisitor.
            %  @param named logger is mlpipeline.ILogger.
            %  @param named logPath is char; will be created as needed.
            %  @param named keepForensics is logical.
            %  @param named ignoreFinishfile is logical.
            %  @param named neverTouchFinishfile is logical.
            %  @param named product is the initial state of the product to build; default := [].
            
 			ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'buildVisitor',  mlfourdfp.FourdfpVisitor);
            addParameter(ip, 'logger', mlpipeline.Logger, @(x) isa(x, 'mlpipeline.ILogger'));
            addParameter(ip, 'logPath', fullfile(pwd, 'Log', ''), @ischar); % See also prepareLogger.
            addParameter(ip, 'keepForensics', false, @islogical);
            addParameter(ip, 'ignoreFinishfile', false, @islogical);
            addParameter(ip, 'neverTouchFinishfile', false, @islogical);
            addParameter(ip, 'product', []);
            parse(ip, varargin{:});
            
            if (this.receivedCtor(varargin{:}))
                this = this.copyCtor(varargin{:});
                return
            end
            this.buildVisitor_        = ip.Results.buildVisitor;
            this                      = this.prepareLogger(ip.Results);
            this.keepForensics        = ip.Results.keepForensics;
            this.ignoreFinishfile     = ip.Results.ignoreFinishfile;     
            this.neverTouchFinishfile = ip.Results.neverTouchFinishfile;  
            this.product_             = ip.Results.product;       
        end
    end
    
    %% PROTECTED
    
    properties (Access = protected)
        buildVisitor_
        finished_
        logger_
        product_
    end
    
    methods (Access = protected)
        function this = copyCtor(this, varargin)
            aCopy = varargin{1};
            this.buildVisitor_ = aCopy.buildVisitor_;
            this.logger_ = aCopy.logger;
            this.keepForensics = aCopy.keepForensics;
            this.ignoreFinishfile = aCopy.ignoreFinishfile;
            this.neverTouchFinishfile = aCopy.neverTouchFinishfile;
            this.finished_ = aCopy.finished;
            this.product_ = aCopy.product_;
        end
        function this = prepareLogger(this, ipr)
            this.logger_ = ipr.logger;
            ensuredir(ipr.logPath);
            this.logger_.fqfilename = fullfile( ...
                ipr.logPath, ...
                strrep(sprintf('%s_prepareLogging_D%s', class(this), datestr(now,30)), '.', '_'));
        end
        function tf   = receivedCtor(~, varargin)
            tf = (1 == length(varargin)) && ...
                 isa(varargin{1}, 'mlpipeline.AbstractBuilder');
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

