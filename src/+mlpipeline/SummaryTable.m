classdef SummaryTable
	%% SUMMARYTABLE is a builder pattern for reporting results
	%  Version $Revision: 1615 $ was created $Date: 2012-08-23 23:09:14 -0500 (Thu, 23 Aug 2012) $ by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2012-08-23 23:09:14 -0500 (Thu, 23 Aug 2012) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/src/+mlpipeline/trunk/SummaryTable.m $ 
 	%  Developed on Matlab 7.14.0.739 (R2012a) 
 	%  $Id: SummaryTable.m 1615 2012-08-24 04:09:14Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

	properties 
        rootTable
    end
    
    properties (Dependent)
        size
        numel
        topTables
    end

    methods (Static)
        function this = loadst(fn)
            this = load(fn, 'this');
        end % static loadst
        function this = summarize(statsInterface)
            
        end
    end
    
	methods 
        
        function sz   = get.size(this)
            sz = size(this.rootTable);
        end
        function ne   = get.numel(this)
            ne = numel(this.rootTable);
        end
        function ce   = get.topTables(this)
            ce = fieldnames(this.rootTable);
        end

        function        savest(this, fn)
            save(fn, this, '-mat');
        end % savest
        
 		function this = SummaryTable 
 			%% SUMMARYTABLE 
 			%  Usage:  prefer creation methods 
            
 		end %  ctor 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

