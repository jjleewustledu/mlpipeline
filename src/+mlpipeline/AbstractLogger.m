classdef (Abstract) AbstractLogger < handle & mlio.AbstractHandleIO & mlpipeline.ILogger
	%% ABSTRACTLOGGER accumulates logging strings in a CellArrayList.  It is a handle class.
    
    %  Version $Revision: 2647 $ was created $Date: 2013-09-21 17:59:08 -0500 (Sat, 21 Sep 2013) $ by $Author: jjlee $,
 	%  last modified $LastChangedDate: 2013-09-21 17:59:08 -0500 (Sat, 21 Sep 2013) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/src/+mlpipeline/trunk/AbstractLogger.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: AbstractLogger.m 2647 2013-09-21 22:59:08Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 
    
    properties (Constant)
        DATESTR_FORMAT = 'ddd mmm dd HH:MM:SS yyyy'
        TIMESTR_FORMAT = 'ddd mmm dd HH:MM:SS:FFF yyyy' 
    end
    
    properties 
        echoToCommandWindow
    end
    
    properties (Dependent)
        callerid
        contents % @return cell of char-arrays.  Use char(this) for single char-array.
        creationDate
        hostname
        id % user id
        uname
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
            ensuredir(this.filepath);
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
            %% ADD understands argument conventions of sprintf.  If this.echoToCommandWindow it echos.
            %  If this.includeTimeStamp it stamps the beginning of each add().  It always adds '\n', so additional
            %  '\n' in varargin will create line breaks in logs.
            
            if (this.echoToCommandWindow)
                fprintf(varargin{:}); fprintf('\n');
            end
            if (isempty(this.cellArrayList_))
                this.cellArrayList_ = mlpatterns.CellArrayList;
            end
            if (this.includeTimeStamp)
                s = sprintf('%s:  ', datestr(now, this.TIMESTR_FORMAT));
                this.cellArrayList_.add([s sprintf(varargin{:})]);
                return
            end
            this.cellArrayList_.add(sprintf(varargin{:}));
        end
        function           addNoEcho(this, varargin) 
            %% ADDNOECHO understands argument conventions of sprintf.  If this.echoToCommandWindow it echos.
            %  If this.includeTimeStamp it stamps the beginning of each add().  It always adds '\n', so additional
            %  '\n' in varargin will create line breaks in logs.
            
            if (isempty(this.cellArrayList_))
                this.cellArrayList_ = mlpatterns.CellArrayList;
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
            %  @param optional 'fqfileprefix' is char; trailing this.FILETYPE_EXT is dropped.
            %  @param optional 'callerid' is char, identifying the client requesting logging; 
            %         an object is replaced with its classname.
            %  @param named 'tag' is char to augment a constructed filename; '_' is prepended as needed.
            %  @param named 'echoToCommandWindow' is logical (default true).
            %  @param instance of mlpipeline.AbstractLogger, by itself, will construct a deep copy.
            %  @return this

            if (1 == nargin && isa(varargin{1}, 'mlpipeline.AbstractLogger')) 
                this = copy(varargin{1});
                return
            end
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addOptional( ip, 'fqfileprefix', '', @ischar);
            addOptional( ip, 'callerid', this);
            addParameter(ip, 'tag', '', @ischar);
            addParameter(ip, 'echoToCommandWindow', true, @islogical);
            parse(ip, varargin{:});            
            this.callerid_           = this.callerid2str(ip.Results.callerid);
            this.tag_                = this.aufbauTag(ip.Results.tag);
            this.fqfileprefix        = this.aufbauFqfileprefix(ip.Results.fqfileprefix);
            this.filesuffix          = this.FILETYPE_EXT;
            this.echoToCommandWindow = ip.Results.echoToCommandWindow;
            
            this.creationDate_       = datestr(now, this.DATESTR_FORMAT);
            [~,this.hostname_]       = mlbash('hostname');   this.hostname_ = strtrim(this.hostname_);
            [~,this.id_]             = mlbash('id -u -n');   this.id_       = strtrim(this.id_);   
            [~,this.uname_]          = mlbash('uname -srm'); this.uname_    = strtrim(this.uname_);
            this.cellArrayList_      = mlpatterns.CellArrayList;
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
        tag_
        uname_
    end
    
    methods (Access = 'protected')
        function fqfp = aufbauFqfileprefix(this, fqfp)
            if (~isempty(fqfp))
                fqfp = strexcise(fqfp, this.FILETYPE_EXT);
                return
            end            
            fqfp = fullfile( ...
                this.filepath, ...
                sprintf('%s%s_%s', this.callerid_, this.tag_, mydatetimstr(now)));
        end
        function t    = aufbauTag(~, t)
            t = char(t);
            if (isempty(t))
                return
            end
            if (~strcmp(t(1), '_'))
                t = ['_' t];
            end
        end
        function cid  = callerid2str(~, cid)
            if (~ischar(cid))
                cid = myclass(cid);
            end            
        end
        function that = copyElement(this)
            %%  See also web(fullfile(docroot, 'matlab/ref/matlab.mixin.copyable-class.html'))
            
            that = copyElement@matlab.mixin.Copyable(this);
            that.cellArrayList_ = copy(this.cellArrayList_);
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
        
        function        setFilepath_(this, pth)
            if (~isempty(this.filepath_))
                this.add(sprintf('AbstractLogger.setFilepath_(''%s'')', pth));
            end
            this.setFilepath_@mlio.AbstractHandleIO(pth);
        end
        function        setFileprefix_(this, fp)
            if (~isempty(this.filepath_))
                this.add(sprintf('AbstractLogger.setFileprefix_(''%s'')', fp));
            end
            this.setFileprefix_@mlio.AbstractHandleIO(fp);
        end
        function        setFilesuffix_(this, fs)            
            if (~isempty(this.filepath_))
                this.add(sprintf('AbstractLogger.setFilesuffix_(''%s'')', fs));
            end
            this.setFilesuffix_@mlio.AbstractHandleIO(fs);
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

