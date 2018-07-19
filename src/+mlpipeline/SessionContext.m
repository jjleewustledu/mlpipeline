classdef SessionContext < mlpipeline.ISessionContext
	%% SESSIONCONTEXT  

	%  $Revision$
 	%  was created 28-May-2018 21:48:41 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.4.0.813654 (R2018a) for MACI64.  Copyright 2018 John Joowon Lee.
 	
	properties
        
 	end

	methods 
		
        %%
        
        function obj = aparcA2009sAseg(this, varargin)
            obj = this.freesurferObject('aparc.a2009s+aseg', varargin{:});
        end
        function obj = aparcAseg(this, varargin)
            obj = this.freesurferObject('aparc+aseg', varargin{:});
        end
        function obj = brainmask(this, varargin)
            obj = this.freesurferObject('brainmask', varargin{:});
        end
        function obj = T1001(this, varargin)
            obj = this.freesurferObject('T1', varargin{:});
        end
        
 		function this = SessionContext(varargin)
 			%% SESSIONCONTEXT
 			%  @param .

 		end
    end 
    
    %% PROTECTED
    
    methods (Access = protected)  
        function obj  = fqfilenameObject(this, varargin)
            %  @param named 'typ' has default 'fqfn'
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addRequired( ip, 'fqfn', @ischar);
            addParameter(ip, 'frame', nan, @isnumeric);
            addParameter(ip, 'tag', '', @ischar);
            addParameter(ip, 'typ', 'fqfn', @ischar);
            parse(ip, varargin{:});
            this.frame = ip.Results.frame;
            
            [pth,fp,ext] = myfileparts(ip.Results.fqfn);
            fqfn = fullfile(pth, [fp ip.Results.tag this.frameTag ext]);
            obj = imagingType(ip.Results.typ, fqfn);
        end
        function obj  = fqfileprefixObject(~, varargin)
            %  @param named 'typ' has default 'fqfp'
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addRequired( ip, 'fqfp', @ischar);
            addParameter(ip, 'tag', '', @ischar);
            addParameter(ip, 'typ', 'fqfp', @ischar);
            parse(ip, varargin{:});
            
            obj = imagingType(ip.Results.typ, [ip.Results.fqfp ip.Results.tag]);
        end
        function loc  = freesurferLocation(this, varargin)
            ip = inputParser;
            addParameter(ip, 'typ', 'path', @ischar);
            parse(ip, varargin{:});
            
            loc = locationType(ip.Results.typ, ...
                fullfile(this.freesurfersDir, [this.sessionLocation('typ', 'folder') '_' this.vLocation('typ', 'folder')], ''));
        end
        function obj  = freesurferObject(this, varargin)
            ip = inputParser;
            addRequired( ip, 'desc', @ischar);
            addParameter(ip, 'tag', '', @ischar);
            addParameter(ip, 'typ', 'mlfourd.ImagingContext', @ischar);
            parse(ip, varargin{:});
            
            obj = imagingType(ip.Results.typ, ...
                fullfile(this.freesurferLocation, 'mri', ...
                         sprintf('%s%s.mgz', ip.Results.desc, ip.Results.tag)));
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

