classdef Test_SessionData < matlab.unittest.TestCase
	%% TEST_SESSIONDATA 

	%  Usage:  >> results = run(mlpipeline_unittest.Test_SessionData)
 	%          >> result  = run(mlpipeline_unittest.Test_SessionData, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 21-Jan-2016 22:20:42
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/test/+mlpipeline_unittest.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

	properties
 		registry
        subjectsDir = '/Volumes/InnominateHD3/Local/test/raichle/PPGdata/idaif'
 		testObj
 	end

	methods (Test)
		function test_ctor(this)
            this.assertInstanceOf(this.testObj, 'mlpipeline.SessionData');
            this.assertEqual(this.testObj.subjectsDir, this.subjectsDir);
            this.assertEqual(this.testObj.sessionPath, fullfile(this.subjectsDir, 'NP995_14'));
            this.assertEqual(this.testObj.fdg_fqfn,    fullfile(this.testObj.sessionPath, 'V1', 'NP995_14fdg.4dfp.nii.gz'));

 		end
	end

 	methods (TestClassSetup)
		function setupSessionData(this)
 			import mlpipeline.*;
 			this.testObj_ = SessionData( ...
                'studyData', StudyDataSingletons.instance('test_raichle'), ...
                'sessionPath', fullfile(this.subjectsDir, 'NP995_14'), ...
                'snumber', 1, ...
                'vnumber', 1);
 		end
	end

 	methods (TestMethodSetup)
		function setupSessionDataTest(this)
 			this.testObj = this.testObj_;
 		end
	end

	properties (Access = 'private')
 		testObj_
 	end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

