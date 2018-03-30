classdef Test_Np755Builder < TestCase 
	%% TEST_NP755BUILDER \n	%  Usage:  >> runtests tests_dir  
 	%          >> runtests Test_Np755Builder % in . or the matlab path 
 	%          >> runtests Test_Np755Builder:test_nameoffunc 
 	%          >> runtests(Test_Np755Builder, Test_Class2, Test_Class3, ...) 
 	%  See also:  package xunit%  Version $Revision$ was created $Date$ by $Author$,  
 	%  last modified $LastChangedDate$ and checked into svn repository $URL$ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id$ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

	properties 
 		% N.B. (Abstract, Access=private, GetAccess=protected, SetAccess=protected, ... 
 		%       Constant, Dependent, Hidden, Transient) 
 	end 

	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

 		function this = Test_Np755Builder(varargin) 
 			this = this@TestCase(varargin{:}); 
 		end % Test_Np755Builder (ctor) 
 		
        function test_rename(this) 
 			%% TEST_RENAME
 			%  Usage:   
 			import mlpipeline.*; 
 		end % test_rename 
        function test_reorient(this) 
 			%% TEST_REORIENT  
 			%  Usage:   
 			import mlpipeline.*; 
 		end % test_reorient
        function test_coreg2anatomy(this) 
 			%% TEST_COREG2ANATOMY  
 			%  Usage:   
 			import mlpipeline.*; 
 		end % test_coreg2anatomy 
        function test_makeRoi(this) 
 			%% TEST_MAKEROI  
 			%  Usage:   
 			import mlpipeline.*; 
 		end % test_makeroi 
        function test_sampleRoi(this) 
 			%% TEST_  
 			%  Usage:   
 			import mlpipeline.*; 
 		end % test_
        function test_longitudinal(this) 
 			%% TEST_LONGITUDINAL 
 			%  Usage:   
 			import mlpipeline.*; 
 		end % test_longitudinal
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

