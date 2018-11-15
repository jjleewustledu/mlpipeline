classdef ResolvingSessionData < mlpipeline.SessionData
	%% RESOLVINGSESSIONDATA  

	%  $Revision$
 	%  was created 18-Aug-2017 16:40:39 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.2.0.538062 (R2017a) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties
        compAlignMethod  = 'align_multiSpectral'
        epoch
        frameAlignMethod = 'align_2051'
        %indexOfReference % INCIPIENT BUG
    end
       
    properties (Dependent)
        epochTag
        reference
        resolveTag
        rnumber
    end
    
	methods 
        
        %% GET/SET
        
        function g = get.epochTag(this)
            if (isempty(this.epoch))
                g = '';
                return
            end
            assert(isnumeric(this.epoch));
            if (1 == length(this.epoch))
                g = sprintf('e%i', this.epoch);
            else
                g = sprintf('e%ito%i', this.epoch(1), this.epoch(end));
            end
        end
        function g = get.reference(this)
            stbl = this.studyCensus.censusSubtable;
            this.vnumber = stbl.v_(1);
            g = this;
        end
        function g = get.resolveTag(this)
            if (~isempty(this.resolveTag_))
                g = this.resolveTag_;
                return
            end
            g = ['op_' this.tracerRevision('typ','fp')];
        end
        function this = set.resolveTag(this, s)
            assert(ischar(s));
            this.resolveTag_ = s;
        end  
        function g = get.rnumber(this)
            g = this.rnumber_;
        end
        function this = set.rnumber(this, r)
            assert(isnumeric(r));
            this.rnumber_ = r;
        end
        
        
        %%
		  
        function obj  = umapSynthOpT1001(this, varargin)
            t1   = this.T1001('typ', 'fp');
            fqfn = fullfile(this.vLocation, sprintf('umapSynth_op_%s_b40.4dfp.hdr', t1));
            obj  = this.fqfilenameObject(fqfn, varargin{2:end});
        end
        function tag  = resolveTagFrame(this, varargin)
            ip = inputParser;
            addRequired( ip, 'f', @isnumeric);
            addParameter(ip, 'reset', true, @islogical);
            parse(ip, varargin{:});
            
            if (ip.Results.reset)
                this.resolveTag = '';
            end
            tag = sprintf('%s_frame%i', this.resolveTag, ip.Results.f);
        end        
        function obj  = tracerEpoch(this, varargin)
            %% TRACEREPOCH is tracerRevision without the rnumber label.
            
            [ipr,schar] = this.iprLocation(varargin{:});
            fqfn = fullfile( ...
                this.tracerLocation('tracer', ipr.tracer, 'snumber', ipr.snumber, 'typ', 'path'), ...
                sprintf('%s%sv%i%s%s', lower(ipr.tracer), schar, this.vnumber, this.epochTag, this.filetypeExt));
            obj  = this.fqfilenameObject(fqfn, varargin{:});
        end
        
 		function this = ResolvingSessionData(varargin)
            % @param 'resolveTag' is char
            % @param 'rnumber'    is numeric
            
 			this = this@mlpipeline.SessionData(varargin{:});
            ip = inputParser;
            ip.KeepUnmatched = true;           
            addParameter(ip, 'resolveTag', '',   @ischar);
            addParameter(ip, 'rnumber', 1,            @isnumeric);
            parse(ip, varargin{:});             
            this.resolveTag_ = ip.Results.resolveTag;
            this.rnumber_    = ip.Results.rnumber;
 		end
    end 
    
    %% PROTECTED
    
    properties (Access = protected)
        resolveTag_
        rnumber_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

