classdef Test_StudyDataSingleton < matlab.unittest.TestCase
	%% TEST_STUDYDATASINGLETON 

	%  Usage:  >> results = run(mlpipeline_unittest.Test_StudyDataSingleton)
 	%          >> result  = run(mlpipeline_unittest.Test_StudyDataSingleton, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 27-Jan-2016 15:41:13
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/test/+mlpipeline_unittest.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

	properties
        studiesDir4 = '/Volumes/SeagateBP4'
        studiesDir5 = '/Volumes/SeagateBP5'
        testsDir = '/Volumes/InnominateHD3/Local/test'
 	end

	methods (Test)
		function test_testArbelaez(this)
            sds  = mlarbelaez.TestDataSingleton.instance('initialize');
            iter = sds.createIteratorForSessionData;
                   iter.next;
            nxt  = iter.next;
            this.verifyEqual(nxt.gluc_fqfn, ...
                fullfile(this.testsDir, 'Arbelaez/GluT/p7891_JJL/PET/scan1/p7891gluc1.nii.gz'));
            this.verifyEqual(nxt.ho_fqfn, ...
                fullfile(this.testsDir, 'Arbelaez/GluT/p7891_JJL/PET/scan1/p7891ho1.nii.gz'));
            this.verifyEqual(nxt.oc_fqfn, ...
                fullfile(this.testsDir, 'Arbelaez/GluT/p7891_JJL/PET/scan1/p7891oc1.nii.gz'));
            this.verifyEqual(nxt.tr_fqfn, ...
                fullfile(this.testsDir, 'Arbelaez/GluT/p7891_JJL/PET/scan1/p7891tr1.nii.gz'));
            this.verifyEqual(nxt.T1_fqfn, ...
                fullfile(this.testsDir, 'Arbelaez/GluT/p7891_JJL/freesurfer/mri/T1.mgz'));
        end
		function test_testDerdeyn(this)
            sds  = mlderdeyn.TestDataSingleton.instance('initialize');
            iter = sds.createIteratorForSessionData;
            iter.next;
            iter.next;
            nxt  = iter.next;
            this.verifyEqual(nxt.ho_fqfn, ...
                fullfile(this.testsDir, 'cvl/np755/mm01-020_p7377_2009feb5/ECAT_EXACT/pet/p7377ho1_frames/p7377ho1.nii.gz'));
            this.verifyEqual(nxt.oc_fqfn, ...
                fullfile(this.testsDir, 'cvl/np755/mm01-020_p7377_2009feb5/ECAT_EXACT/pet/p7377oc1_frames/p7377oc1_03.nii.gz'));
            this.verifyEqual(nxt.oo_fqfn, ...
                fullfile(this.testsDir, 'cvl/np755/mm01-020_p7377_2009feb5/ECAT_EXACT/pet/p7377oo1_frames/p7377oo1.nii.gz'));
            this.verifyEqual(nxt.tr_fqfn, ...
                fullfile(this.testsDir, 'cvl/np755/mm01-020_p7377_2009feb5/ECAT_EXACT/pet/p7377tr1_frames/p7377tr1_01.nii.gz'));
            this.verifyEqual(nxt.T1_fqfn, ...
                fullfile(this.testsDir, 'cvl/np755/mm01-020_p7377_2009feb5/mri/T1.mgz'));
        end
		function test_mlarbelaez(this)
            sds  = mlarbelaez.StudyDataSingleton.instance('initialize');
            iter = sds.createIteratorForSessionData;
            nxt  = iter.next;
            this.verifyEqual(nxt.gluc_fqfn, ...
                fullfile(this.studiesDir4, 'Arbelaez/GluT/p7861_JJL/PET/scan1/p7861gluc1.nii.gz'));
            this.verifyEqual(nxt.ho_fqfn, ...
                fullfile(this.studiesDir4, 'Arbelaez/GluT/p7861_JJL/PET/scan1/p7861ho1.nii.gz'));
            this.verifyEqual(nxt.oc_fqfn, ...
                fullfile(this.studiesDir4, 'Arbelaez/GluT/p7861_JJL/PET/scan1/p7861oc1.nii.gz'));
            this.verifyEqual(nxt.tr_fqfn, ...
                fullfile(this.studiesDir4, 'Arbelaez/GluT/p7861_JJL/PET/scan1/p7861tr1.nii.gz'));
            this.verifyEqual(nxt.T1_fqfn, ...
                fullfile(this.studiesDir4, 'Arbelaez/GluT/p7861_JJL/freesurfer/mri/T1.mgz'));
        end
		function test_mlderdeyn(this)
            sds  = mlderdeyn.StudyDataSingleton.instance('initialize');
            iter = sds.createIteratorForSessionData;
            iter.next;
            nxt  = iter.next;
            this.verifyEqual(nxt.ho_fqfn, ...
                fullfile(this.studiesDir4, 'cvl/np755/mm01-001_p7239_2008may15/ECAT_EXACT/pet/p7239ho1_frames/p7239ho1.nii.gz'));
            this.verifyEqual(nxt.oc_fqfn, ...
                fullfile(this.studiesDir4, 'cvl/np755/mm01-001_p7239_2008may15/ECAT_EXACT/pet/p7239oc1_frames/p7239oc1_03.nii.gz'));
            this.verifyEqual(nxt.oo_fqfn, ...
                fullfile(this.studiesDir4, 'cvl/np755/mm01-001_p7239_2008may15/ECAT_EXACT/pet/p7239oo1_frames/p7239oo1.nii.gz'));
            this.verifyEqual(nxt.tr_fqfn, ...
                fullfile(this.studiesDir4, 'cvl/np755/mm01-001_p7239_2008may15/ECAT_EXACT/pet/p7239tr1_frames/p7239tr1_01.nii.gz'));
            this.verifyEqual(nxt.T1_fqfn, ...
                fullfile(this.studiesDir4, 'cvl/np755/mm01-001_p7239_2008may15/mri/T1.mgz'));
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

