classdef Logger < mlio.AbstractHandleIO & mlpatterns.List
	%% LOGGER accumulates logging strings in a CellArrayList
    
    %  Version $Revision: 2647 $ was created $Date: 2013-09-21 17:59:08 -0500 (Sat, 21 Sep 2013) $ by $Author: jjlee $,
 	%  last modified $LastChangedDate: 2013-09-21 17:59:08 -0500 (Sat, 21 Sep 2013) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/src/+mlpipeline/trunk/Logger.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: Logger.m 2647 2013-09-21 22:59:08Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

    properties
        defaultFilesuffix = '.log';
    end
    
    properties (Dependent)
        callerid
        contents
        creationDate
        hostname
        id
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
        function g = get.callerid(this)
            g = this.callerid_;
        end
        function g = get.contents(this)
            g = this.char;
        end
        function g = get.creationDate(this)
            g = this.creationDate_;
        end
        function g = get.hostname(this)
            g = this.hostname_;
        end
        function g = get.id(this)
            g = this.id_;
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
        function count   = countOf(this,elt)
            count = this.cellArrayList_.countOf(elt);
        end
        function locs    = locationsOf(this,elt)
            locs = this.cellArrayList_.locationsOf(elt);
        end
        function str     = char(this)
            str = this.cellArrayList_.char;
        end
        function iter    = createIterator(this)
            iter = this.cellArrayList_.createIterator;
        end
        function elts    = remove(~, ~)
            elts = [];
        end
        
        function save(this)
            if (isempty(this.filesuffix))
                this.filesuffix = this.defaultFilesuffix; 
            end                
            mlsystem.FilesystemRegistry.cellArrayListToTextfile( ...
                this.cellArrayList_, this.fqfilename);
        end
        
        function this = Logger(varargin)
            %% LOGGER
            %  Usage:  this = Logger([filename, callback])
            %                                   ^ reference to calling object
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addOptional(ip, 'filename', this.defaultFqfilename, @ischar);
            addOptional(ip, 'callback', this,                   @isobject);
            parse(ip, varargin{:});
            
            this.fqfilename     = ip.Results.filename;
            this.callerid_      = strrep(class(ip.Results.callback), '.', '_');
            this.fileprefix     = this.updateFileprefix(ip.Results.callback);            
            this.cellArrayList_ = mlpatterns.CellArrayList;
            this.creationDate_  = datestr(now);
            [~,this.hostname_]  = mlbash('hostname');
               this.hostname_   = strtrim(this.hostname_);
            [~,this.id_]        = mlbash('id -u -n');
               this.id_         = strtrim(this.id_);
            this.cellArrayList_.add(this.header);
        end 
    end
    
    %% PRIVATE
    
    properties (Access = 'private')
        callerid_
        cellArrayList_
        creationDate_
        hostname_
        id_
    end
    
    methods (Access = 'private')
        function fn  = defaultFqfilename(this)
            fn = fullfile(this.filepath, ['Logger_' datestr(now,30) this.defaultFilesuffix]);
        end
        function fp  = updateFileprefix(this, callback)
            if (isa(callback, 'mlpipeline.Logger'))
                fp = this.fileprefix;
                return
            end
            fp = [this.callerid '_' this.fileprefix];
        end
        function txt = header(this)
            txt = sprintf('%s\ninitialized by %s by %s at %s on %s\n', ...
                          this.fqfilename, strrep(this.callerid, '_', '.'), this.id, this.hostname, this.creationDate);
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

