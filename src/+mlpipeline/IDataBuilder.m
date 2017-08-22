classdef (Abstract) IDataBuilder 
	%% IDATABUILDER specifies an interface for builder design patterns for mlpipeline classes.
    %  @param keeForensics is logical.
    %  @param logger is a logging object, e.g., mlpipeline.AbstractLogger.
    %  @param product is, e.g., mlfourd.ImagingContext.
    %  @param sessionData is, e.g., mlpipeline.SessionData.
    %  @param studyData is, e.g., mlpipleline.StudyData.

	%  $Revision$
 	%  was created 06-Jan-2017 18:01:12
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.1.0.441655 (R2016b) for MACI64.
 	

	properties (Abstract)
 		keepForensics
        logger
        product        
        sessionData
        studyData
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

