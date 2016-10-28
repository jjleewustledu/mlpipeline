classdef StudyDataHandle < handle
	%% StudyDataHandle defines the interface for mlpipeline.StudyData, mlpipeline.StudyDataSingleton

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
        comments
    end
    
    methods (Static, Abstract)
        d   = freesurfersDir
        im  = imagingType(typ, obj)
        tf  = isImagingType(t)
        tf  = isLocationType(t)
        loc = locationType(typ, loc0)
        d   = RawDataDir
        d   = rawdataDir
        d   = subjectsDir
    end
    
    methods (Abstract)
        iter = createIteratorForSessionData(this)
               diaryOff(~)
               diaryOn(this, ~)
        loc  = loggingLocation(this, ~)
        this = replaceSessionData(this, ~)
        loc  = saveWorkspace(this, ~)
        sess = sessionData(~)
        f    = subjectsDirFqdns(this)        
    end
    
    methods (Abstract, Access = protected)
        this = assignSessionDataCompositeFromPaths(this, ~)
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

