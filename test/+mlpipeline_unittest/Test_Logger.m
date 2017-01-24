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
        testNoStamp
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
            this.verifyEqual(copy.length, this.testObj.length + 1);
        end
        function test_ctor(this)
            this.verifyEqual(this.testObj.callerid, 'mlpipeline_Logger');
            this.verifyEqual(this.testObj.contents(end-20:end), 'testing log element 2');
            this.verifyEqual(this.testObj.hostname(1:10), 'innominate');
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
            this.verifyEqual(this.testNoStamp.countOf('testing log element 2'), 1);
        end
        function test_createIterator(this)
            iter = this.testObj.createIterator;
            n = '';
            while (iter.hasNext)
                n = iter.next;
            end
            this.verifyEqual(n(end-20:end), 'testing log element 2');
        end
        function test_fqfilename(this)
            this.verifyEqual(this.testObj.fqfilename, this.test_fqfn)
        end
        function test_get(this)
            this.verifyEqual(this.testNoStamp.get(3), 'testing log element 2');
        end
        function test_isempty(this)
            this.verifyFalse(this.testObj.isempty);
            
            obj = mlpipeline.Logger;            
            this.verifyFalse(obj.isempty);
        end
        function test_length(this)
            this.verifyEqual(this.testObj.length, 3);
        end
        function test_locationsOf(this)
            this.verifyEqual(this.testNoStamp.locationsOf('testing log element 1'), 2);
        end
        function test_save(this) 
            this.testObj.save;
            this.verifyTrue(lexist(this.testObj.fqfilename, 'file'));
            c = mlsystem.FilesystemRegistry.textfileToCell(this.testObj.fqfilename);
            this.verifyEqual(c{1}(end-19:end), 'p7377ho1.img.rec.log');
            this.verifyEqual(c{end}(end-20:end), 'testing log element 2');
        end
        function test_saveas(this)
            FQFP = fullfile(this.workPath, 'Test_Logger_test_saveas');
            this.testObj.saveas(FQFP);            
            this.verifyTrue(lexist([FQFP '.log'], 'file'));
            c = mlsystem.FilesystemRegistry.textfileToCell(this.testObj.fqfilename);
            this.verifyEqual(c{1}(end-19:end), 'p7377ho1.img.rec.log');
            this.verifyEqual(c{end}(end-20:end), 'testing log element 2');
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
            this.testNoStamp = mlpipeline.Logger(fullfile(this.workPath, 'p7377ho1.img.rec'));
            this.testNoStamp.includeTimeStamp = false;
            this.testNoStamp.add('testing log element 1');
            this.testNoStamp.add('testing log element 2');
            this.testNoStamp.fqfilename = this.test_fqfn;
            
            this.addTeardown(@this.deleteFiles);
        end
    end

    methods (Access = private)
        function deleteFiles(this)
            deleteExisting(this.test_fqfn);
            deleteExisting2(fullfile(this.workPath, 'Test_Logger*'));
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end
 

