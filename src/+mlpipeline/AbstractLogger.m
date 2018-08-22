classdef AbstractLogger < handle & matlab.mixin.Copyable & mlio.AbstractHandleIO & mlpatterns.List
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
    
    properties (Constant)
        DATESTR_FORMAT = 'ddd mmm dd HH:MM:SS yyyy'
        TIMESTR_FORMAT = 'ddd mmm dd HH:MM:SS:FFF yyyy' 
    end
    
    properties 
        echoToCommandWindow
    end
    
    properties (Dependent)
        callerid
        contents
        creationDate
        hostname
        id % user id
        uname
    end
    
    methods (Static)
        function fqfn = loggerFilename(varargin)
            %% LOGGERFILENAME ... 
            %  Usage:  fq_filename = loggerFilename(['func', func_value, 'tag', tag_value, 'path', path_value]) 
            %  @param method is the name of the calling function
            %  @param tag is any string identifier
            %  @param path is the path to the log file
            %  @returns fqfn is a standardized log filename

            fqfn = [mlpipeline.AbstractLogger.loggerFileprefix(varargin{:}) '.log'];
        end
        function fqfp = loggerFileprefix(varargin)
            %% LOGGERFILEPREFIX ... 
            %  Usage:  fq_fileprefix = loggerFileprefix(['func', func_value, 'tag', tag_value, 'path', path_value]) 
            %  @param method is the name of the calling function
            %  @param tag is any string identifier
            %  @param path is the path to the log file
            %  @returns fqfp is a standardized log fileprefix

            ip = inputParser;
            addRequired( ip, 'tag', @ischar);
            addParameter(ip, 'func', 'unknownFunc', @ischar);
            addParameter(ip, 'path', pwd, @isdir);
            parse(ip, varargin{:});
            tag = strrep(mybasename(ip.Results.tag), '.', '_');
            if (~isempty(tag) && strcmp(tag(end), '_'))
                tag = tag(1:end-1);
            end
            func = strrep(mybasename(ip.Results.func), '.', '_');

            fqfp = fullfile(ip.Results.path, ...
                 sprintf('%s_%s_D%s', tag, func, datestr(now,'yyyymmddTHHMMSSFFF')));
        end
    end
    
    methods 
        
        %% GET
        
        function g = get.callerid(this)
            g = this.callerid_;
        end
        function g = get.contents(this)
            g = this.cellArrayList_;
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
        function g = get.uname(this)
            g = this.uname_;
        end
        
        %% mlio.AbstractHandleIO
        
        function save(this, varargin)
            %% SAVE 
            %  If this.noclobber == true,  it will never overwrite files.
            %  If this.noclobber == false, it may overwrite files. 
            %  @param perm are string file permission passed to fopen.  See also:  fopen.
            %  @return saves this AbstractLogger to this.fqfilename.  
            %  @throws mlpipeline.IOError:noclobberPreventedSaving
            
            if (~isempty(this.footer))
                this.cellArrayList_.add(this.footer);
            end
            this = this.ensureExtension;
            mlsystem.FilesystemRegistry.cellArrayListToTextfile( ...
                this.cellArrayList_, this.fqfilename, varargin{:});
        end
        
        %% mlpatterns.List
        
        function numElts = length(this)
            numElts = this.cellArrayList_.length;
        end
        function empty   = isempty(this)
            empty = logical(this.cellArrayList_.isempty);
        end
        function           add(this, varargin) 
            if (this.echoToCommandWindow)
                fprintf(varargin{:}); fprintf('\n');
            end
            if (this.includeTimeStamp)
                s = sprintf('%s:  ', datestr(now, this.TIMESTR_FORMAT));
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
        
        %%
        
        function this = AbstractLogger(varargin)
            %% ABSTRACTLOGGER provides copy-construction for its handle.
            %  @param [fileprefix] is a fileprefix consistent with the filesystem.  
            %  Pre-existing files will be read.  Non-existing files will be created on save.
            %  @param [callback] is a reference from the client that requests logging.
            %  @param [Logger_instance] will construct a deep copy.
            %  @return this is a class instance with IO functionality and logging functionality 
            %  prescribed by abstract data type mlpatterns.List.

            if (1 == nargin && isa(varargin{1}, 'mlpipeline.AbstractLogger')) 
                this = copy(varargin{1});
                return
            end
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addOptional( ip, 'fqfileprefix', this.defaultFqfileprefix, @ischar);
            addOptional( ip, 'callback',     this,                     @(x) ~isempty(class(x)));
            addParameter(ip, 'echoToCommandWindow', true,              @islogical);
            parse(ip, varargin{:});
            
            fqfp = ip.Results.fqfileprefix;
            if (strcmp(fqfp(end-3:end), this.FILETYPE_EXT))
                fqfp = fqfp(1:end-4);
            end
            
            this.fqfileprefix        = fqfp;
            this.filesuffix          = this.FILETYPE_EXT;
            this.callerid_           = strrep(class(ip.Results.callback), '.', '_');   
            this.echoToCommandWindow = ip.Results.echoToCommandWindow;
            
            this.creationDate_  = datestr(now, this.DATESTR_FORMAT);
            [~,this.hostname_]  = mlbash('hostname');   this.hostname_ = strtrim(this.hostname_);
            [~,this.id_]        = mlbash('id -u -n');   this.id_       = strtrim(this.id_);   
            [~,this.uname_]     = mlbash('uname -srm'); this.uname_    = strtrim(this.uname_);
            this.cellArrayList_ = mlpatterns.CellArrayList;
            if (~isempty(this.header))
                this.cellArrayList_.add(this.header);
            end
        end         
    end
    
    %% PROTECTED
    
    properties (Access = 'protected')
        callerid_
        cellArrayList_
        creationDate_
        hostname_
        id_
        uname_
    end
    
    methods (Access = 'protected')
        function that = copyElement(this)
            %%  See also web(fullfile(docroot, 'matlab/ref/matlab.mixin.copyable-class.html'))
            
            that = copyElement@matlab.mixin.Copyable(this);
            that.cellArrayList_ = copy(this.contexth_);
        end
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

