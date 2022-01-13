classdef Bids < handle & matlab.mixin.Heterogeneous & matlab.mixin.Copyable  
	%% BIDS  

	%  $Revision$
 	%  was created 13-Nov-2021 14:58:16 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.11.0.1769968 (R2021b) for MACI64.  Copyright 2021 John Joowon Lee.
 	
	properties (Dependent)
        anatPath
        projPath
        derivativesPath
        destinationPath 		
        mriPath
        petPath
        rawdataPath
        sourcedataPath
        sourceAnatPath
        sourcePetPath
        subFolder
 	end

	methods 

        %% GET

        function g = get.anatPath(this)
            g = fullfile(this.derivativesPath, this.subFolder, 'anat', '');
            assert(isfolder(g))
        end
        function g = get.projPath(this)
            g = this.projPath_;
            assert(isfolder(g))
        end
        function g = get.derivativesPath(this)
            g = fullfile(this.projPath, 'derivatives', '');
            assert(isfolder(g))
        end
        function g = get.destinationPath(this)
            g = this.destPath_;
            assert(isfolder(g))
        end
        function g = get.mriPath(this)
            g = fullfile(this.derivativesPath, this.subFolder, 'mri', '');
            assert(isfolder(g))
        end
        function g = get.petPath(this)
            g = fullfile(this.derivativesPath, this.subFolder, 'pet', '');
            assert(isfolder(g))
        end
        function g = get.rawdataPath(this)
            g = fullfile(this.projPath, 'rawdata', '');
            assert(isfolder(g))
        end
        function g = get.sourcedataPath(this)
            g = fullfile(this.projPath, 'sourcedata', '');
            assert(isfolder(g))
        end
        function g = get.sourceAnatPath(this)
            g = fullfile(this.sourcedataPath, this.subFolder, 'anat', '');
            assert(isfolder(g))
        end
        function g = get.sourcePetPath(this)
            g = fullfile(this.sourcedataPath, this.subFolder, 'pet', '');
            assert(isfolder(g))
        end
        function g = get.subFolder(this)
            g = this.subFolder_;
        end

        %%
		  
 		function this = Bids(varargin)
            %  @param destPath will receive outputs.
            %  @projPath belongs to a CCIR project.
            %  @subFolder is the BIDS-adherent string for subject identity.

            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'destPath', pwd, @isfolder)
            addParameter(ip, 'projPath', @isfolder)
            addParameter(ip, 'subFolder', @ischar)
            parse(ip, varargin{:})
            ipr = ip.Results;
            this.destPath_ = ipr.destPath;
            this.projPath_ = ipr.projPath;
            this.subFolder_ = ipr.subFolder;
 		end
    end
    
    %% PRIVATE
    
    properties (Access = private)
        destPath_
        projPath_
        subFolder_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
end

