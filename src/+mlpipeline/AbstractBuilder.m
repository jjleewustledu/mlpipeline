classdef (Abstract) AbstractBuilder < mlpipeline.IBuilder
	%% ABSTRACTBUILDER implements interface IBuilder, adding utilities for checking object equivalence,
    %  assessing whether building is finished, and packaging the built product.

	%  $Revision$
 	%  was created 01-Feb-2017 22:41:34
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.1.0.441655 (R2016b) for MACI64.  Copyright 2017 John Joowon Lee.
 	
    properties (Dependent)
        buildVisitor
        finished
        ignoreFinishMark % KLUDGE
        keepForensics
        neverMarkFinished % KLUDGE
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
        function g = get.ignoreFinishMark(this)
            g = this.finished_.ignoreFinishMark;
        end
        function g = get.keepForensics(~)
            g = mlpipeline.ResourcesRegistry.instance().keepForensics;
        end
        function g = get.neverMarkFinished(this)
            g = this.finished_.neverMarkFinished;
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
        function this = set.ignoreFinishMark(this, s)
            assert(islogical(s));
            assert(~isempty(this.finished_));
            this.finished_.ignoreFinishMark = s;
        end
        function this = set.keepForensics(this, s)
            assert(islogical(s));
            inst = mlpipeline.ResourcesRegistry.instance();
            inst.keepForensics = s;            
        end
        function this = set.neverMarkFinished(this, s)
            assert(islogical(s));
            assert(~isempty(this.finished_));
            this.finished_.neverMarkFinished = s;
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
            ensuredir(s);
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
            if (isempty(this.finished) || this.ignoreFinishMark)
                tf = false; 
                return
            end
            tf = this.finished.isfinished;
            this.logger_.add(sprintf('%s is finished building %s', class(this), evalc('disp(this.product_)')));
        end    
        function this = updateFinished(this, varargin)
            %% UPDATEFINISHED, the protected superclass property which is an mlpipeline.Finished
            %  @param path.
            %  @param tag.
            %  @return property this.finished instantiated with path, tags, the booleans.
            
            ip = inputParser;
            addParameter(ip, 'path', this.getLogPath, @isfolder);
            addParameter(ip, 'tag', this.productTag, @ischar);
            parse(ip, varargin{:});
            
            ensuredir(this.getLogPath);
            this.finished_ = mlpipeline.Finished(this, ...
                'path', ip.Results.path, ...
                'tag',  ip.Results.tag);
        end    
        function this = packageProduct(this, prod, varargin)
            %  @param required prod, an objects understood by mlfourd.ImagingContext2.
            %  @param imagingContext is logical => packages mlfourd.ImagingContext2.
            %  @return this.product packaged as an ImagingContext2 if nontrivial; otherwise this.product := [].
            
            ip = inputParser;
            addParameter(ip, 'imagingContext', true, @islogical);
            parse(ip, varargin{:});
            
            if (isempty(prod))
                this.product_ = [];
                return
            end
            if (iscell(prod))
                this.product_ = prod;
                return
            end
            if (~ip.Results.imagingContext)
                if (isa(prod, 'mlpipeline.AbstractHandleBuilder') && length(prod) > 1)
                    this.product_ = [];
                    for p = 1:length(prod)
                        this.product_(p) = prod(p);
                    end
                end
                return
            end
            if (isa(prod, 'mlpipeline.AbstractBuilder') && length(prod) > 1)
                for p = 1:length(prod)
                    prod(p) = mlfourd.ImagingContext2(prod(p));
                    if (lstrfind(prod(p).filesuffix, '4dfp'))
                        prod(p).filesuffix = '.4dfp.hdr';
                    end
                end
                this.product_ = prod;
                return
            end            
            this.product_ = mlfourd.ImagingContext2(prod);
            if (lstrfind(this.product_.filesuffix, '4dfp'))
                this.product_.filesuffix = '.4dfp.hdr';
            end
        end
        
        function this = AbstractBuilder(varargin)
            %% ABSTRACTBUILDER
            %  @param named buildVisitor.
            %  @param named logPath is char; will be created as needed.
            %  @param named logger is mlpipeline.ILogger.
            %  @param named product is the initial state of the product to build; default := [].
            
 			ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'buildVisitor',  mlfourdfp.FourdfpVisitor);
            addParameter(ip, 'logPath', fullfile(pwd, 'Log', ''), @ischar); % See also prepareLogger.
            addParameter(ip, 'logger', mlpipeline.Logger(fullfile(pwd, 'Log', '')), @(x) isa(x, 'mlpipeline.ILogger'));
            addParameter(ip, 'product', []);
            parse(ip, varargin{:});
            
            this.buildVisitor_ = ip.Results.buildVisitor;
            this               = this.prepareLogger(ip.Results);
            this.product_      = ip.Results.product;            
            this.finished_     = mlpipeline.Finished(this, 'path', this.getLogPath, 'tag', this.productTag);
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
        function this = prepareLogger(this, ipr)
            ensuredir(ipr.logPath);
            this.logger_ = ipr.logger;
            this.logger_.fqfileprefix = fullfile( ...
                ipr.logPath, ...
                sprintf('%s_prepareLogger_%s', myclass(this), mydatetimestr(now)));
            this.logger_.add(evalc('disp(this.logger_)'));
        end
        function t    = productTag(this)
            t = myclass(this);
            p = this.product_;
            if (isempty(p))
                return
            end
            t = [t '_' myclass(p)];
            if (~isprop(p, 'fileprefix'))
                return
            end
            t = [t '_' p.fileprefix];
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

