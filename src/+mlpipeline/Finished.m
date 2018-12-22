classdef Finished < handle
	%% FINISHED provides tools to mark finished milestones in a long processing stream:
    %  it touches hidden files, checks for existence of those files.   Finished behaves as a 
    %  visitor to mlpipeline.IBuilder classes.
    %  See also:  mlfourdfp_unittest.Test_T4ResolveBuilder.test_finished

	%  $Revision$
 	%  was created 10-Jan-2017 22:18:15
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlfourdfp/src/+mlfourdfp.
 	%% It was developed on Matlab 9.1.0.441655 (R2016b) for MACI64.
 	
    properties
        ignoreFinishMark
        neverMarkFinished
    end

    properties (Dependent)
        path
        tag
    end
    
    methods %% GET, SET
        function g = get.path(this)
            g = this.path_;
        end
        function     set.path(this, s)
            ensuredir(s);
            this.path_ = s;
        end
        function g = get.tag(this)
            g = this.tag_;
        end
        function     set.tag(this, s)
            assert(ischar(s));
            this.tag_ = s;
        end
    end
    
	methods 		  
 		function this = Finished(varargin)
 			%% FINISHED
 			%  Usage:  this = Finished(builder[,'path' , 'Log', 'tag', 'fdg'])
            %  @param builder is an mlpipeline.IBuilder.
            %  @param named path is a filesystem path.
            %  @param named tag is a string.

            res = mlpet.Resources.instance;
            ip = inputParser;
            addRequired( ip, 'builder', @(x) isa(x, 'mlpipeline.IBuilder') || isa(x, 'mlpipeline.IHandleBuilder'));
            addParameter(ip, 'path', pwd, @isdir);
            addParameter(ip, 'tag', 'unknown_context_of', @ischar);
            addParameter(ip, 'neverMarkFinished', res.neverMarkFinished, @islogical);
            addParameter(ip, 'ignoreFinishMark', res.ignoreFinishMark, @islogical);
            parse(ip, varargin{:});
            
            this.builder_          = ip.Results.builder;
            this.path_             = ip.Results.path;
            this.tag_              = this.nodots(ip.Results.tag);
            this.neverMarkFinished = ip.Results.neverMarkFinished;
            this.ignoreFinishMark  = ip.Results.ignoreFinishMark;
        end        
        
        function        deleteFinishedMarker(this, varargin)
            deleteExisting(this.markerFilename(varargin{:}));
        end
        function fqfn = markerFilename(this, varargin)
            %% MARKERFILENAME
            %  @param named path is a filesystem path.
            %  @param named tag is a string.
            
            ip = inputParser;
            addParameter(ip, 'path', this.path_, @isdir);
            addParameter(ip, 'tag', this.tag_, @ischar);
            parse(ip, varargin{:});
            
            if (~isempty(this.markerFilename_))
                fqfn = this.markerFilename_;
                return
            end
            
            fqfn = fullfile(ip.Results.path, ...
                sprintf('.%s_%s_isfinished.touch', this.nodots(ip.Results.tag), this.nodots(class(this.builder_))));
        end
        function tf   = isfinished(this, varargin)
            tf = lexist(this.markerFilename, 'file') && ~this.ignoreFinishMark;
        end
        function        markAsFinished(this, varargin)
            if (this.neverMarkFinished)
                return
            end
            this.markerFilename_ = this.markerFilename(varargin{:});
            ensuredir(fileparts(this.markerFilename_));
            mlbash(['touch ' this.markerFilename_]);
        end
    end 
    
    %% PROTECTED
    
    properties (Access = protected)
        builder_
        markerFilename_
        path_
        tag_
    end
    
    methods (Access = protected)
        function str = nodots(~, str)
            str = strrep(str, '.', '_');
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

