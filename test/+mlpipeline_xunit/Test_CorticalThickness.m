classdef Test_CorticalThickness < TestCase 
	%% TEST_CORTICALTHICKNESS 
	%  Usage:  >> runtests tests_dir  
 	%          >> runtests mlpipelineTest_corticalThickness % in . or the matlab path 
 	%          >> runtests mlpipelineTest_corticalThickness:test_nameoffunc 
 	%          >> runtests(mlpipelineTest_corticalThickness, Test_Class2, Test_Class3, ...) 
 	%  See also:  package xunit	%  Version $Revision: 1621 $ was created $Date: 2012-08-23 23:10:37 -0500 (Thu, 23 Aug 2012) $ by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2012-08-23 23:10:37 -0500 (Thu, 23 Aug 2012) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/test/+mlpipeline_xunit/trunk/Test_CorticalThickness.m $ 
 	%  Developed on Matlab 7.14.0.739 (R2012a) 
 	%  $Id: Test_CorticalThickness.m 1621 2012-08-24 04:10:37Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

	properties 
        testPatient
        expectedSummaryTable
        expectedSummaryTableFilename = '';
 	end 

	methods 
        
        function test_createThicknessTable_multiPatient(this)
        end
        function test_createThicknessTable_onePatientLongitudinal(this)
        end
 		function test_createThicknessTable_oneSession(this) 
 			import mlpipeline.*; 
            this.testPatient.buildCorticalThicknesses;
            assertTrue(this.expectedSummaryTable == this.testPatient.corticalThicknesses.summaryTable);
 		end % test_createThicknessTable_oneSession
        
 		function this = Test_CorticalThickness(varargin) 
            import mlpipeline.*;
 			this = this@TestCase(varargin{:}); 
            this.testPatient          = Patient;
            this.expectedSummaryTable = SummaryTable.loadst(this.expectedSummaryTableFilename);
 		end % Test_corticalThickness (ctor) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

