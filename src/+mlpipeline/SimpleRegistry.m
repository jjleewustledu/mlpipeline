classdef SimpleRegistry < handle & mlpipeline.StudyRegistry
    %% line1
    %  line2
    %  
    %  Created 07-Mar-2023 00:00:31 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.13.0.2126072 (R2022b) Update 3 for MACI64.  Copyright 2023 John J. Lee.   
    
    properties
        tausMap % containers.Map containing keys := {TRACER, ...}, values := {tau1, tau2, ...}
        snakes % struct
    end

    methods (Static)
        function t = consoleTaus(tracer)
            reg = mlpipeline.SimpleRegistry.instance();
            assert(~isempty(reg.tausMap), 'mlpipeline.SimpleRegistry.consoleTaus')
            t = reg.tausMap(tracer);
        end 
        function this = instance(reset)
            arguments
                reset = []
            end
            persistent uniqueInstance
            if ~isempty(reset)
                uniqueInstance = [];
            end
            if (isempty(uniqueInstance))
                this = mlpipeline.SimpleRegistry();
                uniqueInstance = this;
            else
                this = uniqueInstance;
            end
        end
    end

    %% PRIVATE
    
	methods (Access = private)	
        function this = SimpleRegistry()
            this.atlasTag = 'on_T1w';
            this.reconstructionMethod = 'e7';
            this.referenceTracer = 'FDG';
            this.tracerList = {'fdg'};
            this.T = 0;
            this.umapType = 'ct';

            this.snakes.contractBias = 0;
            this.snakes.iterations = 200;
            this.snakes.smoothFactor = 1;
        end
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
