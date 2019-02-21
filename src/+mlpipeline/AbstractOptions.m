classdef AbstractOptions  
	%% ABSTRACTOPTIONS   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
    
    properties (Constant)
        INTERIMAGE_TOKEN = '_on_';
        XFM_SUFFIX = '.mat';
    end
    
	methods 
 		function s = char(this) 
            %% CHAR
            %  Usage:  for concrete subclasses, fieldnames and their field-values accumulate in a single string.
            %  Fieldnames containing 'pureArgument' have silent fieldnames, accumulating only their field-values.
            %  Pure arguments may be cell-arrays of strings.
            
 			flds = fieldnames(this);
            s = '';
            for f = 1:length(flds)
                if (~isempty(this.(flds{f})))
                    s = this.updateOptionsString(s, flds{f}, this.(flds{f})); end
            end
        end        
        function s = updateOptionsString(this, s, fldname, val)
            if (islogical(val))
                val = ' '; end
            if (isnumeric(val))
                val = num2str(val); end   
            if (lstrfind(fldname, this.PURE_ARGUMENT))
                s = this.updateOptionsStringWithPureArgument(s, val);
                return
            end            
            if (iscell(val))
                s = sprintf('%s -%s %s', s, fldname, cell2str(val, 'AsRow', true)); return; end
            s = sprintf(    '%s -%s %s', s, fldname, char(val));
        end
        function s = updateOptionsStringWithPureArgument(~, s, val)
            if (iscell(val))
                s = sprintf('%s %s', s, cell2str(val, 'AsRow', true)); return; end
            s = sprintf(    '%s %s', s, char(val));
        end
    end 
    
    methods (Access = 'protected')
        function imobj = imageObject(~, varargin)
            imobj = mlchoosers.ImagingChoosers.imageObject(varargin{:});
        end
        function xfm   = transformFilename(this, varargin)
            if (1 == length(varargin))
                xfm = myfilename(myfileprefix(char(varargin{1})), this.XFM_SUFFIX);
                return
            end
            
            nameStruct = mlpipeline.PipelineVisitor.coregNameStruct(varargin{:});
            xfm        = fullfile(nameStruct.path, ...
                                 [nameStruct.pre this.INTERIMAGE_TOKEN nameStruct.post this.XFM_SUFFIX]);
        end
        function str   = underscores2dashes(~, str)
            idxs = strfind(str, '_');
            for x = 1:length(idxs)
                str(idxs(x)) = '-';
            end
        end
    end
    
    properties (Access = 'protected')
        PURE_ARGUMENT = 'pureArgument';
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

