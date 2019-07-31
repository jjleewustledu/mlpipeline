classdef ResolvingSessionData < mlpipeline.BidsSessionData
	%% RESOLVINGSESSIONDATA  

	%  $Revision$
 	%  was created 14-Jun-2019 16:47:55 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.5.0.1067069 (R2018b) Update 4 for MACI64.  Copyright 2019 John Joowon Lee.
 	
	properties 		
        compAlignMethod = 'align_multiSpectral'
        epoch
        filetypeExt = '.4dfp.hdr'
        frameAlignMethod = 'align_2051'
        ignoreFinishMark = false
        itr = 4
        outfolder = 'output'
        reconstructionMethod = 'NiftyPET'
    end
    
    properties (Dependent)
        dbgTag
        epochTag
        frameTag
        maxLengthEpoch
        regionTag
        resolveTag
        rnumber
        supEpoch
    end

	methods 
        
        %% GET, SET
        
        function g    = get.dbgTag(~)
            if (~isempty(getenv('DEBUG')))
                g = '_DEBUG';
            else
                g = '';
            end
        end
        function g    = get.epochTag(this)
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
        function g    = get.frameTag(this)
            assert(isnumeric(this.frame));
            if (isnan(this.frame))
                g = '';
                return
            end
            g = sprintf('_frame%i', this.frame);
        end
        function g    = get.maxLengthEpoch(this)
            if (~this.attenuationCorrected)
                g = 8;
                return
            end 
            g = 16;
        end
        function g    = get.regionTag(this)
            if (isempty(this.region))
                g = '';
                return
            end
            if (isnumeric(this.region))                
                g = sprintf('_%i', this.region);
                return
            end
            if (ischar(this.region))
                g = sprintf('_%s', this.region);
                return
            end
            error('mlpipeline:TypeError', ...
                'ResolvingSessionData.get.regionTag');
        end
        function g    = get.resolveTag(this)
            if (~isempty(this.resolveTag_))
                g = this.resolveTag_;
                return
            end
            try
                g = ['op_' this.tracerRevision('typ','fp')];
            catch ME
                handwarning(ME);
                g = 'op_reference';
            end
        end
        function this = set.resolveTag(this, s)
            assert(ischar(s));
            this.resolveTag_ = s;
        end
        function g    = get.rnumber(this)
            g = this.rnumber_;
        end
        function this = set.rnumber(this, r)
            assert(isnumeric(r));
            this.rnumber_ = r;
        end
        function g    = get.supEpoch(this)
            if (~isempty(this.supEpoch_))
                g = this.supEpoch_;
                return
            end
            g = ceil(length(this.taus) / this.maxLengthEpoch);
        end
        function this = set.supEpoch(this, s) 
            assert(isnumeric(s));
            this.supEpoch_ = s;
        end
        
        %%
		  
 		function this = ResolvingSessionData(varargin)
 			%% RESOLVINGSESSIONDATA
            %  @param 'resolveTag' is char
            %  @param 'rnumber'    is numeric

 			this = this@mlpipeline.BidsSessionData(varargin{:});
            ip = inputParser;
            ip.KeepUnmatched = true;           
            addParameter(ip, 'resolveTag', '', @ischar);
            addParameter(ip, 'rnumber', 1, @isnumeric);
            parse(ip, varargin{:});
            this.resolveTag_ = ip.Results.resolveTag;
            this.rnumber_ = ip.Results.rnumber;
 		end
 	end 
    
    %% PROTECTED
    
    properties (Access = protected)
        resolveTag_
        rnumber_
        supEpoch_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

