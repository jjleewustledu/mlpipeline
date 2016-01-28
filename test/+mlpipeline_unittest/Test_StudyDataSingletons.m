classdef Test_StudyDataSingletons < matlab.unittest.TestCase
	%% TEST_STUDYDATASINGLETONS 

	%  Usage:  >> results = run(mlpipeline_unittest.Test_StudyDataSingletons)
 	%          >> result  = run(mlpipeline_unittest.Test_StudyDataSingletons, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 27-Jan-2016 15:41:13
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/test/+mlpipeline_unittest.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

	properties
 		registry
        derdeyn
 		testObj
 	end

	methods (Test)
        function test_initialize(this)
            import mlpipeline.*;
            sds = StudyDataSingletons.instance('initialize');
            this.verifyTrue(isempty(sds), 'mlpipeline.StudyDataSingletons');
            this.verifyError(@StudyDataSingletons.instance, 'mlpipeline:unsupportedEmptyState');
        end
		function test_persistentInstance(this)
            this.verifyEqual(this.testObj.comments, 'setupStudyDataSingletons');
            
            sds = mlpipeline.StudyDataSingletons.instance('derdeyn');
            this.verifyEqual(sds.comments, 'setupStudyDataSingletons');
            sds.comments = 'test_persistentInstance';
            this.verifyEqual(this.testObj.comments, 'test_persistentInstance');
            
 		end
		function test_derdeyn(this)
 		end
		function test_updateDerdeyn(this)
            this.derdeyn.comments = 'test_updateDerdeyn';
            this.verifyEqual(this.testObj.comments, 'test_updateDerdeyn');
 		end
		function test_noReregistration(this)
 		end
		function test_(this)
 		end
	end

 	methods (TestClassSetup)
		function setupStudyDataSingletons(this)
 			import mlpipeline.*;
            this.derdeyn = mlderdeyn.StudyDataSingleton.instance('initialize');
            this.derdeyn.comments = 'setupStudyDataSingletons';
 			this.testObj = StudyDataSingletons.instance('derdeyn');
 		end
	end

 	methods (TestMethodSetup)
		function setupStudyDataSingletonsTest(this)
 		end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

