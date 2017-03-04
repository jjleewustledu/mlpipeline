classdef AbstractLogger < mlio.AbstractHandleIO & mlpatterns.List
	%% ABSTRACTLOGGER accumulates logging strings in a CellArrayList.  It is a handle class.
    
    %  Version $Revision: 2647 $ was created $Date: 2013-09-21 17:59:08 -0500 (Sat, 21 Sep 2013) $ by $Author: jjlee $,
 	%  last modified $LastChangedDate: 2013-09-21 17:59:08 -0500 (Sat, 21 Sep 2013) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/src/+mlpipeline/trunk/AbstractLogger.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: AbstractLogger.m 2647 2013-09-21 22:59:08Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

    properties (Abstract, Constant)
        FILETYPE
        FILETYPE_EXT
    end
    
    properties (Abstract)
        includeTimeStamp
    end
    
    methods (Abstract)
        clone(this)
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
    
    methods
        function this = AbstractLogger(varargin)
            %% ABSTRACTLOGGER provides copy-construction for its handle.
            %  @param [fileprefix] is a fileprefix consistent with the filesystem.  
            %  Pre-existing files will be read.  Non-existing files will be created on save.
            %  @param [callback] is a reference from the client that requests logging.
            %  @param [Logger_instance] will construct a deep copy.
            %  @return this is a class instance with IO functionality and logging functionality 
            %  prescribed by abstract data type mlpatterns.List.
            %  @throws 

            if (1 == nargin && isa(varargin{1}, 'mlpipeline.AbstractLogger')) 
                this.includeTimeStamp = varargin{1}.includeTimeStamp;
                
                this.filepath_           = varargin{1}.filepath_;
                this.fileprefix_         = varargin{1}.fileprefix_;
                this.filesuffix_         = varargin{1}.filesuffix_;
                this.filesystemRegistry_ = varargin{1}.filesystemRegistry_;
                
                this.callerid_      = varargin{1}.callerid_;
                this.cellArrayList_ = mlpatterns.CellArrayList(varargin{1}.cellArrayList_); % copy-ctor
                this.creationDate_  = varargin{1}.creationDate_;
                this.hostname_      = varargin{1}.hostname_;
                this.id_            = varargin{1}.id_;
                return
            end % for copy-ctor      
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addOptional(ip, 'fileprefix',       this.defaultFqfileprefix, @ischar);
            addOptional(ip, 'callback',         this,                   @isobject);
            parse(ip, varargin{:});
            
            this.fqfileprefix = ip.Results.fileprefix;
            this.filesuffix = this.FILETYPE_EXT;
            this.callerid_  = strrep(class(ip.Results.callback), '.', '_');   
            this.creationDate_  = datestr(now, 'yyyy-mm-dd HH:MM:SS.FFF');
            [~,this.hostname_]  = mlbash('hostname'); this.hostname_ = strtrim(this.hostname_);
            [~,this.id_]        = mlbash('id -u -n'); this.id_       = strtrim(this.id_);
            
            this.cellArrayList_ = mlpatterns.CellArrayList;
            this.cellArrayList_.add(this.header);              
        end 
        
        %% mlio.AbstractHandleIO
        
        function save(this)
            %% SAVE supports extensions 
            %  mlfourd.JimmyShenInterface.SUPPORTED_EXT and mlsurfer.SurferRegistry.SUPPORTED_EXT,
            %  defaulting to this.FILETYPE_EXT if needed. 
            %  If this.noclobber == true,  it will never overwrite files.
            %  If this.noclobber == false, it may overwrite files. 
            %  @return saves this AbstractLogger to this.fqfilename.  
            %  @throws mlpipeline.IOError:noclobberPreventedSaving
            
            if (~isempty(this.footer))
                this.cellArrayList_.add(this.footer);
            end
            this = this.ensureExtension;
            mlsystem.FilesystemRegistry.cellArrayListToTextfile( ...
                this.cellArrayList_, this.fqfilename);
        end
        
        %% mlpatterns.List
        
        function numElts = length(this)
            numElts = this.cellArrayList_.length;
        end
        function empty   = isempty(this)
            empty = logical(this.cellArrayList_.isempty);
        end
        function           add(this, varargin) 
            if (this.includeTimeStamp)
                s = sprintf('%s:  ', datestr(now, 'yyyy-mm-dd HH:MM:SS.FFF'));
                this.cellArrayList_.add([s sprintf(varargin{:})]);
                return
            end
            this.cellArrayList_.add(sprintf(varargin{:}));
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
    
    %% PROTECTED
    
    properties (Access = 'protected')
        callerid_
        cellArrayList_
        creationDate_
        hostname_
        id_
    end
    
    methods (Access = 'protected')
        function fn   = defaultFqfileprefix(this)
            fn = fullfile(this.filepath, ['AbstractLogger_' datestr(now,30)]);
        end
        function this = ensureExtension(this)
            if (isempty(this.filesuffix))
                this.filesuffix = this.FILETYPE_EXT;
            end
        end
        function txt  = header(~)
            txt = '';
        end
        function txt  = footer(~)
            txt = '';
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

