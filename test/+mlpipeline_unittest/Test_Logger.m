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
        sessionPath
        test_fqfn
 		testObj
        workPath
 	end

	methods (Test)
        function test_copyCtor(this)
            copy = mlpipeline.Logger(this.testObj);
            this.verifyNotSameHandle(copy, this.testObj)
            prps = properties(copy);
            for p = 1:length(prps)
                this.verifyEqual(copy.(prps{p}), this.testObj.(prps{p}));
            end
            copy.add('from test_copyCtor');
            this.verifyEqual(copy.length, this.testObj.length + 2);
        end
        function test_ctor(this)
            this.verifyEqual(this.testObj.callerid, 'mlpipeline_Logger');
            this.verifyEqual(this.testObj.contents(end-20:end), 'testing log element 2');
            this.verifyEqual(this.testObj.hostname, 'innominate');
            this.verifyEqual(this.testObj.id, 'jjlee');
            this.verifyEqual(this.testObj.filename, 'Test_Logger.log');
        end
            
 		function test_add(this)
            this.testObj.add(sprintf('test string_3\ntest string4\ntest string5'));
            this.verifyEqual(this.testObj.contents(end-11:end), 'test string5');
        end
        function test_char(this)
            c = this.testObj.char;
            this.verifyEqual(c(end-20:end), 'testing log element 2');
        end
        function test_countOf(this)
            this.verifyEqual(this.testObj.countOf('testing log element 2'), 1);
        end
        function test_createIterator(this)
            iter = this.testObj.createIterator;
            n = '';
            while (iter.hasNext)
                n = iter.next;
            end
            this.verifyEqual(n, 'testing log element 2');
        end
        function test_fqfilename(this)
            this.verifyEqual(this.testObj.fqfilename, this.test_fqfn)
        end
        function test_get(this)
            this.verifyEqual(this.testObj.get(159), 'testing log element 2');
        end
        function test_isempty(this)
            this.verifyFalse(this.testObj.isempty);
            
            obj = mlpipeline.Logger;            
            this.verifyFalse(obj.isempty);
        end
        function test_length(this)
            this.verifyEqual(this.testObj.length, 159);
        end
        function test_locationsOf(this)
            this.verifyEqual(this.testObj.locationsOf('testing log element 1'), 157);
        end
        function test_save(this) 
            this.testObj.save;
            this.verifyTrue(lexist(this.testObj.fqfilename, 'file'));
            c = mlsystem.FilesystemRegistry.textfileToCell(this.testObj.fqfilename);
            this.verifyEqual(c{1}(1:23), 'rec p7377ho1_frames.img');
            this.verifyEqual(c{end}, 'testing log element 2');
        end
        function test_saveas(this)
            FQFP = fullfile(this.workPath, 'Test_Logger_test_saveas');
            this.testObj.saveas(FQFP);            
            this.verifyTrue(lexist([FQFP '.log'], 'file'));
            c = mlsystem.FilesystemRegistry.textfileToCell(this.testObj.fqfilename);
            this.verifyEqual(c{1}(1:23), 'rec p7377ho1_frames.img');
            this.verifyEqual(c{end}, 'testing log element 2');
        end
 	end

 	methods (TestClassSetup)
 		function setupLogger(this)          
            this.sessionPath = fullfile(getenv('MLUNIT_TEST_PATH'), 'cvl', 'np755', 'mm01-020_p7377_2009feb5', '');
            this.workPath    = fullfile(this.sessionPath, 'fsl', '');
            this.test_fqfn   = fullfile(this.workPath, 'Test_Logger.log');
 		end
 	end

 	methods (TestMethodSetup)
        function setupMethods(this)
            this.testObj = mlpipeline.Logger(fullfile(this.workPath, 'p7377ho1.img.rec'));
            this.testObj.add('testing log element 1');
            this.testObj.add('testing log element 2');
            this.testObj.fqfilename = this.test_fqfn;
            deleteExisting(this.test_fqfn);
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

