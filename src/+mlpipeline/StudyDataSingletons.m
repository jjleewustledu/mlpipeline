classdef StudyDataSingletons < handle
	%% STUDYDATASINGLETONS  

	%  $Revision$
 	%  was created 21-Jan-2016 13:53:38
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

    methods (Static)
        function this = instance(name)
            persistent instance_
            assert(exist('name','var'));
            if (isempty(instance_))
                instance_ = mlpipeline.StudyDataSingletons.lookup(name);
            end
            this = instance_;
        end
        function register(name, asingleton)
            h = mlpipeline.StudyDataSingletons.studyDataStorage_;
            if (isempty(h.registry))
                h.registry = containers.Map;
            end
            h.registry(name) = asingleton;
        end
    end
    
    %% PROTECTED
    
    methods (Static, Access = protected)        
        function asingleton = lookup(name)
            try
                ctor = mlpipeline.StudyDataSingleton;
                h = ctor.studyDataStorage_;
                asingleton = h.registry(name);
            catch %#ok<CTCH>
                asingleton = [];
            end
        end
    end
    
    %% PRIVATE
    
	properties (Constant, Access = private)
 		studyDataStorage_ = mlpipeline.StudyDataStorage;
    end
    
    methods (Access = private)
 		function this = StudyDataSingletons()
            mlarbelaez.StudyDataSingleton.register;
            mlderdeyn.StudyDataSingleton.register;
            mlraichle.StudyDataSingleton.register;
 		end
 	end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

