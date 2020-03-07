classdef (Abstract) StudyRegistry < handle & mlpatterns.Singleton2
	%% STUDYREGISTRY  

	%  $Revision$
 	%  was created 11-Jun-2019 19:29:37 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.5.0.1067069 (R2018b) Update 4 for MACI64.  Copyright 2019 John Joowon Lee.
 	
    properties     
        atlVoxelSize = 333   
        comments = ''
        noclobber = true
    end
    
	properties (Dependent)
        debug
        keepForensics
    end
    
    methods
        
        %% GET, SET
        
        function g = get.debug(~)
            g = mlpipeline.ResourcesRegistry.instance().debug;
        end
        function     set.debug(~, s)
            inst = mlpipeline.ResourcesRegistry.instance();
            inst.debug = s;          
        end
        function g = get.keepForensics(~)
            g = mlpipeline.ResourcesRegistry.instance().keepForensics;
        end
        
        %%        
        
        function tf  = isChpcHostname(~)
            [~,hn] = mlbash('hostname');
            tf = lstrfind(hn, 'gpu') || lstrfind(hn, 'node') || lstrfind(hn, 'login') || lstrfind(hn, 'cluster');
        end
    end

	methods (Access = protected)		  
 		function this = StudyRegistry(varargin)
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

