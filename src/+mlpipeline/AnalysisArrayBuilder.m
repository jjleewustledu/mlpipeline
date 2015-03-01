classdef AnalysisArrayBuilder 
	%% ANALYSISARRAYBUILDER is a builder design pattern that builds Matlab arrays for data mining%  Version $Revision: 1604 $ was created $Date: 2012-08-23 23:09:13 -0500 (Thu, 23 Aug 2012) $ by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2012-08-23 23:09:13 -0500 (Thu, 23 Aug 2012) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/src/+mlpipeline/trunk/AnalysisArrayBuilder.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: AnalysisArrayBuilder.m 1604 2012-08-24 04:09:13Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

	properties 
 		% N.B. (Abstract, Access=private, GetAccess=protected, SetAccess=protected, ... 
 		%       Constant, Dependent, Hidden, Transient) 
 	end 

	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

 		function this = AnalysisArrayBuilder() 
 			%% ANALYSISARRAYBUILDER 
 			%  Usage:  prefer static creation methods 
 		end % AnalysisArrayBuilder (ctor) 
 		function afun() 
 			%% AFUN  
 			%  Usage:   
 		end % afun 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

