classdef Test_Reporter < TestCase 
	%% TEST_REPORTER 
	%  Usage:  >> runtests tests_dir  
 	%          >> runtests Test_Reporter % in . or the matlab path 
 	%          >> runtests Test_Reporter:test_nameoffunc 
 	%          >> runtests(Test_Reporter, Test_Class2, Test_Class3, ...) 
 	%  See also:  package xunit%  Version $Revision: 1628 $ was created $Date: 2012-08-23 23:10:37 -0500 (Thu, 23 Aug 2012) $ by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2012-08-23 23:10:37 -0500 (Thu, 23 Aug 2012) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/test/+mlpipeline_xunit/trunk/Test_Reporter.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: Test_Reporter.m 1628 2012-08-24 04:10:37Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

	properties 
 		% N.B. (Abstract, Access=private, GetAccess=protected, SetAccess=protected, ... 
 		%       Constant, Dependent, Hidden, Transient) 
 	end 

	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

 		function test_(this) 
 			%% TEST_  
 			%  Usage:   
 			import mlpipeline.*; 
 		end % test_ 
 		function this = Test_Reporter(varargin) 
 			this = this@TestCase(varargin{:}); 
 		end % Test_Reporter (ctor) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

