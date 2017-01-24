classdef Logger < mlpipeline.AbstractLogger
	%% LOGGER accumulates logging strings in a CellArrayList.  It is a handle class.
    
    %  Version $Revision: 2647 $ was created $Date: 2013-09-21 17:59:08 -0500 (Sat, 21 Sep 2013) $ by $Author: jjlee $,
 	%  last modified $LastChangedDate: 2013-09-21 17:59:08 -0500 (Sat, 21 Sep 2013) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/src/+mlpipeline/trunk/Logger.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: Logger.m 2647 2013-09-21 22:59:08Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

    
    properties (Constant)
        FILETYPE     = 'mlpipeline.Logger'
        FILETYPE_EXT = '.log'
    end
    
    properties 
        includeTimeStamp = true
    end
    
    methods
        function this = Logger(varargin)
            this = this@mlpipeline.AbstractLogger(varargin{:});                    
        end 
        function c = clone(this)
            %% CLONE
            %  @return c is a deep copy of a handle class
            
            c = mlpipeline.Logger(this);
        end
    end
    
    %% PROTECTED
    
    methods (Access = 'protected')
        function fn   = defaultFqfileprefix(this)
            fn = fullfile(this.filepath, ['Logger_' datestr(now,30)]);
        end
        function txt  = header(this)
            txt = sprintf('%s:  %s from %s at %s initialized %s', ...
                          this.creationDate, strrep(this.callerid, '_', '.'), this.id, this.hostname, this.fqfilename);
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

