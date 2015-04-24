classdef PipelineRegistry < mlpatterns.Singleton
	%% PIPELINEREGISTRY is a singleton design pattern	
    %  N.B. environment variables:
    %       DEBUG, LOGGING, MLUNIT_TESTING, VERBOSE, VERBOSITY;
    %       true == MLUNIT_TESTING eliminates verbosity.
    %
	%  Version $Revision: 2582 $ was created $Date: 2013-08-29 02:58:43 -0500 (Thu, 29 Aug 2013) $ by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2013-08-29 02:58:43 -0500 (Thu, 29 Aug 2013) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/src/+mlpipeline/trunk/PipelineRegistry.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: PipelineRegistry.m 2582 2013-08-29 07:58:43Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

	properties 
        debugging 
        deprecationSeverity
        logging
    end 
    
    properties (Dependent)
        verbosity
        warningLevel
        verbose
    end

	methods %% set/get
        function tf   = get.debugging(this) 
            tf = this.parseTruthvalue(getenv('DEBUG'));
        end
        function tf   = get.logging(this) 
            tf = this.parseTruthvalue(getenv('LOGGING')) && ...
                ~this.parseTruthvalue(getenv('MLUNIT_TESTING'));
        end
        function tf   = get.verbose(this)
            %% GET.VERBOSE returns a logical value based on debugging and verbosity settings
            
            if (this.parseTruthvalue(getenv('MLUNIT_TESTING')))
                tf = false; return; end
            tf = this.debugging || this.verbosity > 0 || this.warningLevel > 0;
        end            
        function this = set.verbosity(this,v)
            this.verbosity_ = this.checkValueRange(v, [0 1]);
        end 
        function v    = get.verbosity(this)
            if (this.parseTruthvalue(getenv('MLUNIT_TESTING')))
                v = eps; return; end
            if (isempty(this.verbosity_))
                v = this.getenvVerbosity; end
        end
        function this = set.warningLevel(this, w)
            this.warningLevel_ = this.checkValueRange(w, [0 1]);
        end
        function wl   = get.warningLevel(this)
            if (this.parseTruthvalue(getenv('MLUNIT_TESTING')))
                wl = eps; return; end
            if (isempty(this.warningLevel_));
                wl = this.getenvWarningLevel; end
        end
    end
    
    methods (Static) 
        function this = instance(qualifier)
            
            %% INSTANCE uses string qualifiers to implement registry behavior that
            %  requires access to the persistent uniqueInstance
            persistent uniqueInstance
            
            if (exist('qualifier','var') && ischar(qualifier))
                if (strcmp(qualifier, 'initialize'))
                    uniqueInstance = [];
                end
            end
            
            if (isempty(uniqueInstance))
                this = mlpipeline.PipelineRegistry();
                uniqueInstance = this;
            else
                this = uniqueInstance;
            end
        end
    end 
    
    %% PRIVATE
    
    properties (Access = 'private')
        verbosity_
        warningLevel_
    end
    
    methods (Access = 'private')
 		function this = PipelineRegistry()
 			this = this@mlpatterns.Singleton;
            this.deprecationSeverity = 'error';
 		end % PipelineRegistry (ctor)
        function v    = getenvVerbosity(this)
            if (isempty(getenv('VERBOSITY')))
                if (isempty(getenv('VERBOSE')))
                    v = 0;
                    return
                else
                    v = this.parseTruthvalue(getenv('VERBOSE'));
                    return
                end
            else
                v = str2double(getenv('VERBOSITY'));
            end
        end
        function wl   = getenvWarningLevel(~)
            if (isempty(getenv('WARNING_LEVEL')))
                wl = 0;
                return
            else
                wl = str2double(getenv('WARNING_LEVEL'));
            end
        end
        function val  = checkValueRange(~, val, rng)
            assert(isnumeric(val));
            assert(2 == length(rng));
            if (val < rng(1))
                val = rng(1); end
            if (val > rng(2))
                val = rng(2); end
        end
        function tf   = parseTruthvalue(~, tf) 
            if (any(isnan(tf)))
                tf = false; return; end
            if (isempty(tf))
                tf = false; return; end
            if (islogical(tf))
                return; end
            if (ischar(tf))
                if (strcmpi('true',tf) || strcmpi('t', tf) || strcmp('1', tf))
                    tf = true; return; end
                tf = false; 
            end
            tf = logical(tf);
        end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
 end 
