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
        function this = set.sessionData(this, s)
            assert(isa(s, 'mlpipeline.SessionData'));
            this.sessionData_ = s;
        end
        
        %%
        
        function g    = getNeverTouch(this)
            g = this.finished_.neverTouch;            
        end
        function this = setNeverTouch(this, s)
            assert(islogical(s));
            this.finished_.neverTouch = s;
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
            if (isempty(this.finished))
                tf = false; 
                return
            end
            tf = this.finished.isfinished;
        end                
        function this = updateFinished(this, varargin)
            ip = inputParser;
            addParameter(ip, 'tag', ...
                sprintf('updateFinished_%s', lower(this.sessionData.sessionFolder)), ...
                @ischar);
            addParameter(ip, 'tag2', '', @ischar);
            parse(ip, varargin{:});
            
            this.finished_ = mlpipeline.Finished(this, ...
                'path', this.logger.filepath, 'tag', sprintf('%s%s', ip.Results.tag, ip.Results.tag2));
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
            parse(ip, varargin{:});
            
            %% invoke copy-ctor
            
            if (1 == nargin && isa(varargin{1}, 'mlpipeline.AbstractDataBuilder'))
                aCopy = varargin{1};
                this.logger_ = aCopy.logger;
                this.product_ = aCopy.product_;
                this.sessionData_ = aCopy.sessionData_;
                this.buildVisitor_ = aCopy.buildVisitor_;
                this.keepForensics = aCopy.keepForensics;
                this.finished_ = aCopy.finished;
                return
            end
            
            %% manage parameters             
            
            this.logger_       = ip.Results.logger;
            this.product_      = ip.Results.product;
            this.sessionData_  = ip.Results.sessionData;
            this.buildVisitor_ = ip.Results.buildVisitor;
            this.keepForensics = ip.Results.keepForensics;
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

