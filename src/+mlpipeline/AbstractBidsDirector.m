classdef AbstractBidsDirector < mlpipeline.AbstractDirector
	%% ABSTRACTBIDSDIRECTOR  

	%  $Revision$
 	%  was created 09-Apr-2019 16:20:55 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.5.0.1067069 (R2018b) Update 4 for MACI64.  Copyright 2019 John Joowon Lee.
 	
	properties
 		
 	end

    methods (Static)
        function tag = acTag(tf)
            if (tf)
                tag = '-AC';
            else
                tag = '-NAC';
            end
        end
        function ipr = adjustParameters(ipr)
            assert(isstruct(ipr));
            results = {'projectsExpr' 'sessionsExpr'};
            for r = 1:length(results)
                if (~lstrfind(ipr.(results{r}), '*'))
                    ipr.(results{r}) = [ipr.(results{r}) '*'];
                end
            end
        end
    end
    
	methods 
		  
 		function this = AbstractBidsDirector(varargin)
 			%% ABSTRACTBIDSDIRECTOR
 			%  @param .

 			this = this@mlpipeline.AbstractDirector(varargin{:});
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

