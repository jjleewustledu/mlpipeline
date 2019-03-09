classdef Logger2 < handle & matlab.mixin.Copyable & mlio.AbstractHandleIO & mlpatterns.List & mlpipeline.ILogger
	%% LOGGER2 accumulates logging strings using mlpatterns.List. 
    
	%  $Revision$
 	%  was created 22-Oct-2018 17:21:18 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.4.0.813654 (R2018a) for MACI64.  Copyright 2018 John Joowon Lee.
        
    properties (Constant)
        FILETYPE = 'mlpipeline.Logger2'
        FILETYPE_EXT = '.log'
        DATESTR_FORMAT = 'ddd mmm dd HH:MM:SS yyyy'
        TIMESTR_FORMAT = 'ddd mmm dd HH:MM:SS:FFF yyyy' 
    end    
    
    properties (Dependent)
        callerid
        contents % @return cell of char-arrays.  Use char(this) for single char-array.
        creationDate
        echoToCommandWindow
        hostname
        id % user id
        includeTimeStamp
        uname % machine id
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
        function g = get.echoToCommandWindow(this)
            g = this.echoToCommandWindow_;
        end
        function g = get.hostname(this)
            g = this.hostname_;
        end
        function g = get.includeTimeStamp(this)
            g = this.includeTimeStamp_;
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
            %  If this.noclobber == true,  this will never overwrite files.
            %  If this.noclobber == false, this may overwrite files. 
            %  @param perm are string file permission passed to fopen.  See also:  fopen.
            %  @return saves this AbstractLogger2 to this.fqfilename.  
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
        
        function this = Logger2(varargin) 
            %% LOGGER2 provides copy-construction for its handle.  
            %  Its interface is simplified compared to mlpipeline.Logger.
            %  @param optional 'callerid' is char, identifying the client requesting logging | 
            %                  'callerid' is an object to be replaced with its classname.
            %  @param 'fileprefix' is char; any trailing this.FILETYPE_EXT is dropped.
            %  @param 'tag' is char to augment fileprefixes; '_' is prepended as needed.
            %  @param 'echoToCommandWindow' is logical; default := true.
            %  @param 'includeTimeStamp' is logical; default := true.
            %  @param instance of mlpipeline.AbstractLogger2 by itself will construct a deep copy.
            %  @return this            

            if (1 == nargin && isa(varargin{1}, 'mlpipeline.Logger2')) 
                this = copy(varargin{1});
                return
            end
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addOptional( ip, 'callerid', this);
            addParameter(ip, 'fileprefix', '', @ischar);
            addParameter(ip, 'tag', '', @ischar);
            addParameter(ip, 'echoToCommandWindow', true, @islogical);
            addParameter(ip, 'includeTimeStamp', true, @islogical);
            parse(ip, varargin{:});            
            this.callerid_            = this.callerid2str(ip.Results.callerid);
            this.tag_                 = this.aufbauTag(ip.Results.tag); % dependency
            this.fqfileprefix         = this.aufbauFqfileprefix(ip.Results.fileprefix);
            this.filesuffix           = this.FILETYPE_EXT;
            this.echoToCommandWindow_ = ip.Results.echoToCommandWindow;
            this.includeTimeStamp_    = ip.Results.includeTimeStamp;
            
            this.creationDate_  = datestr(now, this.DATESTR_FORMAT);
            [~,this.hostname_]  = mlbash('hostname');   this.hostname_ = strtrim(this.hostname_);
            [~,this.id_]        = mlbash('id -u -n');   this.id_       = strtrim(this.id_);   
            [~,this.uname_]     = mlbash('uname -srm'); this.uname_    = strtrim(this.uname_);
            this.cellArrayList_ = mlpatterns.CellArrayList;
            if (~isempty(this.header))
                this.cellArrayList_.add(this.header);
            end                   
        end 
        function c = clone(this) % assumes no handle instance data
            c = copy(this);
        end
    end
    
    %% PROTECTED
    
    properties (Access = 'protected')
        callerid_
        cellArrayList_
        creationDate_
        echoToCommandWindow_
        hostname_
        id_
        includeTimeStamp_
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
                sprintf('%s%s_%s', this.callerid_, this.tag_, mydatetimestr(now)));
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
                cid = class(cid);
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
        function txt  = header(this)
            txt = sprintf('%s:  %s from %s on %s (%s) initialized %s', ...
                this.creationDate, this.callerid, this.id, this.hostname, this.uname, this.fqfilename);
        end
        function txt  = footer(~)
            txt = '';
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

