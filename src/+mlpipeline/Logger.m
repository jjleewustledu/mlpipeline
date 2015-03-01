classdef Logger < mlio.AbstractHandleIO & mlpatterns.List
	%% LOGGER accumulates logging strings in a CellArrayList
    
    %  Version $Revision: 2647 $ was created $Date: 2013-09-21 17:59:08 -0500 (Sat, 21 Sep 2013) $ by $Author: jjlee $,
 	%  last modified $LastChangedDate: 2013-09-21 17:59:08 -0500 (Sat, 21 Sep 2013) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/src/+mlpipeline/trunk/Logger.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: Logger.m 2647 2013-09-21 22:59:08Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

    properties (Constant)
        LOGFILE_EXT = '.log';
    end
    properties (Dependent)
        creationDate
    end
    
    methods (Static)
         function this = load(fn)
            assert(lexist(fn, 'file'));
            this.filename_ = fn;
            this.cellArrayList_ = ...
                mlsystem.FilesystemRegistry.textfileToCellArrayList(fn);
        end
    end
    
    methods %% Get
        function cdat = get.creationDate(this)
            cdat = this.creationDate_;
        end     
    end
    
    methods 
        function numElts = length(this)
            numElts = this.cellArrayList_.length;
        end
        function empty   = isempty(this)
            empty = this.cellArrayList_.isempty;
        end
        function           add(this, varargin)
            this.cellArrayList_.add(varargin{:});
        end
        function elts    = get(this,locs)
            elts = this.cellArrayList_.get(locs);
        end
        function elts    = remove(this,locs)
            elts = this.cellArrayList_.remove(locs);
        end
        function count   = countOf(this,elt)
            count = this.cellArrayList_.countOf(elt);
        end
        function locs    = locationsOf(this,elt)
            locs = this.cellArrayList_.locationsOf(elt);
        end
        function str     = char(this)
            str = this.cellArrayList_.char;
        end
        function           display(this) 
            this.cellArrayList_.display;
        end
        function iter    = createIterator(this)
            iter = this.cellArrayList_.createIterator;
        end
        
        function           save(this)
            mlsystem.FilesystemRegistry.cellArrayListToTextfile(this.cellArrayList_, this.fqfilename);
        end
        
        function this    = Logger(varargin)
            this.filesuffix_ = this.LOGFILE_EXT;
            p = inputParser;
            p.KeepUnmatched = true;
            addParamValue(p, 'filename', fullfile(this.filepath, ['Logger_' datestr(now,30) mlpipeline.Logger.LOGFILE_EXT]), @ischar);
            addParamValue(p, 'callback', this,                                                                              @isobject);
            parse(p, varargin{:});          
                this.fqfilename = p.Results.filename;
                this.fileprefix = [class(p.Results.callback) '_' this.fileprefix]; 
            
            this.creationDate_ = datestr(now);
            this.cellArrayList_ = mlpatterns.CellArrayList;
            this.cellArrayList_.add( ...
                sprintf('mlpipeline.Logger.ctor initialized at %s for logging to %s\n', this.creationDate, this.fqfilename));            
        end % ctor
    end
    
    properties (Access = 'private')
        cellArrayList_
        creationDate_
        fid_
        fidmsg_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

