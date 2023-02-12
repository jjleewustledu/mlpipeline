classdef Test_SubjectData < matlab.unittest.TestCase
    %% line1
    %  line2
    %  
    %  Created 08-Jun-2022 20:50:29 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/test/+mlpipeline_unittest.
    %  Developed on Matlab 9.12.0.1956245 (R2022a) Update 2 for MACI64.  Copyright 2022 John J. Lee.
    
    properties
        testObj
    end
    
    methods (Test)
        function test_afun(this)
            import mlpipeline.*
            this.assumeEqual(1,1);
            this.verifyEqual(1,1);
            this.assertEqual(1,1);
        end
        function test_subFolder2sesFolders(this)
            this.verifyEqual( ...
                {'ses-E248568', 'ses-E00853', 'ses-E03056'}, ...
                mlraichle.SubjectData.subFolder2sesFolders('sub-S58163'));
            %this.verifyEqual( ...
            %    {'ses-E03140'}, ...
            %    mlan.SubjectData.subFolder2sesFolders('sub-S01605'));
            this.verifyEqual( ...
                {'ses-20210218', 'ses-20210421'}, ...
                mlvg.SubjectData.subFolder2sesFolders('sub-108293'));
        end
    end
    
    methods (TestClassSetup)
        function setupSubjectData(this)
            import mlpipeline.*
            this.testObj_ = SubjectData();
        end
    end
    
    methods (TestMethodSetup)
        function setupSubjectDataTest(this)
            this.testObj = this.testObj_;
            this.addTeardown(@this.cleanTestMethod)
        end
    end
    
    properties (Access = private)
        testObj_
    end
    
    methods (Access = private)
        function cleanTestMethod(this)
        end
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
