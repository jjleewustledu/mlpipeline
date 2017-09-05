classdef Finished 
	%% FINISHED provides tools to mark finished milestones in a long processing stream:
    %  it touches hidden files, checks for existence of those files.   Finished behaves as a 
    %  visitor to mlpipeline.IDataBuilder classes.
    %  See also:  mlfourdfp_unittest.Test_T4ResolveBuilder.test_finished

	%  $Revision$
 	%  was created 10-Jan-2017 22:18:15
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlfourdfp/src/+mlfourdfp.
 	%% It was developed on Matlab 9.1.0.441655 (R2016b) for MACI64.
 	
    properties
        neverTouch = false
    end

    properties (Dependent)
        path
        tag
    end
    
    methods %% GET
        function g = get.path(this)
            g = this.path_;
        end
        function g = get.tag(this)
            g = this.tag_;
        end
    end
    
	methods 		  
 		function this = Finished(varargin)
 			%% FINISHED
 			%  Usage:  this = Finished(builder[,'path' , 'Log', 'tag', 'fdg'])
            %  @param builder is an mlpipeline.IDataBuilder.
            %  @param named path is a filesystem path.
            %  @param named tag is a string.

            ip = inputParser;
            addRequired( ip, 'builder', @(x) isa(x, 'mlpipeline.IDataBuilder'));
            addParameter(ip, 'path', pwd, @isdir);
            addParameter(ip, 'tag', 'unknown_context_of', @ischar);
            parse(ip, varargin{:});
            
            this.builder_ = ip.Results.builder;
            this.path_ = ip.Results.path;
            this.tag_ = ip.Results.tag;
        end        
        
        function        deleteFinishedMarker(this, varargin)
            deleteExisting(this.finishedMarkerFilename(varargin{:}));
        end
        function fqfn = finishedMarkerFilename(this, varargin)
            %% FINISHEDMARKERFILENAME
            %  @param named path is a filesystem path.
            %  @param named tag is a string.
            
            ip = inputParser;
            addParameter(ip, 'path', this.path_, @isdir);
            addParameter(ip, 'tag', this.tag_, @ischar);
            parse(ip, varargin{:});
            
            fqfn = fullfile(ip.Results.path, ...
                sprintf('.%s_%s_isfinished.touch', ip.Results.tag, class(this.builder_)));
        end
        function tf   = isfinished(this, varargin) % KLUDGE
            tf = lexist(this.finishedMarkerFilename, 'file');
        end
        function        touchFinishedMarker(this, varargin)
            if (this.neverTouch)
                return
            end
            mlbash(['touch ' this.finishedMarkerFilename(varargin{:})]);
        end
    end 
    
    %% PROTECTED
    
    properties (Access = protected)
        builder_
        path_
        tag_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

