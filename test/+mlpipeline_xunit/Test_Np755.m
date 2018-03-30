classdef Test_Np755 < TestCase
	%% TEST_NP755 runs unit-tests for moyamoya projects
    %
    %  Usage:  >> runtests tests_dir  
 	%          >> runtests Test_PETBuilder % in . or the matlab path 
 	%          >> runtests Test_PETBuilder:test_nameoffunc 
 	%          >> runtests(Test_PETBuilder, Test_Class2, Test_Class3, ...) 
 	%  See also:  package xunit%  Version $Revision$ was created $Date$ by $Author$,  
 	%  last modified $LastChangedDate$ and checked into svn repository $URL$ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id$ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 
    
    properties
        sessionPath
         mrDirector
         mrBuilder
         mrConverter
        petDirector
        petBuilder
        petConverter
        stats
    end
    
    methods    
        %function test_oefResults(this)            
        %end 
        function test_exportExcel(this)
            this.petDirector.exportExcell(this.stats);
        end
        function test_statRois(this)
            this.stats = this.petDirector.statRois( ...
                this.petDirector.mniRois, {'mni' 't1' 'ho' 'oo'});
        end
        function test_viewRois(this)
            this.petDirector.viewRoisOn('t1');
            this.petDirector.viewRoisOn('ho');
            this.petDirector.viewRoisOn('oo');
        end
        function test_invNflirt(this)
            this.petDirector.invNflirtRois( ...
                 this.petDirector.mniRois, {'t1' 'ho' 'oo'});
        end
        function test_nflirt(this)
            this.petDirector.nflirtToMNI('t1');            
        end
        function test_view(this)
            this.petDirector.viewAllOn('t1');
        end   
        function test_flirt(this)
            this.petDirector.flirtToRef('t1');
        end        
        
 		function this = Test_Np755(varargin) 
 			this = this@TestCase(varargin{:});
        end % (ctor)
    end
    
end

