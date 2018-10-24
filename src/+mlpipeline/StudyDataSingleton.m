classdef StudyDataSingleton < handle & mlpipeline.StudyData
	%% STUDYDATASINGLETON  

	%  $Revision$
 	%  was created 21-Jan-2016 15:29:29
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.

	methods
        
        %% 
        
        function iter = createIteratorForSessionData(this)
            iter = this.sessionDataComposite_.createIterator;
        end
        function        register(~)
        end
        function this = replaceSessionData(this, varargin)
        end
    end
    
    %% PROTECTED
    
    properties (Access = protected)
        sessionDataComposite_
    end
    
    methods (Access = protected)
        function that = copyElement(this)
            that = mlpipeline.StudyData;
            that.comments = this.comments;
            that.sessionDataComposite_ = this.sessionDataComposite_;
        end
        function this = StudyDataSingleton(varargin)
            %% STUDYDATASINGLETON 
            %  @param [1] that is a mlpattern.CellComposite:  this replaces internal this.sessionDataComposite_ and returns.
            %  @param [1...N] that is a mlpipeline.SessionData:  
            %  this adds everything to this.sessionDataCompoaite_ and returns.
            %  @param [1...N] that is a valid param for mlpipeline.IStudyHandle.assignSessionDataCompositeFromPaths:
            %  this adds to this.sessionDataComposite_ according to assignSessionDataCompositeFromPaths.
            %  @returns this.
            
            this.sessionDataComposite_ = mlpatterns.CellComposite;
            for v = 1:length(varargin)
                if (isa(varargin{v}, 'mlpatterns.CellComposite'))
                    this.sessionDataComposite_ = varargin{v};
                    return
                end
                if (isa(varargin{v}, 'mlpipeline.SessionData'))
                    this.sessionDataComposite_ = this.sessionDataComposite_.add(varargin{v});
                end
            end            
            if (isempty(this.sessionDataComposite_))
                this = this.assignSessionDataCompositeFromPaths(varargin{:});
            end            
            if (isempty(this.sessionDataComposite_))
                this = this.assignSessionDataCompositeFromPaths(this.subjectsDirFqdns{:});
            end
            this.register;
        end
        
        function this = assignSessionDataCompositeFromPaths(this, varargin)
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

