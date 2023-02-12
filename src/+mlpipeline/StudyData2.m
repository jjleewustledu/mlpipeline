classdef (Abstract) StudyData2 < handle & mlpipeline.ImagingData & mlpipeline.IStudyData2
	%% STUDYDATA2 organizes a scientifically coherent study.  
    %  Since studies can have diverse study data structure, this abstraction doesn't use
    %  mlpipeline.PipelineData.
    %
	%  $Revision$
 	%  was created 21-Jan-2016 15:29:29
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	    
    properties (Dependent)
        registry
    end
    
    methods % GET
        function g = get.registry(this)
            g = this.registry_;
        end
    end

	methods                 
 		function this = StudyData2(mediator, reg)
            arguments
                mediator mlpipeline.ImagingMediator {mustBeNonempty}
                reg mlpipeline.StudyRegistry {mustBeNonempty}
            end
            this = this@mlpipeline.ImagingData(mediator)
            this.registry_ = reg;
        end 
    end

    %% PROTECTED

    properties (Access = protected)
        registry_
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
end
