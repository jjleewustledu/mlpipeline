classdef (Abstract) ImagingData < handle & matlab.mixin.Heterogeneous & matlab.mixin.Copyable
    %% IMAGINGDATA is the abstraction of colleague (widget) classes for a mediator design pattern.
    %  
    %  Created 06-Feb-2023 14:37:27 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.13.0.2126072 (R2022b) Update 3 for MACI64.  Copyright 2023 John J. Lee.
    
    methods (Abstract)
    end

    %%

    methods
        function changed(this) % calls mediator's imagingChanged()
            this.mediator_.imagingChanged(this);
        end

        function this = ImagingData(mediator)
            arguments
                mediator mlpipeline.ImagingMediator {mustBeNonempty}
            end
            this.mediator_ = mediator;
        end
    end
    
    %% PROTECTED

    properties (Access = protected)
        mediator_
    end

    methods (Access = protected)
    end

    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
