classdef AnalysisBuilder 
	%% ANALYSISBUILDER is a builder design pattern for imaging analysis objects%  Version $Revision: 1605 $ was created $Date: 2012-08-23 23:09:13 -0500 (Thu, 23 Aug 2012) $ by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2012-08-23 23:09:13 -0500 (Thu, 23 Aug 2012) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/src/+mlpipeline/trunk/AnalysisBuilder.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: AnalysisBuilder.m 1605 2012-08-24 04:09:13Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

	properties 
 		% N.B. (Abstract, Access=private, GetAccess=protected, SetAccess=protected, ... 
 		%       Constant, Dependent, Hidden, Transient) 
 	end 

	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

 		function this = AnalysisBuilder() 
 			%% ANALYSISBUILDER 
 			%  Usage:  prefer using static creation methods 
 		end % AnalysisBuilder (ctor) 
 		function afun() 
 			%% AFUN  
 			%  Usage:   
 		end % afun 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

