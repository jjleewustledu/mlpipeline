classdef Test_SessionContext < matlab.unittest.TestCase
	%% TEST_SESSIONCONTEXT 

	%  Usage:  >> results = run(mlpipeline_unittest.Test_SessionContext)
 	%          >> result  = run(mlpipeline_unittest.Test_SessionContext, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 28-May-2018 21:48:41 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/test/+mlpipeline_unittest.
 	%% It was developed on Matlab 9.4.0.813654 (R2018a) for MACI64.  Copyright 2018 John Joowon Lee.
 	
	properties
 		registry
 		testObj
 	end

	methods (Test)
		function test_afun(this)
 			import mlpipeline.*;
 			this.assumeEqual(1,1);
 			this.verifyEqual(1,1);
 			this.assertEqual(1,1);
 		end
	end

 	methods (TestClassSetup)
		function setupSessionContext(this)
 			import mlpipeline.*;
 			this.testObj_ = SessionContext;
 		end
	end

 	methods (TestMethodSetup)
		function setupSessionContextTest(this)
 			this.testObj = this.testObj_;
 			this.addTeardown(@this.cleanTestMethod);
 		end
	end

	properties (Access = private)
 		testObj_
 	end

	methods (Access = private)
		function cleanTestMethod(this)
 		end
	end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end
