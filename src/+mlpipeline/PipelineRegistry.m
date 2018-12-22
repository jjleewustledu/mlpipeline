classdef PipelineRegistry < handle
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
        deprecationSeverity = 'error'
        logging
        verbosity
        warningLevel
        verbose
    end

	methods %% set/get
        function tf = get.debugging(this) 
            tf = this.parseTruthvalue(getenv('DEBUGGING'));
        end
        function tf = get.logging(this) 
            tf = this.parseTruthvalue(getenv('LOGGING'));
        end
        function v  = get.verbosity(this)
            v = this.getenvVerbosity;
        end
        function wl = get.warningLevel(this)
            wl = this.getenvWarningLevel;
        end
        function tf = get.verbose(this)
            %% GET.VERBOSE returns a logical value based on debugging and verbosity settings
            
            tf = this.debugging || this.verbosity > 0 || this.warningLevel > 0;
        end     
               
        function set.debugging(this,d)
            setenv('DEBUGGING', num2str(this.checkValueRange(d, [0 1])));
        end  
        function set.logging(this,lg)
            setenv('LOGGING', num2str(this.checkValueRange(lg, [0 1])));
        end  
        function set.verbosity(this,v)
            setenv('VERBOSITY', num2str(this.checkValueRange(v, [0 1])));
        end 
        function set.warningLevel(this, w)
            setenv('WARNING_LEVEL', num2str(this.checkValueRange(w, [0 1])));
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
    
    methods (Access = 'private')
 		function this = PipelineRegistry()
        end 
        
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
