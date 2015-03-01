classdef Test_ImproperParfor < TestCase 
	%% TEST_PARLOOPER 
	%  Usage:  >> runtests tests_dir 
	%          >> runtests mlpipeline.Test_ImproperParfor % in . or the matlab path
	%          >> runtests mlpipeline.Test_ImproperParfor:test_nameoffunc
	%          >> runtests(mlpipeline.Test_ImproperParfor, Test_Class2, Test_Class3, ...)
	%  See also:  package xunit

	%  Version $Revision$ was created $Date$ by $Author$, 
 	%  last modified $LastChangedDate$ and checked into svn repository $URL$
 	%  Developed on Matlab 7.14.0.739 (R2012a)
 	%  $Id$
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)
    
    properties
        poolname  = 'local';
        alphaList = {'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z'};
    end

	methods

 		function test_loopImproperParfor(this) 
 			%% TEST_LOOPIMPROPERPARFOR  
 			%  Usage:   
 			import mlpipeline.*; 
            ImproperParfor.runImproperParfor(this.alphaList)
        end
        
 		function this = Test_ImproperParfor(varargin)
 			this = this@TestCase(varargin{:}); 
 		end % Test_ImproperParfor (ctor)         
        function setUp(this)
            matlabpool(this.poolname);
        end
        function tearDown(this)
            matlabpool('close', 'force', this.poolname);
        end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

