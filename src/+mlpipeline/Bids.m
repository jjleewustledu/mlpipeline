classdef (Abstract) Bids < handle & mlpipeline.IBids  
	%% BIDS  

	%  $Revision$
 	%  was created 13-Nov-2021 14:58:16 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.11.0.1769968 (R2021b) for MACI64.  Copyright 2021 John Joowon Lee.
 	
    methods (Static)
        function [s,r] = dcm2niix(varargin)
            ip = inputParser;
            addRequired(ip, 'folder', @isfolder)
            addParameter(ip, 'f', 'sub-%n_ses-%t-%d-%s', @istext) 
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
            addParameter(ip, 'i', 'n', @istext) % ignore derived, localizer and 2D images (y/n, default n)
            addParameter(ip, 'o', pwd, @isfolder) % output directory (omit to save to input folder)
            addParameter(ip, 'fourdfp', false, @islogical) % also create 4dfp
            addParameter(ip, 'version', [], @isnumeric)
            parse(ip, varargin{:})
            ipr = ip.Results;
            
            exe = 'dcm2niix';
            if ~isempty(ipr.version) && (ipr.version == 20180622 || ipr.version == 20180627)
                switch computer
                    case 'MACI64'
                        exe = 'dcm2niix_20180622';
                    case 'GLNXA64'
                        exe = 'dcm2niix_20180627';
                    otherwise
                end
            end           

            [~,wd] = mlbash(['which ' exe]);
            assert(~isempty(wd))            
            [~,wp] = mlbash('which pigz');
            if ~isempty(wp)
                z = 'y';
            else
                z = 'n';
            end
            if ~isfolder(ipr.o)
                mkdir(ipr.o)
            end
            
            [s,r] = mlbash(sprintf('%s -f %s -i %s -o %s -z %s %s', exe, ipr.f, ipr.i, ipr.o, z, ipr.folder));
            for g = globT(fullfile(ipr.o, '*.*'))
                if contains(g{1}, '(') || contains(g{1}, ')') 
                    fn = strrep(g{1}, '(', '_');
                    fn = strrep(fn,   ')', '_');
                    movefile(g{1}, fn)
                end
            end
            if ipr.fourdfp
                for g = globT(fullfile(ipr.o, '*.nii.gz'))
                    if ~isfile(strcat(myfileprefix(g{1}), '.4dfp.hdr'))
                        ic = mlfourd.ImagingContext2(g{1});
                        ic.fourdfp.save()
                    end
                end
            end
        end
        function fld = parseFolderFromPath(patt, pth)
            %  Args:
            %      patt (text): e.g., 'sub-', 'ses-'.
            %      pth (folder): from which to find 1st folder name matching patt.

            if contains(pth, patt)
                ss = strsplit(pth, filesep);
                fld = ss{contains(ss, patt)}; % picks first occurance
            end
        end
    end

    properties (Abstract, Constant)
        PROJECT_FOLDER % e.g., 'CCIR_01211'
        SURFER_VERSION % e.g., '7.2.0'
    end

	properties (Dependent)
        anatFolder
        anatPath
        derivAnatPath
        derivativesPath
        derivPetPath
        destinationPath
        mriFolder
        mriPath
        petFolder
        petPath
        projectPath
        rawdataPath
        sessionFolderAnat
        sessionFolderPet
        sourcedataPath
        sourceAnatPath
        sourcePetPath
        subjectFolder
        surferFolder
 	end

	methods 

        %% GET

        function g = get.anatFolder(~)
            g = 'anat';
        end
        function g = get.anatPath(this)
            g = this.derivAnatPath;
        end
        function g = get.derivAnatPath(this)
            g = fullfile(this.derivativesPath, this.subjectFolder, this.sessionFolderAnat, this.anatFolder, '');
        end
        function g = get.derivativesPath(this)
            g = fullfile(this.projectPath, 'derivatives', '');
        end
        function g = get.derivPetPath(this)
            g = fullfile(this.derivativesPath, this.subjectFolder, this.sessionFolderPet, this.petFolder, '');
        end
        function g = get.destinationPath(this)
            g = this.destinationPath_;
        end
        function g = get.mriFolder(~)
            g = 'mri';
        end
        function g = get.mriPath(this)
            g = fullfile(this.derivativesPath, this.surferFolder, this.mriFolder, '');
        end
        function g = get.petFolder(~)
            g = 'pet';
        end
        function g = get.petPath(this)
            g = this.derivPetPath;
        end
        function g = get.projectPath(this)
            g = this.projectPath_;
        end
        function g = get.rawdataPath(this)
            g = fullfile(this.projectPath, 'rawdata', '');
        end
        function g = get.sessionFolderAnat(this)
            g = this.sessionFolderAnat_;
        end
        function g = get.sessionFolderPet(this)
            g = this.sessionFolderPet_;
        end
        function g = get.sourcedataPath(this)
            g = fullfile(this.projectPath, 'sourcedata', '');
        end
        function g = get.sourceAnatPath(this)
            g = fullfile(this.sourcedataPath, this.subjectFolder, this.sessionFolderAnat, this.anatFolder, '');
        end
        function g = get.sourcePetPath(this)
            g = fullfile(this.sourcedataPath, this.subjectFolder, this.sessionFolderPet, this.petFolder, '');
        end
        function g = get.subjectFolder(this)
            g = this.subjectFolder_;
        end
        function g = get.surferFolder(this)
            g = strcat(this.subjectFolder, '_ses-surfer-v', this.SURFER_VERSION);
        end

        %%
		  
 		function this = Bids(varargin)
            %  Args:
            %      destinationPath (folder): will receive outputs.  Specify project ID & subject ID.
            %      projectPath (folder): belongs to a CCIR project.  
            %      subjectFolder (text): is the BIDS-adherent string for subject identity.
            %      subjectFolder (text): is the BIDS-adherent string for subject identity.

            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'destinationPath', pwd, @isfolder)
            addParameter(ip, 'projectPath', fullfile(getenv('SINGULARITY_HOME'), this.PROJECT_FOLDER, ''), @istext)
            addParameter(ip, 'subjectFolder', '', @istext)
            addParameter(ip, 'sessionFolderAnat', '', @istext)
            parse(ip, varargin{:})
            ipr = ip.Results;
            this.destinationPath_ = ipr.destinationPath;
            this.projectPath_ = ipr.projectPath;
            this.subjectFolder_ = ipr.subjectFolder;
            this.sessionFolderAnat_ = ipr.sessionFolderAnat;

            try
                if isempty(this.subjectFolder_)
                    this.subjectFolder_ = this.parseFolderFromPath('sub-', this.destinationPath_);
                end
            catch
                this.subjectFolder_ = '';
            end
            try
                if isempty(this.sessionFolderAnat_)
                    g = glob(fullfile(this.sourcedataPath, this.subjectFolder, 'ses-*', 'anat'));
                    this.sessionFolderAnat_ = this.parseFolderFromPath('ses-', g{end});
                end
            catch
                this.sessionFolderAnat_ = '';
            end
            try
                if isempty(this.sessionFolderPet_)
                    g = glob(fullfile(this.sourcedataPath, this.subjectFolder, 'ses-*', 'pet'));
                    this.sessionFolderPet_ = this.parseFolderFromPath('ses-', g{end});
                end
            catch
                this.sessionFolderPet_ = '';
            end
        end

        function icd = prepare_derivatives(this, ic)
            %% PREPARE_DERIVATIVES refreshes imaging in this.derivativesPath reoriented to the MNI standard and
            %  radiologic orientation.

            if ~isa(ic, 'mlfourd.ImagingContext2')
                ic = mlfourd.ImagingContext2(ic);
            end

            assert(isfile(ic.fqfn))

            icd = copy(ic);
            if ~contains(ic.filepath, this.derivativesPath) % copy to derivatives
                if contains(ic.filepath, this.anatFolder)
                    icd.filepath = this.derivAnatPath;
                end
                if contains(ic.filepath, this.petFolder)
                    icd.filepath = this.derivPetPath;
                end
                if ~isfolder(icd.filepath)
                    mkdir(icd.filepath);
                end
                mlbash(sprintf('cp -f %s %s', ic.fqfn, icd.filepath), 'echo', true);
                if isfile(strcat(ic.fqfp, '.json'))
                    mlbash(sprintf('cp -f %s %s', strcat(ic.fqfp, '.json'), icd.filepath), 'echo', true);
                end
                mlbash(sprintf('chmod -R 755 %s', icd.filepath));
            end
            if ~contains(icd.fileprefix, '_orient-std') && ~isfile(strcat(icd.fqfp, '_orient-std.nii.gz'))
                icd.reorient2std();  
                icd.selectNiftiTool();
                icd.save();
            end          
        end
    end
    
    %% PROTECTED
    
    properties (Access = protected)
        destinationPath_
        projectPath_
        sessionFolderAnat_
        sessionFolderPet_
        subjectFolder_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
end

