classdef Test_DataExplorer < TestCase
	%% TEST_DATAEXPLORER 
	%  Usage:  >> runtests tests_dir 
	%          >> runtests mlpipeline.Test_DataExplorer % in . or the matlab path
	%          >> runtests mlpipeline.Test_DataExplorer:test_nameoffunc
	%          >> runtests(mlpipeline.Test_DataExplorer, Test_Class2, Test_Class3, ...)
	%  See also:  package xunit

	%  $Revision: 2335 $
 	%  was created $Date: 2013-01-23 12:40:41 -0600 (Wed, 23 Jan 2013) $
 	%  by $Author: jjlee $, 
 	%  last modified $LastChangedDate: 2013-01-23 12:40:41 -0600 (Wed, 23 Jan 2013) $
 	%  and checked into repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/test/+mlpipeline_xunit/trunk/Test_DataExplorer.m $, 
 	%  developed on Matlab 8.0.0.783 (R2012b)
 	%  $Id: Test_DataExplorer.m 2335 2013-01-23 18:40:41Z jjlee $
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	properties
 		% N.B. (Abstract, Access=private, GetAccess=protected, SetAccess=protected, Constant, Dependent, Hidden, Transient)
 	end

	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

        function test_manyPatientsManyModalitiesManySessionsManyRois(this)
        end
        function test_onePatientManyModalitiesManySessionsManyRois(this)
        end
        function test_manyPatientsOneModalityManySessionsManyRois(this)
        end
        function test_manyPatientsManyModalitiesManySessionsOneRoi(this)
        end
        function test_onePatientOneModalityManySessionsManyRois(this)
        end
        function test_manyPatientsOneModalityManySessionsOneRoi(this)
        end
        function test_onePatientOneModalityManySessionsOneRoi(this)
        end
 		function test_manyPatientsManyModalitiesManySessions(this) 
 			import mlpipeline.*; 
 		end 
 		function test_onePatientManyModalitiesManySessions(this) 
            set = mlfourd.ImagingComposite.load({});
            assertEqual(, set.length);
            for s = 1:length(set)
                assertEqual(set.get(1).pid, set.get(s).pid);
            end
 		end 
 		function test_manyPatientsOneModalityManySessions(this) 
 			import mlpipeline.*; 
 		end 
 		function test_onePatientOneModalityManySessions(this) 
 			import mlpipeline.*; 
 		end 
 		function test_onePatientOneModalityOneSession(this) 
            %% TEST_ONEPATIENTSONEMODALITYONESESSION is a consistency check
 			import mlpipeline.*; 
        end 
 		function test_slicesdir(this) 
 			import mlpipeline.*; 
 		end 
 		function test_fslview(this) 
 			import mlpipeline.*; 
 		end 
 		function test_osirix(this) 
 			import mlpipeline.*; 
        end
 		function this = Test_DataExplorer(varargin) 
 			this = this@TestCase(varargin{:}); 
 		end% ctor 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

