classdef PipelineVisitorInterface  
	%% PIPELINEVISITORINTERFACE   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 

    properties (Constant)
        INTERIMAGE_TOKEN = mlchoosers.ImagingChoosersInterface.INTERIMAGE_TOKEN;
    end
    
	properties (Abstract)
 		 logged
         product
         sessionPath
         studyPath
         workPath
 	end 

	methods (Static, Abstract)
        cmd
        help
        view
        thisOnThatImageFilename
        thisOnThatXfmFilename
        thisOnThatDatFilename
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

