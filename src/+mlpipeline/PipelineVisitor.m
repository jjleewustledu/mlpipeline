classdef PipelineVisitor
	%% PIPELINEVISITOR's subclasses must implement visit-methods.  The visited class
    %  must have an accept-method in order to establish double dispatch.  
    %  See also:  Design Patterns, GoF   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
    
    properties (Constant)
        WORKFOLDERS = {'fsl' 'mri' 'surf' 'ECAT_EXACT/pet' 'PET' 'perfusion_4dfp' 'quality'}
    end
 	     
    properties (Dependent)
        logger
        sessionPath
        studyPath
        subjectsDir
        workPath
        filetypeExt
    end    

    methods %% GET/SET
        function this = set.logger(this, lggr)
            assert(isa(lggr, 'mlpipeline.Logger'));
            this.logged_ = lggr;
        end
        function lggr = get.logger(this)
            lggr = this.logged_;
        end
        function this = set.sessionPath(this, pth)
            assert(lexist(pth, 'dir'));
            for w = 1:length(this.WORKFOLDERS) % KLUDGE
                if (lstrfind(pth, this.WORKFOLDERS{w}))
                    pth = fileparts(trimpath(pth)); 
                end
            end
            this.sessionPath_ = pth;
        end
        function pth  = get.sessionPath(this)
            if (~isempty(this.sessionData_))
                pth = this.sessionData_.sessionPath;
                return
            end
            pth = this.sessionPath_;
        end
        function pth  = get.studyPath(this)            
            if (~isempty(this.sessionData_))
                pth = this.sessionData_.subjectsDir;
                return
            end
            pth = this.subjectsDir;
        end
        function pth  = get.subjectsDir(this)
            if (~isempty(this.sessionData_))
                pth = this.sessionData_.subjectsDir;
                return
            end
            pth = getenv('SUBJECTS_DIR');
        end
        function this = set.workPath(this, pth)
            assert(lexist(pth, 'dir'));
            this.workPath_ = trimpath(pth);
        end
        function pth  = get.workPath(this)
            pth = this.workPath_;
        end
        function e    = get.filetypeExt(this)
            e = mlfourd.NIfTId.FILETYPE_EXT;
        end
    end
    
    methods (Static)
        function [s,r,c] = cmd(exe, varargin)
            %% FSLCMD is a mini-facade to the FSL command-line
            %  [s,r] = FslVisitor.cmd(executable[, option, option2, ...])
            %                         ^ cmd name; without options, typically returns usage help 
            %                                      ^ structs, strings or cell-arrays of
            %  structs, strings and cells of options may be arranged to reflect cmd-line ordering 
            
            assert(ischar(exe));            
            args = ''; r = '';
            import mlfsl.*;
            for v = 1:length(varargin)
                args = sprintf('%s %s', args, FslVisitor.oany2str(varargin{v}, exe));
            end
            c = strtrim(sprintf('%s %s %s', exe, args, FslVisitor.outputRedirection));
            try
                [s,r] = mlbash(c);
                if (0 ~= s)
                    error('mlfsl:shellFailure', 'FslVisitor.cmd %s\nreturned %i', c, s); 
                end
            catch ME
                handexcept(ME,'mlfsl:shellError',r);
            end
        end 
        function msg     = help(exe)
            %% HELP returns cmd-line help in a single string
           
            assert(~isempty(exe));
            cmds = { '%s -h' '%s' '%s -?' }; msg = '';
            for c = 1:length(cmds)
                try
                    [~,v] = mlbash(sprintf(cmds{c}, exe));
                    if (~allempty(strfind(v, 'Usage')) && ~allempty(strfind(v, exe)))
                        msg = v;
                        break
                    end
                catch ME
                    handexcept(ME);
                end
            end
        end
        function str     = outputRedirection
            if (mlpipeline.PipelineRegistry.instance.logging)
                str = sprintf('>> %s 2>&1', ...
                             ['FslVisitor_' datestr(now,30) '.log']); %% KLUDGE 
            else
                str = '';
            end            
        end
        function fn      = thisOnThatExtFilename(ext, varargin)
            assert(ischar(ext));
            if (~strcmp(ext(1), '.'))
                ext = ['.' ext];
            end
            imfn = mlpipeline.PipelineVisitor.thisOnThatImageFilename(varargin{:});
            [p,n] = myfileparts(imfn);
            fn = fullfile(p, [n ext]);
        end   
        function imfn    = thisOnThatImageFilename(varargin)
            varargin{end} = imcast(varargin{end}, 'fqfilename');
            imfn = mlchoosers.ImagingChoosers.imageObject(varargin{:});
        end
        function           view(~)
            %% VIEW is a template method which may be subclassed
        end
    end
    
	methods 
 		function this = PipelineVisitor(varargin) 
 			%% PIPELINEVISITOR 
 			%  Usage:  this = PipelineVisitor([parameter_name, parameter_value]) 
            %                                  ^ logger, image, product, sessionPath, workPath
 			
            ip = inputParser;
            ip.KeepUnmatched = true;
            import mlpipeline.*;
            addOptional(ip, 'sessionData', [], @(x) isa(x, 'mlpipeline.SessionData'));
            addParameter(ip, 'logger',      mlpipeline.Logger,                @(l) isa(l, 'mlpipeline.Logger'));
            addParameter(ip, 'sessionPath', PipelineVisitor.guessSessionPath, @(v) lexist(v, 'dir'));
            addParameter(ip, 'studyPath',   getenv('SUBJECTS_DIR'),           @(s) lexist(s, 'dir'));
            addParameter(ip, 'subjectsDir', getenv('SUBJECTS_DIR'),           @(s) lexist(s, 'dir'));
            addParameter(ip, 'workPath',    PipelineVisitor.guessWorkpath,    @(v) lexist(v, 'dir')); 
            parse(ip, varargin{:});
            
            %% prefer using SessionData; use Logger within mlfourd.ImagingContext
            
            if (~isempty(ip.Results.sessionData))
                this.sessionData_ = ip.Results.sessionData;
                this.sessionPath_ = this.sessionData_.sessionPath;
                this.workPath_    = this.sessionData_.sessionPath;
                if (~strcmp(getenv('SUBJECTS_DIR'), this.sessionData_.subjectsDir))
                            setenv('SUBJECTS_DIR',  this.sessionData_.subjectsDir); 
                end
                return
            end
            
            %% legacy
            
            this.logged_     = ip.Results.logger; 
            this.sessionPath = ip.Results.sessionPath;
            if (~strcmp(getenv('SUBJECTS_DIR'), ip.Results.studyPath))
                        setenv('SUBJECTS_DIR',  ip.Results.studyPath);  end
            if (~strcmp(getenv('SUBJECTS_DIR'), ip.Results.subjectsDir))
                        setenv('SUBJECTS_DIR',  ip.Results.subjectsDir); end
            this.workPath    = ip.Results.workPath;
 		end 
    end 
    
    %% PROTECTED
    
    methods (Static, Access = 'protected')
        function str   = oany2str(obj, exe)
            import mlfsl.*;
            switch (class(obj))
                case 'char'
                    str = obj;
                case 'struct'
                    str = FslVisitor.ostruct2str(obj, exe);
                case 'cell'
                    str = FslVisitor.ocell2str(obj, true, false);
                case 'function_handle'
                    str = func2str(obj);
                otherwise
                    str = FslVisitor.otherwise2str(obj);
            end
        end
        function str   = otherwise2str(obj)
            if (isnumeric(obj))
                str = mat2str(obj);
            elseif (isa(obj, 'mlfourd.INIfTI'))
                str = obj.fqfilename;
            elseif (isobject(obj))
                try
                    str = char(obj);
                catch ME                
                    handexcept(ME);
                end
            else
                error('mfiles:unsupportedType', 'FslVisitor.otherwise2str does not support objects of type %s', class(ob));
            end
        end
        function str   = ocell2str(opts)
            assert(~isemptyCell(opts));
            opts = cellfun(@(x) [x ' '], opts, 'UniformOutput', false);
            str  = cell2str(opts);
        end
        function str   = ostruct2str(opts, ~)
            assert(~isstructEmpty(opts));
            fields = fieldnames(opts);
            str = '';
            for f  = 1:length(fields)
                assert(~isempty(fields{f}));
                if (~isemptyChar(opts.(fields{f})))
                    opts.(fields{f}) = ensureString(opts.(fields{f}));
                end                
                if (exist('exe','var'))
                    mlfsl.FslVisitor.assertOptionAllowed(fields{f}, exe);
                end
                assert(1 == length(opts))
                str = sprintf(' %s -%s %s', str,  fields{f}, opts.(fields{f}));
            end
        end
        function         assertOptionAllowed(opt, exe)
            warning('mlfsl:notImplemented', 'FslVisitor.assertOptionAllowed');
            assert(isstruct(opt));
            assert(ischar(exe));
            msg = mlfsl.FslVisitor.help(exe);
            fields = fieldnames(opt);
            for f = 1:length(fields)
                assert(lstrfind(fields{f}), msg);
            end
        end
    end 
    
    %% PRIVATE
    
    properties (Access = 'private')
        logged_
        sessionData_
        sessionPath_
        workPath_
    end
    
    methods (Static, Access = 'private')
        function pth   = guessSessionPath
            pth = pwd;     
            import mlpipeline.*;
            for w = 1:length(PipelineVisitor.WORKFOLDERS)
                pos = strfind(pth, PipelineVisitor.WORKFOLDERS{w});
                if (~isempty(pos))
                    pth = pth(1:pos-2);
                end
            end
        end
        function pth   = guessWorkpath
            pth = pwd;            
            import mlpipeline.*;
            for w = 1:length(PipelineVisitor.WORKFOLDERS)
                pos = strfind(pth, PipelineVisitor.WORKFOLDERS{w});
                if (~isempty(pos))
                    return;
                end
            end
        end   
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

