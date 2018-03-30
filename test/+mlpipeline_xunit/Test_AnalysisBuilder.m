classdef Test_AnalysisBuilder < TestCase 
	%% TEST_ANALYSISBUILDER
    %  Usage:  >> runtests tests_dir  
 	%          >> runtests Test_AnalysisBuilder % in . or the matlab path 
 	%          >> runtests Test_AnalysisBuilder:test_nameoffunc 
 	%          >> runtests(Test_AnalysisBuilder, Test_Class2, Test_Class3, ...)
    %  Use cases:  
    %  -  Correlations, Bland-Altman
    %  -  logistic regressions
    %  -  GLM, adaptations from FEAT
    %  -  longitudinal analysis
    %  -  paired analysis
 	%  See also:  package xunit%  Version $Revision: 2277 $ was created $Date: 2012-09-18 05:33:20 -0500 (Tue, 18 Sep 2012) $ by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2012-09-18 05:33:20 -0500 (Tue, 18 Sep 2012) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/test/+mlpipeline_xunit/trunk/Test_AnalysisBuilder.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: Test_AnalysisBuilder.m 2277 2012-09-18 10:33:20Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

	properties 
 		% N.B. (Abstract, Access=private, GetAccess=protected, SetAccess=protected, ... 
 		%       Constant, Dependent, Hidden, Transient) 
 	end 

	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 
        
        function test_buildAnalysisArray(this)
            %% TEST_BUILDANALYSISARRAY tests a 2xN array:  2 modalities, N samples
 			import mlfourd.* mlfsl.*; 
            builder  = AnalysisArrayBuilder;
            director = AnalysisDirector(builder);
            director.constructAnalysisArray;
            assert(eqtool(this.analysisArray, director.result));
        end
        function test_buildScatter(this)
        end
        function test_buildBlandAltman(this)
        end

 		function this = Test_AnalysisBuilder(varargin) 
 			this = this@TestCase(varargin{:}); 
 		end % Test_AnalysisBuilder (ctor) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

