classdef Test_SilentTests < TestCase
	%% TEST_SILENTTESTS 
	%  Usage:  >> runtests tests_dir 
	%          >> runtests mlpipeline.Test_SilentTests % in . or the matlab path
	%          >> runtests mlpipeline.Test_SilentTests:test_nameoffunc
	%          >> runtests(mlpipeline.Test_SilentTests, Test_Class2, Test_Class3, ...)
	%  See also:  package xunit

	%  Version $Revision$ was created $Date$ by $Author$, 
 	%  last modified $LastChangedDate$ and checked into svn repository $URL$
 	%  Developed on Matlab 7.14.0.739 (R2012a)
 	%  $Id$
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	properties
 		% N.B. (Abstract, Access=private, GetAccess=protected, SetAccess=protected, Constant, Dependent, Hidden, Transient)
 	end

	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

 		function test_(this) 
 			import mlpipeline.*; 
 		end 
 		function this = Test_SilentTests(varargin) 
 			this = this@TestCase(varargin{:}); 
        end % ctor 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

