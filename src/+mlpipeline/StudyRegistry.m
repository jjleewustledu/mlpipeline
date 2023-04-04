classdef (Abstract) StudyRegistry < handle & mlpatterns.Singleton2
    %% STUDYREGISTRY
    %  
    %  Created 05-Feb-2023 01:07:28 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.13.0.2126072 (R2022b) Update 3 for MACI64.  Copyright 2023 John J. Lee.

    properties
        atlasTag
        blurTag = ''
        comments = ''
        Ddatetime0 % seconds
        defects
        dicomExtension = '.dcm'
        ignoredExperiments = {}
        noclobber = true
        normalizationFactor = 1
        numberNodes
        reconstructionMethod
        referenceTracer        
        scatterFraction = 0
        stableToInterpolation = true
        T % sec at the start of artery_interpolated used for model but not described by scanner frames
        tracer
        tracerList
        umapType
    end

    properties (Constant)
        PREFERRED_TIMEZONE = 'local'
    end

    properties (Dependent)
        earliestCalibrationDatetime
        tBuffer
    end

    methods % GET        
        function g = get.earliestCalibrationDatetime(~)
            %g = datetime(2015,1,1, 'TimeZone', 'local'); % accomodates sub-S33789
            g = datetime(2016,7,19, 'TimeZone', 'local');
        end
        function g = get.tBuffer(this)
            g = max(0, -this.Ddatetime0) + this.T;
        end
    end

    methods
    end

    methods (Static)
        function pth = sourcedataPathToDerivativesPath(pth)
            pth = strrep(pth, 'sourcedata', 'derivatives');
        end
        function sub = workpath2subject(pth)
            c = fileparts2cell(pth);
            msk = contains(c, 'sub-');
            sub = c(msk);
        end
    end
    
    %% PROTECTED

    properties (Access = protected)
        subjectsJson_
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
