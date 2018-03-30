classdef SilentTests 
	%% SILENTTESTS is intended for use in continuous integration
	%  Usage:  >> runtests tests_dir 
	%          >> runtests mlpipeline.SilentTests % in . or the matlab path
	%          >> runtests mlpipeline.SilentTests:test_nameoffunc
	%          >> runtests(mlpipeline.SilentTests, Test_Class2, Test_Class3, ...)
	%  See also:  package xunit

	%  Version $Revision: 2647 $ was created $Date: 2013-09-21 17:59:08 -0500 (Sat, 21 Sep 2013) $ by $Author: jjlee $, 
 	%  last modified $LastChangedDate: 2013-09-21 17:59:08 -0500 (Sat, 21 Sep 2013) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/src/+mlpipeline/trunk/SilentTests.m $
 	%  Developed on Matlab 7.14.0.739 (R2012a)
 	%  $Id: SilentTests.m 2647 2013-09-21 22:59:08Z jjlee $
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	properties
        basePath     = fullfile(getenv('HOME'), 'MATLAB-Drive', '' );
        packageNames = { 'mlfourd' 'mlfsl' 'mlsurfer' };
 	end

	methods (Static)
        function logger = runtests
            this = mlpipeline.SilentTests;
            logger = cell(1,length(this.packageNames));
            for p = 1:length(this.packageNames)
                logger = this.suiteRun(this.packageNames{p});
            end
        end
    end
    
    methods
        function logger = suiteRun(this, pkgnam)
            cd(this.testPath(pkgnam));
            suite = TestSuite.fromPwd();
            logger = TestRunLogger;
            suite.run(logger);
        end
        function pth = testPath(this, pkgname)
            pth = fullfile(this.basePath, pkgname, 'test', ['+' pkgname '_xunit'], '');
        end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

