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
            %% NAME
            %  @param name is 'arbelaez', 'derdeyn', 'raichle' or similar name for an mlpipeline.StudyDataSingleton.
            %  @return a specific mlpipeline.StudyDataSingleton.
            %  @throws mlpipeline:unsupportedEmptyState
            
            persistent instance_
            if (exist('name','var'))
                assert(ischar(name));
                if (strcmp(name, 'initialize'))
                    instance_ = [];
                    this = instance_;
                    return
                end
                mlarbelaez.StudyDataSingleton.register;
                mlarbelaez.TestDataSingleton.register;
                mlderdeyn.StudyDataSingleton.register;
                mlderdeyn.TestDataSingleton.register;
                mlraichle.StudyDataSingleton.register;
                mlraichle.TestDataSingleton.register;
                mlpowers.StudyDataSingleton.register;
                mlpowers.TestDataSingleton.register;
                instance_ = mlpipeline.StudyDataSingletons.lookup(name);
            end
            if (isempty(instance_))
                error('mlpipeline:unsupportedEmptyState', ...
                     ['StudyDataSingletons.instance requires an initial choice of concrete StudyDataSingle; ' ...
                      'persistent instance is empty.']);
            end
            this = instance_;
        end
        function register(name, asingleton)
            %% REGISTER
            %  @param name will be used to look up the registered instance of asingleton.
            %  @param asingleton is any instance of any mlpipeline.StudyDataSingleton.
            
            h = mlpipeline.StudyDataSingletons.studyDataStorage_;
            if (isempty(h.registry))
                h.registry = containers.Map;
            end
            h.registry(name) = asingleton; % h.registry is modifiable over lifetime of StudyDataSingletons
                                           % via any StudyDataSingleton.register operation.
        end
    end
    
    %% PROTECTED
    
    methods (Static, Access = protected)        
        function asingleton = lookup(name)
            try
                ctor = mlpipeline.StudyDataSingletons;
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
 		end
 	end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

