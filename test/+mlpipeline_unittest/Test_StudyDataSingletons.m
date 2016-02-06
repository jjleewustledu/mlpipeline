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
 	end

	methods (Test)
        function test_initialize(this)
            import mlpipeline.*;
            sdss = StudyDataSingletons.instance('initialize');
            this.verifyTrue(isempty(sdss), 'mlpipeline.StudyDataSingletons');
            this.verifyError(@StudyDataSingletons.instance, 'mlpipeline:unsupportedEmptyState');
        end
		function test_persistentInstance(this)
 			import mlpipeline.*;
            
            derdeyn = mlderdeyn.StudyDataSingleton.instance('initialize');
            derdeyn.comments = 'test_persistentInstance';
            
 			sdss = StudyDataSingletons.instance('derdeyn');
            this.verifyEqual(sdss.comments, 'test_persistentInstance');
            
            sdss2 = StudyDataSingletons.instance('derdeyn');
            this.verifyEqual(sdss2.comments, 'test_persistentInstance');
            
            sdss.comments = 'test_persistentInstance again';
            this.verifyEqual(sdss2.comments, 'test_persistentInstance again');
            
 		end
		function test_arbelaez(this)
        end
		function test_derdeyn(this)
        end
		function test_raichle(this)
        end
		function test_noReregistration(this)
        end
	end

 	methods (TestClassSetup)
		function setupStudyDataSingletons(this)
 		end
	end

 	methods (TestMethodSetup)
		function setupStudyDataSingletonsTest(this)
 		end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

