classdef (Abstract) StudyDataHandle < handle
	%% StudyDataHandle defines the interface for mlpipeline.StudyData, mlpipeline.StudyDataSingleton.

	%  $Revision$
 	%  was created 08-Jun-2016 17:02:09
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.341360 (R2016a) for MACI64.
 	

	properties (Abstract)
        comments
        subjectsDir
    end
    
    methods (Abstract)
        iter = createIteratorForSessionData(this)
               diaryOff(this)
               diaryOn(this)
        d    = freesurfersDir(this)
        loc  = loggingLocation(this)
        d    = rawdataDir(this)
        this = replaceSessionData(this)
        loc  = saveWorkspace(this)
        sess = sessionData(this)
    end
    
    methods (Abstract, Access = protected)
        this = assignSessionDataCompositeFromPaths(this)
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

