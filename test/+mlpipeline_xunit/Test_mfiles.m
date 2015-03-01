classdef Test_mfiles < MyTestCase
	%% TEST_MFILES   

	%  Usage:  >> runtests tests_dir  
	%          >> runtests mlpipeline.Test_mfiles % in . or the matlab path 
	%          >> runtests mlpipeline.Test_mfiles:test_nameoffunc 
	%          >> runtests(mlpipeline.Test_mfiles, Test_Class2, Test_Class3, ...) 
	%  See also:  package xunit 

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 

	properties 
 		 
 	end 

	methods
 		function test_fileprefix(this)  %#ok<MANU>
            assertEqual('/full/path/to/prefix', fileprefix('/full/path/to/prefix.nii.gz'));
            assertEqual('/full/path/to/prefix', fileprefix('/full/path/to/prefix.mgz'));
            assertEqual('/full/path/to/prefix', fileprefix('/full/path/to/prefix.mgh'));
            assertEqual(              'prefix', fileprefix(              'prefix.nii.gz'));
            assertEqual(              'prefix', fileprefix(              'prefix.mgz'));
            assertEqual(              'prefix', fileprefix(              'prefix.mgh'));
        end 
        function test_filename(this) %#ok<MANU>
            assertEqual(filename('/full/path/to/prefix'),            '/full/path/to/prefix.nii.gz');
            assertEqual(filename('/full/path/to/prefix', '.nii.gz'), '/full/path/to/prefix.nii.gz');
            assertEqual(filename('/full/path/to/prefix', '.mgz'),    '/full/path/to/prefix.mgz');
            assertEqual(filename('/full/path/to/prefix', '.mgh'),    '/full/path/to/prefix.mgh');
            assertEqual(filename(              'prefix'),                          'prefix.nii.gz');
            assertEqual(filename(              'prefix', '.nii.gz'),               'prefix.nii.gz');
            assertEqual(filename(              'prefix', '.mgz'),                  'prefix.mgz');
            assertEqual(filename(              'prefix', '.mgh'),                  'prefix.mgh');
        end
 		function this = Test_mfiles(varargin) 
 			 this = this@MyTestCase(varargin{:});
 		end 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

