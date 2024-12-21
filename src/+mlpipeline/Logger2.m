classdef Logger2 < handle & matlab.mixin.Heterogeneous & mlpipeline.ILogger & mlio.AbstractHandleIO
	%% LOGGER2 accumulates logging strings using mlpatterns.List. 
    
	%  $Revision$
 	%  was created 22-Oct-2018 17:21:18 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.4.0.813654 (R2018a) for MACI64.  Copyright 2018 John Joowon Lee.
        
    properties (Constant)
        FILETYPE = 'mlpipeline.Logger2'
        FILETYPE_EXT = '.log'
        DATESTR_FORMAT = 'yyyy mmm dd HH:MM:SS'
        TIMESTR_FORMAT = 'yyyy mmm dd HH:MM:SS:FFF' 
    end    
    
    properties (Dependent)
        callerid
        contents % @return cell of char-arrays.  Use char(this) for single char-array.
        creationDate
        echoToCommandWindow % logical
        hostname
        id % user id
        includeTimeStamp
        uname % machine id
    end

    methods (Static)
        function this = createFromFilename(fn, varargin)
            %% CREATEFROMFILENAME creates a Logger2, then imports any existing logs.
            %  @param required 'fn' is char; any trailing this.FILETYPE_EXT is dropped.
            %  @param optional 'callerid' is char, identifying the client requesting logging | 
            %                  'callerid' is an object to be replaced with its classname.
            %  @param 'tag' is char to augment fileprefixes; '_' is prepended as needed.
            %  @param 'echoToCommandWindow' is logical; default := non-empty getenv('DEBUG').
            %  @param 'includeTimeStamp' is logical; default := true.
            %  @return this   
            fqfp = myfileprefix(fn);
            fqfn = [convertStringsToChars(fqfp) '.log'];
            this = mlpipeline.Logger2(fqfp);
            if isfile(fqfn)
                this.cellArrayList_ = mlio.FilesystemRegistry.textfileToCellArrayList(fqfn);
            end

        end
    end
    
    methods
        
        %% GET
        
        function g = get.callerid(this)
            g = this.callerid_;
        end
        function g = get.contents(this)
            g = clone(this.cellArrayList_);
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
        function     set.includeTimeStamp(this, s)
            assert(islogical(s))
            this.includeTimeStamp_ = s;
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
            %  @return saves this to this.fqfilename.  
            %  @throws mlpipeline.IOError:noclobberPreventedSaving
            
            if strlength(this.footer) > 0
                this.cellArrayList_.add(this.footer);
            end
            this = this.ensureExtension;
            mlio.FilesystemRegistry.cellArrayListToTextfile( ...
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
            try
                if iscell(varargin{1})
                    this.addCell(varargin{1})
                    return
                end
                if (this.echoToCommandWindow)
                    fprintf(varargin{:}); fprintf('\n');
                end
                if (this.includeTimeStamp)
                    s1 = string(sprintf('%s:  ', datestr(now, this.TIMESTR_FORMAT)));
                    s2 = string(sprintf(varargin{:}));
                    this.cellArrayList_.add(strcat(s1, s2));
                    return
                end
                this.cellArrayList_.add(sprintf(varargin{:}));
            catch ME
                fprintf(stackstr()+": ignored error %s\n", ME.message);
            end
        end
        function           addCell(this, varargin)
            try
                if (this.echoToCommandWindow)
                    disp(varargin{1});
                end
                if (this.includeTimeStamp)
                    this.cellArrayList_.add(sprintf('%s:  ', datestr(now, this.TIMESTR_FORMAT)));
                    this.cellArrayList_.add(varargin{1});
                    return
                end
                this.cellArrayList_.add(varargin{1});
            catch ME
                fprintf(stackstr()+": ignored error %s\n", ME.message);
            end
        end
        function           addNoEcho(this, varargin)
            this.add(varargin{:});
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
            str = strtrim(char(this.cellArrayList_));
        end
        function iter    = createIterator(this)
            iter = this.cellArrayList_.createIterator;
        end
        function elts    = remove(~, ~)
            elts = [];
        end
        function str     = string(this)
            str = convertCharsToStrings(this.cellArrayList_);
        end
        
        %%
        
        function this = Logger2(varargin) 
            %% LOGGER2 provides copy-construction for its handle.  
            %  Its interface is simplified compared to mlpipeline.Logger.
            %  @param optional 'fqfileprefix' is char; any trailing this.FILETYPE_EXT is dropped.
            %  @param optional 'callerid' is char, identifying the client requesting logging | 
            %                  'callerid' is an object to be replaced with its classname.
            %  @param 'tag' is char to augment fileprefixes; '_' is prepended as needed.
            %  @param 'echoToCommandWindow' is logical; default := non-empty getenv('DEBUG').
            %  @param 'includeTimeStamp' is logical; default := true.
            %  @param instance of mlpipeline.Logger2 by itself will construct a deep copy.
            %  @return this            

            if (1 == nargin && isa(varargin{1}, 'mlpipeline.Logger2'))
                this = copy(varargin{1});
                return
            end
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addOptional(ip, 'fqfileprefix', tempname, @istext);
            addOptional(ip, 'callerid', this);
            addParameter(ip, 'tag', '', @istext);
            addParameter(ip, 'echoToCommandWindow', false, @islogical); % ~isempty(getenv('DEBUG'))
            addParameter(ip, 'includeTimeStamp', true, @islogical);
            parse(ip, varargin{:});  
            ipr = ip.Results;
            this.fqfileprefix         = this.aufbauFqfileprefix(ipr.fqfileprefix);
            this.callerid_            = this.callerid2str(ipr.callerid);
            this.tag_                 = this.aufbauTag(ipr.tag); % dependency
            this.filesuffix           = this.FILETYPE_EXT;
            this.echoToCommandWindow_ = ipr.echoToCommandWindow;
            this.includeTimeStamp_    = ipr.includeTimeStamp;
            
            this.creationDate_  = datestr(now, this.DATESTR_FORMAT);
            this.hostname_      = hostname;
            if isunix
                try
                    [~,this.id_]    = mlbash('id -u -n');   this.id_    = strtrim(this.id_);
                    [~,this.uname_] = mlbash('uname -srm'); this.uname_ = strtrim(this.uname_);
                catch
                end
            elseif ispc
                try
                    [~,this.id_]    = mlbash('whoami');   this.id_    = strtrim(this.id_);
                    [~,this.uname_] = mlbash('ver'); this.uname_ = strtrim(this.uname_);
                catch
                end
            else
            end
            this.cellArrayList_ = mlpatterns.CellArrayList;
            if strlength(this.header) > 0
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
            if strlength(fqfp) > 0
                fqfp = strexcise(fqfp, this.FILETYPE_EXT);
                return
            end            
            fqfp = fullfile( ...
                this.filepath, ...
                sprintf('%s%s_%s', this.callerid_, this.tag_, mydatetimestr(now)));
        end
        function t    = aufbauTag(~, t)
            t = convertStringsToChars(t);
            if 0 == strlength(t)
                return
            end
            if ~strncmp(t, '_', 1)
                t = strcat('_', t);
            end
        end
        function cid  = callerid2str(~, cid)
            if ~istext(cid)
                cid = class(cid);
            end            
        end
        function that = copyElement(this)
            %%  See also web(fullfile(docroot, 'matlab/ref/matlab.mixin.copyable-class.html'))
            
            that = copyElement@matlab.mixin.Copyable(this);
            that.cellArrayList_ = copy(this.cellArrayList_);
        end
        function this = ensureExtension(this)
            if 0 == strlength(this.filesuffix)
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

