classdef Finished 
	%% FINISHED provides tools to mark finished milestones in a long processing stream:
    %  it touches hidden files, checks for existence of those files.   Finished behaves as a 
    %  visitor to mlpipeline.IDataBuilder classes.

	%  $Revision$
 	%  was created 10-Jan-2017 22:18:15
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlfourdfp/src/+mlfourdfp.
 	%% It was developed on Matlab 9.1.0.441655 (R2016b) for MACI64.
 	

    methods (Static)        
        function tf = completed(bldr) % isfinished
            %% COMPLETED
            %  @parm bldr is an mlpipeline.IDataBuilder.
            %  @returns logical
            
            assert(isa(bldr, 'mlpipeline.IDataBuilder'));
            this = mlpipeline.Finished('builder', bldr);
            tf = lexist(this.completedTouchFile, 'file');
        end
    end
    
	methods 		  
 		function this = Finished(varargin)
 			%% FINISHED
 			%  Usage:  this = Finished(builder[,path])
            %  @param named builder is an mlpipeline.IDataBuilder.
            %  @param named path is a filesystem path.

            ip = inputParser;
            addParameter(ip, 'builder', [], @(x) isa(mlpipeline.IDataBuilder));
            addParameter(ip, 'path', pwd, @isdir);
            parse(ip, varargin{:});
            
            this.builder_ = ip.Results.builder;
            this.path_ = ip.Results.path;
        end        
        
        function fqfn = completedTouchFile(this, tag) % finishedMarkerFile
            assert(ischar(tag));
            fqfn = fullfile(this.path_, ...
                sprintf('.%s_%s_isFinished.touch', lower(tag), class(this.builder_)));
        end
        function  touchCompleted(this) % touchFinishedMarker
            mlbash(['touch ' this.completedTouchFile]);
        end
    end 
    
    %% PROTECTED
    
    properties (Access = protected)
        builder_
        path_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

