classdef StudyDataSingletons < handle
	%% STUDYDATASINGLETONS  

	%  $Revision$
 	%  was created 21-Jan-2016 13:53:38
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

    properties (Dependent)
        length
        registry
    end
    
    methods %% GET
        function g = get.length(this) %#ok<MANU>
            ctor = mlpipeline.StudyDataSingletons;
            h = ctor.studyDataStorage_;
            if (isempty(h.registry))
                g = 0; 
                return
            end
            g = h.registry.length;
        end
        function g = get.registry(this) %#ok<MANU>
            ctor = mlpipeline.StudyDataSingletons;
            h = ctor.studyDataStorage_;
            if (isempty(h.registry))
                g = []; 
                return
            end
            g = h.registry;
        end
    end
    
    methods (Static)
        function this = instance(varargin)
            %% NAME
            %  @param name is 'arbelaez', 'derdeyn', 'raichle' or similar name for an mlpipeline.StudyDataSingleton.
            %  @returns a specific mlpipeline.StudyDataSingleton.
            %  @throws mlpipeline:unsupportedEmptyState
            
            persistent instance_
%             mlderdeyn.StudyDataSingleton.instance;
%             mlderdeyn.TestDataSingleton.instance;
%             mlarbelaez.StudyDataSingleton.instance;
%             mlarbelaez.TestDataSingleton.instance;
%             mlpowers.StudyDataSingleton.instance;
%             mlpowers.TestDataSingleton.instance;
            mlraichle.StudyDataSingleton.instance;
            mlraichle.SynthDataSingleton.instance;
            mlraichle.TestDataSingleton.instance;            
            if (~isempty(varargin))
                this = mlpipeline.StudyDataSingletons.lookup(varargin{:});
                return
            end
            if (isempty(instance_))
                instance_ = mlpipeline.StudyDataSingletons;
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
        end
    end
    
    %% PROTECTED
    
    methods (Static, Access = protected)
        function asingleton = lookup(varargin)
            ip = inputParser;
            addRequired(ip, 'name', @ischar);
            parse(ip, varargin{:});
            try
                ctor = mlpipeline.StudyDataSingletons;
                h = ctor.studyDataStorage_;
                asingleton = h.registry(ip.Results.name);
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

