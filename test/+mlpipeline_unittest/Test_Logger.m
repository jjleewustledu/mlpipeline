classdef Test_Logger < matlab.unittest.TestCase
	%% TEST_LOGGER 

	%  Usage:  >> results = run(mlpipeline_unittest.Test_Logger)
 	%          >> result  = run(mlpipeline_unittest.Test_Logger, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 10-Dec-2015 18:57:44
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/test/+mlpipeline_unittest.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	

	properties
        logFilename
 		registry
        sessionPath
 		testObj
        workPath
 	end

	methods (Test)
        function test_ctor(this)            
            this.verifyEqual(this.testObj.contents(100:140), 'mlpipeline_Logger by jjlee at innominate.');
        end
 		function test_add(this)
            this.testObj.add(sprintf('test_string_3\ntest_string4\ntest_string5'));
            this.verifyEqual(this.testObj.contents(227:238), 'test_string5');
        end
        function test_countOf(this)
            this.verifyEqual(this.testObj.countOf('test_string_1'), 1);
        end
        function test_get(this)
            this.verifyEqual(this.testObj.get(3), 'test_string_2');
        end
        function test_length(this)
            this.verifyEqual(this.testObj.length, 3);
        end
        function test_locationsOf(this)
            this.verifyEqual(this.testObj.locationsOf('test_string_1'), 2);
        end
        function test_save(this) 
            mlbash(sprintf('rm %s', this.testObj.fqfilename));
            this.testObj.save;
            this.verifyTrue(lexist(this.testObj.fqfilename, 'file'));
            c = mlsystem.FilesystemRegistry.textfileToCell(this.testObj.fqfilename);
            this.verifyEqual(c{4}, 'test_string_1');
        end
 	end

 	methods (TestClassSetup)
 		function setupLogger(this)          
            this.sessionPath = fullfile(getenv('MLUNIT_TEST_PATH'), 'cvl', 'np755', 'mm01-020_p7377_2009feb5', '');
            this.workPath    = fullfile(this.sessionPath, 'fsl', '');
            this.logFilename = fullfile(this.sessionPath, 'Test_Logger.log');
 		end
 	end

 	methods (TestMethodSetup)
        function setupMethods(this)   
 			import mlpipeline.*;           
 			this.testObj = Logger(this.logFilename);
            this.testObj.add('test_string_1');
            this.testObj.add('test_string_2');
        end
 	end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

