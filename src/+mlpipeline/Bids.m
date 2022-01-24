classdef (Abstract) Bids < handle & matlab.mixin.Heterogeneous & matlab.mixin.Copyable  
	%% BIDS  

	%  $Revision$
 	%  was created 13-Nov-2021 14:58:16 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.11.0.1769968 (R2021b) for MACI64.  Copyright 2021 John Joowon Lee.
 	
    methods (Static)
        function dcm2niix(varargin)
            ip = inputParser;
            addRequired(ip, 'folder', @isfolder)
            addParameter(ip, 'f', 'sub-%n_ses-%t-%d-%s', @ischar) 
                % filename (%a=antenna  (coil) number, 
                %           %b=basename, 
                %           %c=comments, 
                %           %d=description, 
                %           %e=echo number, 
                %           %f=folder name, 
                %           %i=ID of patient, 
                %           %j=seriesInstanceUID, 
                %           %k=studyInstanceUID, 
                %           %m=manufacturer, 
                %           %n=name of patient, 
                %           %p=protocol, 
                %           %r=instance number, 
                %           %s=series number, 
                %           %t=time, 
                %           %u=acquisition number, 
                %           %v=vendor, 
                %           %x=study ID; 
                %           %z=sequence name; default 'twilite')
            addParameter(ip, 'i', 'n') % ignore derived, localizer and 2D images (y/n, default n)
            addParameter(ip, 'o', pwd) % output directory (omit to save to input folder)
            addParameter(ip, 'fourdfp', false, @islogical) % also create 4dfp
            parse(ip, varargin{:})
            ipr = ip.Results;
            
            [~,w] = mlbash('which dcm2niix');
            assert(~isempty(w))            
            [~,w] = mlbash('which pigz');
            if ~isempty(w)
                z = 'y';
            else
                z = 'n';
            end
            if ~isfolder(ipr.o)
                mkdir(ipr.o)
            end
            
            mlbash(sprintf('dcm2niix -f %s -i %s -o %s -z %s %s', ipr.f, ipr.i, ipr.o, z, ipr.folder))
            for g = globT(fullfile(ipr.o, '*.*'))
                if contains(g{1}, '(') || contains(g{1}, ')') 
                    fn = strrep(g{1}, '(', '_');
                    fn = strrep(fn,   ')', '_');
                    movefile(g{1}, fn)
                end
            end
            if ipr.fourdfp
                for g = globT(fullfile(ipr.o, '*.nii.gz'))
                    if ~isfile([myfileprefix(g{1}) '.4dfp.hdr'])
                        ic = mlfourd.ImagingContext2(g{1});
                        ic.fourdfp.save()
                    end
                end
            end
        end
    end

    properties (Abstract, Constant)
        projectFolder
    end

	properties (Dependent)
        anatPath
        derivAnatPath
        derivativesPath
        derivPetPath
        destinationPath 		
        mriPath
        petPath
        projPath
        rawdataPath
        sourcedataPath
        sourceAnatPath
        sourcePetPath
        subFolder
 	end

	methods 

        %% GET

        function g = get.anatPath(this)
            g = this.derivAnatPath;
        end
        function g = get.derivAnatPath(this)
            g = fullfile(this.derivativesPath, this.subFolder, 'anat', '');
        end
        function g = get.derivativesPath(this)
            g = fullfile(this.projPath, 'derivatives', '');
        end
        function g = get.derivPetPath(this)
            g = fullfile(this.derivativesPath, this.subFolder, 'pet', '');
        end
        function g = get.destinationPath(this)
            g = this.destPath_;
        end
        function g = get.mriPath(this)
            g = fullfile(this.derivativesPath, this.subFolder, 'mri', '');
        end
        function g = get.petPath(this)
            g = this.derivPetPath;
        end
        function g = get.projPath(this)
            g = this.projPath_;
        end
        function g = get.rawdataPath(this)
            g = fullfile(this.projPath, 'rawdata', '');
        end
        function g = get.sourcedataPath(this)
            g = fullfile(this.projPath, 'sourcedata', '');
        end
        function g = get.sourceAnatPath(this)
            g = fullfile(this.sourcedataPath, this.subFolder, 'anat', '');
        end
        function g = get.sourcePetPath(this)
            g = fullfile(this.sourcedataPath, this.subFolder, 'pet', '');
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
            addParameter(ip, 'projPath', fullfile(getenv('SINGULARITY_HOME'), this.projectFolder), @istext)
            addParameter(ip, 'subFolder', '', @istext)
            parse(ip, varargin{:})
            ipr = ip.Results;
            this.destPath_ = ipr.destPath;
            this.projPath_ = ipr.projPath;
            this.subFolder_ = ipr.subFolder;
        end

        function n = tracername(~, str)
            if contains(str, 'co', 'IgnoreCase', true) || contains(str, 'oc', 'IgnoreCase', true)
                n = 'CO';
                return
            end
            if contains(str, 'oo', 'IgnoreCase', true)
                n = 'OO';
                return
            end
            if contains(str, 'ho', 'IgnoreCase', true)
                n = 'HO';
                return
            end
            if contains(str, 'fdg', 'IgnoreCase', true)
                n = 'FDG';
                return
            end
            error('mlpipeline:ValueError', 'Bids.tracername() did not recognize %s', str)
        end
    end
    
    %% PROTECTED
    
    properties (Access = protected)
        destPath_
        projPath_
        subFolder_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
end

