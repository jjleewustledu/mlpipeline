classdef Logger < mlio.AbstractHandleIO & mlpatterns.List
	%% LOGGER accumulates logging strings in a CellArrayList.  It is a handle class.
    
    %  Version $Revision: 2647 $ was created $Date: 2013-09-21 17:59:08 -0500 (Sat, 21 Sep 2013) $ by $Author: jjlee $,
 	%  last modified $LastChangedDate: 2013-09-21 17:59:08 -0500 (Sat, 21 Sep 2013) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/src/+mlpipeline/trunk/Logger.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: Logger.m 2647 2013-09-21 22:59:08Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

    properties 
        includeTimeStamp = true
    end
    
    properties (Constant)
        FILETYPE     = 'mlpipeline.Logger'
        FILETYPE_EXT = '.log'
    end
    
    properties (Dependent)
        callerid
        contents
        creationDate
        hostname
        id % user id
    end
    
    methods %% GET
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
    
    methods (Static)
         function this = load(fn)
            this = mlpipeline.Logger(fn);
        end
    end
    
    methods        
        function this = Logger(varargin)
            %% LOGGER provides copy-construction for its handle.
            %  @param [filename] is a filename consistent with the filesystem.  
            %  Pre-existing files will be read.  Non-existing files will be created on save.
            %  @param [callback] is a reference from the client that requests logging.
            %  @param [Logger_instance] will construct a deep copy.
            %  @return this is a class instance with IO functionality and logging functionality 
            %  prescribed by abstract data type mlpatterns.List.
            %  @throws 

            if (1 == nargin && isa(varargin{1}, 'mlpipeline.Logger'))
                % copy-ctor
                this.filepath_   = varargin{1}.filepath_;
                this.fileprefix_ = varargin{1}.fileprefix_;
                this.filesuffix_ = varargin{1}.filesuffix_;
                this.noclobber_  = varargin{1}.noclobber_;
                
                this.callerid_      = varargin{1}.callerid_;
                this.cellArrayList_ = mlpatterns.CellArrayList(varargin{1}.cellArrayList_); % copy-ctor
                this.creationDate_  = varargin{1}.creationDate_;
                this.hostname_      = varargin{1}.hostname_;
                this.id_            = varargin{1}.id_;
                return
            end            
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addOptional(ip, 'filename', this.defaultFqfilename, @ischar);
            addOptional(ip, 'callback', this,                   @isobject);
            parse(ip, varargin{:});
            
            this.fqfilename = ip.Results.filename;
            this.callerid_  = strrep(class(ip.Results.callback), '.', '_');            
            if (lexist(ip.Results.filename))                
                this.cellArrayList_ = ...
                    mlsystem.FilesystemRegistry.textfileToCellArrayList(this.fqfilename);
            else                 
                this.cellArrayList_ = mlpatterns.CellArrayList;
            end            
            this.creationDate_  = datestr(now, 31);
            [~,this.hostname_]  = mlbash('hostname'); this.hostname_ = strtrim(this.hostname_);
            [~,this.id_]        = mlbash('id -u -n'); this.id_       = strtrim(this.id_);
            this.cellArrayList_.add(this.header);            
        end 
        function c = clone(this)
            %% CLONE
            %  @return c is a deep copy of a handle class
            
            c = mlpipeline.Logger(this);
        end
        
        %% implementation of AbstractHandleIO
        
        function save(this)
            if (isempty(this.filesuffix))
                this.filesuffix = this.FILETYPE_EXT; 
            end                
            mlsystem.FilesystemRegistry.cellArrayListToTextfile(this.cellArrayList_, this.fqfilename);
        end
        
        %% implementations of List
        
        function numElts = length(this)
            numElts = this.cellArrayList_.length;
        end
        function empty   = isempty(this)
            empty = logical(this.cellArrayList_.isempty);
        end
        function           add(this, varargin)
            if (this.includeTimeStamp)
                s = sprintf('%s:  ', datestr(now, 31));
                this.cellArrayList_.add([s varargin]);
                return
            end
            this.cellArrayList_.add(varargin);
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
            fn = fullfile(this.filepath, ['Logger_' datestr(now,30) this.FILETYPE_EXT]);
        end
        function txt = header(this)
            txt = sprintf('%s from %s at %s on %s initialized %s', ...
                          strrep(this.callerid, '_', '.'), this.id, this.hostname, this.creationDate, this.fqfilename);
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

