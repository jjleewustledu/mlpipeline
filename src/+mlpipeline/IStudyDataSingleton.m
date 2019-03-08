classdef IStudyDataSingleton
	%% ISTUDYDATASINGLETON  

	%  $Revision$
 	%  was created 08-Jun-2016 17:02:09
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.341360 (R2016a) for MACI64.
 	
    properties (Constant)
        LOCATION_TYPES = {'folder' 'path'}
        IMAGING_TYPES  = { ...
            'filename' 'fn' 'fqfilename' 'fqfn' 'fileprefix' 'fp' 'fqfileprefix' 'fqfp' ...
            'folder' 'path' 'ext' 'imagingContext'}
    end

	properties (Abstract)
        subjectsDir
    end
    
    methods (Static, Abstract)
        instance(qualifier)
        register(varargin)
    end
    
    methods (Abstract)
        iter = createIteratorForSessionData(this)
               diaryOff(this)
               diaryOn(this)
               saveWorkspace(this)
        sess = sessionData(~)
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

