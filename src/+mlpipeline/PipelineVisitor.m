classdef PipelineVisitor
	%% PIPELINEVISITOR   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
    
    properties (Constant)
        WORKFOLDERS = {'fsl' 'mri' 'surf' 'ECAT_EXACT/pet'}
    end
 	     
    properties (Dependent)
        logger
        product
        sessionPath
        studyPath
        subjectsDir
        workPath
    end    

    methods %% GET/SET
        function this = set.logger(this, lggr)
            assert(isa(lggr, 'mlpipeline.Logger'));
            this.logged_ = lggr;
        end
        function lggr = get.logger(this)
            lggr = this.logged_;
        end
        function this = set.product(this, prd)
            this.product_ = mlfourd.ImagingContext(prd);
        end
        function prd  = get.product(this)
            assert(isa(this.product_, 'mlfourd.ImagingContext'));
            prd = this.product_;
        end
        function this = set.sessionPath(this, pth)
            assert(lexist(pth, 'dir'));
            if (lstrfind(pth, 'mri'))
                pth = fileparts(trimpath(pth)); end
            if (lstrfind(pth, 'fsl'))
                pth = fileparts(trimpath(pth)); end
            this.sessionPath_ = pth;
        end
        function pth  = get.sessionPath(this)
            pth = this.sessionPath_;
            assert(lexist(pth, 'dir'));
        end
        function pth  = get.studyPath(this)
            pth = this.subjectsDir;
        end
        function pth  = get.subjectsDir(~)
            pth = getenv('SUBJECTS_DIR');
        end
        function this = set.workPath(this, pth)
            assert(lexist(pth, 'dir'));
            this.workPath_ = trimpath(pth);
        end
        function pth  = get.workPath(this)
            if (isempty(this.workPath_))
                this.workPath_ = this.product.filepath; end
            pth = this.workPath_;
        end
    end
    
    methods (Static)
        function imfn  = thisOnThatImageFilename(varargin)
            len = length(varargin);
            varargin{len} = imcast(varargin{len}, 'fqfilename');
            imfn = mlchoosers.ImagingChoosers.imageObject(varargin{:});
        end
        function xfm   = thisOnThatXfmFilename(varargin)
            xfm = [mlpipeline.PipelineVisitor.thisOnThatImageFilename(varargin{:}) mlfsl.FlirtVisitor.XFM_SUFFIX];
        end
        function xfm   = thisOnThatDatFilename(varargin)
            xfm = mlpipeline.PipelineVisitor.thisOnThatImageFilename(varargin{:});
            xfm = mlsurfer.SurferFilesystem.datFilename('', fileprefix(xfm));
        end             
    end
    
	methods 
 		function this = PipelineVisitor(varargin) 
 			%% PIPELINEVISITOR 
 			%  Usage:  this = PipelineVisitor([parameter_name, parameter_value]) 
            %                                  ^ logger, image, product, sessionPath, workPath
 			
            p = inputParser;
            p.KeepUnmatched = true;
            import mlpipeline.*;
            addParameter(p, 'logger',      mlpipeline.Logger,                @(l) isa(l, 'mlpipeline.Logger'));
            addParameter(p, 'image',       []);
            addParameter(p, 'product',     []);
            addParameter(p, 'sessionPath', PipelineVisitor.guessSessionPath, @(v) lexist(v, 'dir'));
            addParameter(p, 'workPath',    PipelineVisitor.guessWorkpath,    @(v) lexist(v, 'dir')); 
            parse(p, varargin{:});
            
            this.logged_     = p.Results.logger; 
            this.product_    = p.Results.image;
            if (~isempty(p.Results.image))
            this.product_    = p.Results.product; end
            this.sessionPath = p.Results.sessionPath;
            this.workPath    = p.Results.workPath;
 		end 
    end 

    %% PRIVATE
    
    properties (Access = 'private')
        logged_
        product_
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

