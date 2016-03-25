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
    
    
    methods (Static)
        function [s,r,c] = cmd(exe, varargin)
            %% CMD is a mini-facade to the FSL command-line
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
        function fn      = thisOnThatImageFilename(varargin)
            %% THISONTHATIMAGEFILENAME 
            %  @param [varargin] are well-formed (fully-qual.) filenames.
            %  @returns an image filename specifying on the first and last nodes from a graph of registrations.
            
            assert(all(cellfun(@ischar, varargin)));
            try
                if (1 == length(varargin))
                    fn = filename(varargin{1});
                    return
                end
                nstruct = mlpipeline.PipelineVisitor.coregNameStruct(varargin{:});
                fn      = fullfilename(nstruct.path, ...
                                      [nstruct.pre mlfsl.FslRegistry.INTERIMAGE_TOKEN nstruct.post]);
            catch ME
                handexcept(ME);
            end
        end
    end
    
    %% PROTECTED
    
    methods (Static, Access = 'protected')
        
        %% FILENAME METHODS
        
        function nameStruct = coregNameStruct(varargin)
            %% COREGNAME 
            %  @param varargin[,...] are strings
            %  @returns a struct-array with string fields path, pre, post;
            %  dispatches to *2coregNameStruct methods that update path, pre, post so that 
            %  varargin{1} updates path, pre and varargin{N}, N = length(varargin), updates post.
            %  the coregistered name will have the form:   [char(varargin{1}) '_on_' char(varargin{N})]
            
            nameStruct = struct('path', '', 'pre', '', 'post', '');
            import mlpipeline.*;
            for v = 1:length(varargin)
                arg = imcast(varargin{v}, 'char');
                assert(~isempty(arg));
                assert( ischar( arg));
                nameStruct = PipelineVisitor.char2nameStruct(nameStruct, arg);
            end
            nameStruct = PipelineVisitor.finalizeNameStruct(nameStruct);
        end
        function nameStruct = char2nameStruct(nameStruct, strng)
            %% CHAR2NAMESTRUCT
            %  @param nameStruct with fields path, pre, post
            %  @param strng containing path, prefix, extension information
            %  @returns nameStruct with updated path, pre, post
            
            import mlpipeline.*;
            assert(ischar(strng));
            [pth,strng] = myfileparts(strng);
            if (isempty(nameStruct.path))
                nameStruct.path = pth; end
            if (isempty(nameStruct.pre))
                nameStruct.pre  = PipelineVisitor.beforeToken(strng); end
                nameStruct.post = PipelineVisitor.afterToken( strng);
        end
        function nameStruct = finalizeNameStruct(nameStruct)
            %% FINALIZENAMESTRUCT
            %  @param nameStruct with fields path, pre, post
            %  @returns nameStruct updated
            
            if (~isempty(nameStruct.path))
                assert(isdir(nameStruct.path)); 
            end
            nameStruct.pre  = fileprefix(nameStruct.pre);
            nameStruct.post = fileprefix(nameStruct.post);
        end
        function str        = beforeToken(str, varargin)
            %% BEFORETOKEN 
            %  @param str is a string possibly containing the token.
            %  @param tok is the char token.
            %  @returns the substring in front of the first token, excluding filename suffixes .mat/.nii.gz; 
            %  default is mlfsl.FslRegistry.INTERIMAGE_TOKEN
            
            import mlfsl.*;
            ip = inputParser;
            addRequired(ip, 'str', @ischar);
            addOptional(ip, 'tok', FslRegistry.INTERIMAGE_TOKEN, @ischar);
            parse(ip, str, varargin{:});
            
            str  = fileprefix(fileprefix(str, FlirtVisitor.XFM_SUFFIX));
            locs = strfind(str, ip.Results.tok);
            if (~isempty(locs))
                str = str(1:locs(1)-1);
            end
        end
        function str        = afterToken(str, varargin)
            %% AFTERTOKEN 
            %  @param str is a string possibly containing the token.
            %  @param tok is the char token.
            %  @returns the substring after the last token, excluding filename suffixes .mat/.nii.gz; 
            %  default is mlfsl.FslRegistry.INTERIMAGE_TOKEN
           
            import mlfsl.*;
            ip = inputParser;
            addRequired(ip, 'str', @ischar);
            addOptional(ip, 'tok', FslRegistry.INTERIMAGE_TOKEN, @ischar);
            parse(ip, str, varargin{:});
            
            str  = fileprefix(fileprefix(str, FlirtVisitor.XFM_SUFFIX));
            locs = strfind(str, ip.Results.tok);
            if (~isempty(locs))
                str = str(locs(end)+length(ip.Results.tok):end);
            end
        end
        
        %% OPTION METHODS
        
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
    end 
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

