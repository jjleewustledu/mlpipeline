classdef StudyData < mlpipeline.StudyDataHandle
	%% STUDYDATA  

	%  $Revision$
 	%  was created 21-Jan-2016 15:29:29
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	
    
    properties
        comments
    end
    
    properties (Dependent)
        subjectsDir
        subjectsFolder
    end

	methods        
        
        %% GET
        
        function g = get.subjectsDir(this)
            g = this.subjectsDir_;
        end
        function g = get.subjectsFolder(this)
            [~,g] = fileparts(this.subjectsDir);
        end
        
        function this = set.subjectsDir(this, s)
            assert(ischar(s));       
            this.subjectsDir_ = s;
        end
        function this = set.subjectsFolder(this, s)
            assert(ischar(s));
            this.subjectsDir_ = fullfile(fileparts(this.subjectsDir_), s, '');
        end
        
        %% concrete implementations of abstract mlpipeline.StudyDataHandle
        
        function iter = createIteratorForSessionData(this)
            iter = this.sessionDataComposite_.createIterator;
        end
        function        diaryOff(~)
            diary off;
        end
        function        diaryOn(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.subjectsDir, @isdir);
            parse(ip, varargin{:});
            
            diary(fullfile(ip.Results.path, sprintf('%s_diary_%s.log', mfilename, datestr(now, 30))));
        end
        function d    = freesurfersDir(this)
            d = this.subjectsDir;
        end
        function loc  = loggingLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'type', 'path', @isLocationType);
            parse(ip, varargin{:});
            
            switch (ip.Results.type)
                case 'folder'
                    [~,loc] = fileparts(this.subjectsDir);
                case 'path'
                    loc = this.subjectsDir;
                otherwise
                    error('mlpipeline:unsupportedSwitchCase', ...
                          'StudyData.loggingLocation.ip.Results.type->%s', ip.Results.type);
            end
        end
        function d    = rawdataDir(this)
            d = this.subjectsDir;
        end
        function this = replaceSessionData(this, varargin)
        end
        function loc  = saveWorkspace(this, varargin)
            ip = inputParser;
            addOptional(ip, 'path', this.subjectsDir, @isdir);
            parse(ip, varargin{:});
            
            loc = fullfile(ip.Results.path, sprintf('%s_workspace_%s.mat', mfilename, datestr(now, 30)));
            if (this.isChpcHostname)
                save(loc, '-v7.3');
                return
            end
            save(loc);
        end
        function sess = sessionData(varargin)
            %% SESSIONDATA
            %  @param [parameter name,  parameter value, ...] as expected by mlpipeline.SessionData are optional;
            %  'studyData' and this are always internally supplied.
            %  @returns for empty param:  mlpatterns.CellComposite object or it's first element when singleton, 
            %  which are instances of mlpipeline.SessionData.
            %  @returns for non-empty param:  instance of mlraichle.SessionData corresponding to supplied params.
            
            if (isempty(varargin))
                sess = this.sessionDataComposite_;
                if (1 == length(sess))
                    sess = sess.get(1);
                end
                return
            end
            sess = mlpipeline.SessionData('studyData', this, varargin{:});
        end
    end
    
    %% PROTECTED
    
    properties (Access = protected)
        sessionDataComposite_
        subjectsDir_
    end
    
    methods (Access = protected)    
        function that = copyElement(this)
            that = mlpipeline.StudyData;
            that.comments = this.comments;
            that.sessionDataComposite_ = this.sessionDataComposite_;
            that.subjectsDir_ = this.subjectsDir_;
        end
        function tf   = isChpcHostname(~)
            [~,hn] = mlbash('hostname');
            tf = lstrfind(hn, 'gpu') || lstrfind(hn, 'node') || lstrfind(hn, 'login');
        end        
        function this = StudyData(varargin)
            %% STUDYDATA 
            %  @param [1] that is a mlpattern.CellComposite:  this replaces internal this.sessionDataComposite_ and returns.
            %  @param [1...N] that is a mlpipeline.SessionData:  
            %  this adds everything to this.sessionDataCompoaite_ and returns.
            %  @param [1...N] that is a valid param for mlpipeline.StudyDataHandle.assignSessionDataCompositeFromPaths:
            %  this adds to this.sessionDataComposite_ according to assignSessionDataCompositeFromPaths.
            %  @returns this.
            
%            this.sessionDataComposite_ = mlpatterns.CellComposite;
%             for v = 1:length(varargin)
%                 if (isa(varargin{v}, 'mlpatterns.CellComposite'))
%                     this.sessionDataComposite_ = varargin{v};
%                     return
%                 end
%                 if (isa(varargin{v}, 'mlpipeline.SessionData'))
%                     this.sessionDataComposite_ = this.sessionDataComposite_.add(varargin{v});
%                 end
%             end            
%             if (isempty(this.sessionDataComposite_))
%                 this = this.assignSessionDataCompositeFromPaths(varargin{:});
%             end            
%             if (isempty(this.sessionDataComposite_))
%                 this = this.assignSessionDataCompositeFromPaths(this.subjectsDirFqdns{:});
%             end
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

