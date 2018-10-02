classdef (Abstract) Session < mlpipeline.ISessionData 
	%% SESSION

	%  $Revision$
 	%  was created 21-Jan-2016 22:20:41
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.  Copyright 2017 John Joowon Lee.
    
	properties (Dependent)
        freesurfersDir
        freesurfersFolder
        rawdataDir
        rawdataFolder
        sessionDate
        sessionFolder
        sessionPath
        snumber
        study
        studyData % alias
        subjectsDir
        subjectsFolder
        vnumber
    end
    
    methods 
        
        %% GET/SET
        
        function g    = get.freesurfersDir(this)
            g = this.study_.freesurfersDir;
        end
        function g    = get.freesurfersFolder(this)
            g = basename(this.study_.freesurfersDir);
        end
        function g    = get.rawdataDir(this)
            g = this.study_.rawdataDir;
        end
        function g    = get.rawdataFolder(this)
            g = basename(this.study_.rawdataDir);
        end
        function g    = get.sessionDate(this)
            g = this.sessionDate_;
        end
        function this = set.sessionDate(this, s)
            assert(isdatetime(s));
            if (isempty(s.TimeZone))
                s.TimeZone = mldata.TimingData.PREFERRED_TIMEZONE;
            end
            this.sessionDate_ = s;
        end
        function g    = get.sessionFolder(this)
            g = this.sessionFolder_;
            if (isempty(g))
                warning('mlpipeline:emptyParameter', 'mlpipeline.Session.get.sessionFolder.this.sessionFolder_');
            end
        end
        function this = set.sessionFolder(this, s)
            assert(ischar(s));
            this.sessionFolder_ = s;            
        end
        function g    = get.sessionPath(this)
            g = fullfile(this.subjectsDir, this.sessionFolder_);
        end
        function this = set.sessionPath(this, s)
            [this.study_.subjectsDir,this.sessionFolder_] = fileparts(s);
        end
        function g    = get.snumber(this)
            g = this.snumber_;
        end
        function this = set.snumber(this, s)
            assert(isnumeric(s));
            this.snumber_ = s;
        end
        function g    = get.study(this)
            g = this.study_;
        end
        function g    = get.studyData(this)
            g = this.study;
        end
        function g    = get.subjectsDir(this)
            g = this.study_.subjectsDir;
        end
        function g    = get.subjectsFolder(this)
            g = basename(this.study_.subjectsDir);
        end     
        function g    = get.vnumber(this)
            g = this.vnumber_;
        end
        function this = set.vnumber(this, v)
            assert(isnumeric(v));
            this.vnumber_ = v;
        end
    
        %% 
        
        function dt   = datetime(this)
            dt = this.sessionDate_;
        end
        function obj  = freesurferObject(this, varargin)
            %  @param named typ has default 'mlfourd.ImagingContext2'
            
            ip = inputParser;
            addRequired( ip, 'desc', @ischar);
            addParameter(ip, 'tag', '', @ischar);
            addParameter(ip, 'typ', 'mlfourd.ImagingContext2', @ischar);
            parse(ip, varargin{:});
            
            obj = mlfourd.ImagingContext2.imagingType(ip.Results.typ, ...
                fullfile(this.mriLocation, ...
                         sprintf('%s%s.mgz', ip.Results.desc, ip.Results.tag)));
        end      
        function tf   = isequal(this, obj)
            tf = this.isequaln(obj);
        end
        function tf   = isequaln(this, obj)
            if (isempty(obj)); tf = false; return; end
            tf = this.classesequal(obj);
            if (tf)
                tf = this.fieldsequaln(obj);
            end
        end 
        
 		function this = Session(varargin)
 			%% SESSION
            %  @param named 'study'         is an IStudyHandle || IStudyDataHandle (required).
            %  @param named 'sessionDate'   is a datetime.
            %  @param named 'sessionDir'    is a dir to the session data (session* arg is required).
            %  @param named 'sessionFolder' is the folder for session data.
            %  @param named 'sessionPath'   is a path to the session data.
            %  @param named 'snumber'       is numeric
            %  @param named 'vnumber'       is numeric

            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'study',             @(x) isa(x, 'mlpipeline.IStudyHandle')); 
            addParameter(ip, 'studyData',         @(x) isa(x, 'mlpipeline.IStudyHandle')); 
            addParameter(ip, 'sessionDate', NaT,  @isdatetime);
            addParameter(ip, 'sessionDir', '',    @ischar);
            addParameter(ip, 'sessionFolder', '', @ischar);
            addParameter(ip, 'sessionPath', '',   @ischar);
            addParameter(ip, 'snumber', 1,        @isnumeric);
            addParameter(ip, 'vnumber', 1,        @isnumeric);
            parse(ip, varargin{:});    
            
            this.study_ = ip.Results.studyData;
            this.study_ = ip.Results.study;
            
            this.sessionDate_ = ip.Results.sessionDate;
            if (isempty(this.sessionDate_.TimeZone))
                this.sessionDate_.TimeZone = mldata.TimingData.PREFERRED_TIMEZONE;
            end
            
            if (~isempty(ip.Results.sessionDir))
                [~,this.sessionFolder_] = fileparts(ip.Results.sessionDir);
            end 
            if (~isempty(ip.Results.sessionPath))
                [~,this.sessionFolder_] = fileparts(ip.Results.sessionPath);
            end             
            if (~isempty(ip.Results.sessionFolder))
                this.sessionFolder_ = ip.Results.sessionFolder;
            end   
            assert(~isempty(this.sessionFolder_));
            this.snumber_ = ip.Results.snumber;
            this.vnumber_ = ip.Results.vnumber;            
        end
    end

    %% PROTECTED
    
    properties (Access = protected)
        sessionDate_
        sessionFolder_
        study_
        snumber_
        vnumber_
    end
    
    %% PRIVATE
    
    methods (Static, Access = private)
        function [tf,msg] = checkFields(obj1, obj2)
            tf = true; 
            msg = '';
            flds = fieldnames(obj1);
            for f = 1:length(flds)
                try
                    if (~isequaln(obj1.(flds{f}), obj2.(flds{f})))
                        tf = false;
                        msg = sprintf('Session.checkFields:  mismatch at field %s.', flds{f});
                        return
                    end
                catch ME %#ok<NASGU>
                    sprintf('Session.checkFields:  ignoring %s', flds{f});
                end
            end
        end 
    end
    
    methods (Access = private)
        function [tf,msg] = classesequal(this, c)
            tf  = true; 
            msg = '';
            if (~isa(c, class(this)))
                tf  = false;
                msg = sprintf('class(this)-> %s but class(compared)->%s', class(this), class(c));
            end
            if (~tf)
                warning('mlpipeline:isequal:mismatchedClass', msg);
            end
        end        
        function [tf,msg] = fieldsequaln(this, obj)
            [tf,msg] = mlpipeline.Session.checkFields(this, obj);
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

