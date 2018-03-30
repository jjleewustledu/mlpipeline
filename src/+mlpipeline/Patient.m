classdef Patient 
	%% PATIENT is a container class for all data associated with a study-patient
	%  Version $Revision: 2612 $ was created $Date: 2013-09-07 19:15:39 -0500 (Sat, 07 Sep 2013) $ by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2013-09-07 19:15:39 -0500 (Sat, 07 Sep 2013) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/src/+mlpipeline/trunk/Patient.m $ 
 	%  Developed on Matlab 7.14.0.739 (R2012a) 
 	%  $Id: Patient.m 2612 2013-09-08 00:15:39Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

	properties 
        ptPaths
 		surferBuilder
 	end 

	methods (Static)
        function buildAllCorticalThicknesses
        end
    end % static methods
    
    methods
 		function this = Patient(spth, pid) 
 			%% PATIENT 
 			%  Usage:  prefer creation methods 

            dt = mlsystem.DirTool(fullfile(spth, [pid '*']));
            this.ptPaths = dt.fqdns;
            this.surferBuilder = mlsurfer.SurferBuilder.create;
 		end %  ctor 
    end
    
    properties (Access = 'private')
        surferProduct_
        roiProduct_
        corticalThicknesses_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

