classdef ImproperParfor 
	%% IMPROPERPARFOR executes parfor in clusters sized to the avilable matlabpool
	%  Version $Revision$ was created $Date$ by $Author$, 
 	%  last modified $LastChangedDate$ and checked into svn repository $URL$
 	%  Developed on Matlab 7.14.0.739 (R2012a)
 	%  $Id$
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	
    properties
        debugging = true;
        poolname  = 'local';
        numLabs
        numLoops
        caIn
        caOut
        fhandle
    end 	

	methods (Static)
        
        function runImproperParfor(caIn, varargin)
            %% RUNIMPROPERPARFOR runs parfor over the passed cell-array
            %  ImproperParfor.runImproperParfor(cell_array_of_args[, function_handle, matlab_pool_profile])
            
            this = mlpipeline.ImproperParfor(caIn, varargin{:});
            this.runProperParfor;
            this.runRemainderParfor;
        end
        function nlabs = ensuredMatlabpoolSize(poolname)
            if (exist('poolname', 'var'))   
                if (0 ~= matlabpool('size'))
                    matlabpool('close','force');
                end
                matlabpool(poolname);
            end
            if (0 == matlabpool('size'))
                matlabpool;
            end
            nlabs = matlabpool('size');
        end
    end % static methods
    
    methods        
        
        function runProperParfor(this)
            for m = 1:this.numLoops
                caGroup = this.caIn(this.loopingWindow(m));
                parfor pm = 1:this.numLabs
                    if (this.debugging); fprintf('(m,pm,caGroup{pm})->%i,%i', m, pm); end %#ok<*PFBNS>
                    this.fhandle(caGroup{pm});
                end
            end
        end
        function runRemainderParfor(this)
            caGroup = this.caIn(this.numLabs*this.numLoops+1:end);
            parfor pm = 1:length(caGroup)
                if (this.debugging); fprintf('(~,pm,caGroup{pm})->~,%i', pm); end
                this.fhandle(caGroup{pm});
            end
        end
        function rng = loopingWindow(this, windowIdx)
            window1   = this.numLabs*(windowIdx - 1) + 1;
            windowEnd = this.numLabs* windowIdx;
            rng       = window1:windowEnd;
        end            
 		function this = ImproperParfor(caIn, varargin)
 			%% PARLOOPER 
 			%  Usage:  prefer creation methods 

            import mlpipeline.*;
            assert(iscell(caIn));
            this.caIn     = caIn;
            this.caOut    = cell(caIn);
            this.fhandle  = @(x) fprintf(',%s\n', x);
            this.numLabs  = ImproperParfor.ensuredMatlabpoolSize;
            this.numLoops = floor(length(caIn)/this.numLabs);
            if (~isempty(varargin))
                assert(isa(varargin{1}, 'function_handle'));
                this.fhandle = varargin{1};
            end
            if (length(varargin) > 1)
                assert(ischar(varargin{2}));
                this.poolname = varargin{2};
            end
 		end %  ctor
    end % methods

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

