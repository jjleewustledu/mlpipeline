classdef Test_ImagingMediator < matlab.unittest.TestCase
    %% line1
    %  line2
    %  
    %  Created 22-Jul-2025 14:59:22 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/test/+mlpipeline_unittest.
    %  Developed on Matlab 24.2.0.2923080 (R2024b) Update 6 for MACA64.  Copyright 2025 John J. Lee.
    
    properties
        testObj
        dataDir
    end
    
    methods (Test)
        function test_afun(this)
            import mlpipeline.*
            this.assumeEqual(1,1);
            this.verifyEqual(1,1);
            this.assertEqual(1,1);
        end
        function test_ensureFiniteImagingContext2(this)
            e = @mlpipeline.ImagingMediator.ensureFiniteImagingContext2;
            fp = "sub-108007_ses-20210219143132_trc-oo_proc-delay0-BrainMoCo2-createNiftiMovingAvgFrames-ParcSchaeffer-reshape-to-schaeffer-schaeffer";
            niis = fullfile(this.dataDir, ...
                fp + ["", "-j0-imgpass", "-jpass-img0", "-jpass-imgpass"] + ".nii.gz");

            for nii = niis
                this.verifyTrue(isfile(nii));
                ic = mlfourd.ImagingContext2(nii);
                ic1 = e(ic);
                j1 = ic1.json_metadata;
                this.verifyEqual(size(ic1), [309, 26]);
                this.verifyTrue(isfield(j1, "starts"));
                this.verifyTrue(isfield(j1, "taus"));
                this.verifyTrue(isfield(j1, "timesMid"));
                this.verifyTrue(isfield(j1, "timeUnit"));
                this.verifyTrue(isfield(j1, "times"));
                this.verifyEqual(j1.starts, [0;1;2;3;4;5;6;7;8;9;0;1;2;3;4;5;6;7;8;9;0;1;2;3;4;5]);
                this.verifyEqual(j1.taus, [10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10]);
                this.verifyEqual(j1.timesMid, [5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27;28;29;30]);
                this.verifyEqual(j1.timeUnit, "second");
                this.verifyEqual(j1.times, [0;1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25]);
                this.verifyEqual( ...
                    ic1.imagingFormat.img(116, :), ...
                    single( ...
                        [1490.61267089844 2440.67407226562 4024.67114257812 6056.6923828125 8540.65234375 ...
                         11643.9130859375 12851.59765625 13978.4326171875 21447.361328125 24713.7734375 ...
                         26639.263671875 28228.603515625 29727.6640625 35288.33203125 35325.73046875 ...
                         35667.47265625 36530.9296875 36207.04296875 36546.703125 36831.3203125 ...
                         36831.3203125 36546.703125 37092.62890625 36979.6171875 37367.875 37576.87109375]), ...
                    RelTol=1e-6);
            end
        end
    end
    
    methods (TestClassSetup)
        function setupImagingMediator(this)
        end
    end
    
    methods (TestMethodSetup)
        function setupImagingMediatorTest(this)
            this.testObj = this.testObj_;
            this.dataDir = fullfile( ...
                getenv("HOME"), "MATLAB-Drive", "mlpipeline", "data");
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
