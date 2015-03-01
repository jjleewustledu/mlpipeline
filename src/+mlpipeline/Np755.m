classdef Np755  
	%% NP755   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
    
    properties (Dependent)
        adc_fqfn
        adcCntxt
        bettedStandard_fqfn
        bettedStandardCntxt
        dwi_fqfn
        dwiCntxt
        ep2d_fqfn
        ep2dCntxt
        ep2dMean_fqfn
        ep2dMeanCntxt
        hoMean_fqfn
        hoMeanCntxt
        ir_fqfn
        irCntxt
        mad
        oc_fqfn
        ocCntxt
        ooMean_fqfn
        ooMeanCntxt
        pad
        stand_fqfn
        standCntxt
        t1_fqfn
        t1Cntxt
        bt1_fqfn
        bt1Cntxt
        t2_fqfn
        t2Cntxt
        tr_fqfn
        trCntxt
        workPath
    end
    
	methods (Static)
        function sessionWrapper(varargin)
            p = inputParser;
            addRequired(p, 'str',                                         @ischar);
            addOptional(p, 'hand', @mlpipeline.Np755.invmorph2bt1default, @(h) isa(h, 'function_handle'));
            parse(p, varargin{:});
            
            dt = mlfourd.DirTools(p.Results.str);
            for d = 1:length(dt.fqdns)
                fprintf('Np755.sessionWrapper:  calling %s within %s\n', func2str(p.Results.hand), dt.fqdns{d});
                p.Results.hand(fullfile(dt.fqdns{d}, 'fsl'));
            end
        end
        function this = morph2standard(varargin)
            import mlpipeline.*;
            this = Np755( ...
                   Np755.parseWorkpath(varargin{:}));
            try                
                [~,this.morphd_] = this.morphd_.morphSingle2standard(this.t1Cntxt);
            catch ME
                handwarning(ME);
            end
        end
        function this = morph2bettedStandard(varargin)
            import mlpipeline.*;
            this = Np755( ...
                   Np755.parseWorkpath(varargin{:}));
            try                
                [~,this.morphd_] = this.morphd_.morphSingle2bettedStandard(this.t1Cntxt);
            catch ME
                handwarning(ME);
            end
        end
        function this = invmorph2bt1default(varargin)
            import mlpipeline.*;
            this = Np755( ...
                   Np755.parseWorkpath(varargin{:}));
            try                
                [~,this.morphd_] = this.morphd_.invmorph2bt1default(this.bt1Cntxt);
            catch ME
                handwarning(ME);
            end
        end
        function this = betT1(varargin)
            import mlpipeline.*;
            this = Np755( ...
                   Np755.parseWorkpath(varargin{:}));
            try                
                mab  = mlmr.MRAlignmentBuilder('image', this.t1Cntxt);
                vtor = mlfsl.BrainExtractionVisitor;
                       vtor.visitMRAlignmentBuilder(mab);
            catch ME
                handwarning(ME);
            end
        end
        function this = petAlign(varargin)
            import mlpipeline.*;
            this = Np755( ...
                   Np755.parseWorkpath(varargin{:}));
            try
                collec = { this.ocCntxt this.ooMeanCntxt this.hoMeanCntxt this.trCntxt this.t1Cntxt };
                collec = imcast(collec,'mlfourd.ImagingComposite');
                this.pad.alignSequentially(collec);
            catch ME
                fprintf('WARNING:  %s', ME.message);
                try
                    collec = {          this.ooMeanCntxt this.hoMeanCntxt this.trCntxt this.t1Cntxt };
                    collec = imcast(collec,'mlfourd.ImagingComposite');
                    this.pad.alignSequentially(collec);
                catch ME2
                    handwarning(ME2);
                end
            end
        end
        function this = mrAlign(varargin)
            import mlpipeline.*;
            this = Np755( ...
                   Np755.parseWorkpath(varargin{:}));
            try                
                this.mad.alignPair(this.t2Cntxt, this.t1Cntxt);
            catch ME
                handwarning(ME);
            end
            try
                this.mad.alignDiffusion(this.dwiCntxt, this.adcCntxt, this.t2Cntxt);
            catch ME
                handwarning(ME);
            end
            try
                this.mad.motionCorrect(this.ep2dCntxt);
                this.mad.alignPerfusion(this.ep2dCntxt, this.t2Cntxt);
            catch ME
                handwarning(ME);
            end
        end
    end 
    
    methods %% GET
        function f = get.adc_fqfn(this)
            f = fullfile(this.workPath, 'adc_default');
        end
        function ic = get.adcCntxt(this)
            ic = mlfourd.ImagingContext.load(this.adc_fqfn);
        end   
        function f = get.bettedStandard_fqfn(this) %#ok<MANU>
            f = '/opt/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz';
        end
        function ic = get.bettedStandardCntxt(this)
            ic = mlfourd.ImagingContext.load(this.bettedStandard_fqfn);
        end
        function f = get.ep2d_fqfn(this)
            f = fullfile(this.workPath, 'ep2d_default');
        end
        function ic = get.ep2dCntxt(this)
            ic = mlfourd.ImagingContext.load(this.ep2d_fqfn);
        end
        function f = get.ep2dMean_fqfn(this)
            f = fullfile(this.workPath, 'ep2d_default_mcf_meanvol');
        end
        function ic = get.ep2dMeanCntxt(this)
            ic = mlfourd.ImagingContext.load(this.ep2dMean_fqfn);
        end
        function f = get.hoMean_fqfn(this)
            f = fullfile(this.workPath, mlpet.O15Builder.HO_MEANVOL_FILEPREFIX);
        end
        function ic = get.hoMeanCntxt(this)
            ic = mlfourd.ImagingContext.load(this.hoMean_fqfn);
        end
        function f = get.ir_fqfn(this)
            f = fullfile(this.workPath, 'ir_default');
        end
        function ic = get.irCntxt(this)
            ic = mlfourd.ImagingContext.load(this.ir_fqfn);
        end
        function m = get.mad(this)
            assert(isa(this.mad_, 'mlmr.MRAlignmentDirector'))
            m = this.mad_;
        end
        function f = get.oc_fqfn(this)
            f = fullfile(this.workPath, 'oc_default');
        end
        function ic = get.ocCntxt(this)
            ic = mlfourd.ImagingContext.load(this.oc_fqfn);
        end
        function f = get.ooMean_fqfn(this)
            f = fullfile(this.workPath, mlpet.O15Builder.OO_MEANVOL_FILEPREFIX);
        end
        function ic = get.ooMeanCntxt(this)
            ic = mlfourd.ImagingContext.load(this.ooMean_fqfn);
        end
        function p = get.pad(this)
            assert(isa(this.pad_, 'mlpet.PETAlignmentDirector'));
            p = this.pad_;
        end
        function f = get.stand_fqfn(this) %#ok<MANU>
            f = '/opt/fsl/data/standard/MNI152_T1_2mm.nii.gz';
        end
        function ic = get.standCntxt(this)
            ic = mlfourd.ImagingContext.load(this.stand_fqfn);
        end
        function f = get.t1_fqfn(this)
            f = fullfile(this.workPath, 't1_default');
        end
        function ic = get.t1Cntxt(this)
            ic = mlfourd.ImagingContext.load(this.t1_fqfn);
        end
        function f = get.bt1_fqfn(this)
            f = fullfile(this.workPath, 'bt1_default_restore');
        end
        function ic = get.bt1Cntxt(this)
            ic = mlfourd.ImagingContext.load(this.bt1_fqfn);
        end
        function f = get.t2_fqfn(this)
            f = fullfile(this.workPath, 't2_default');
        end
        function ic = get.t2Cntxt(this)
            ic = mlfourd.ImagingContext.load(this.t2_fqfn);
        end   
        function f = get.tr_fqfn(this)
            f = fullfile(this.workPath, 'tr_default');
        end
        function ic = get.trCntxt(this)
            ic = mlfourd.ImagingContext.load(this.tr_fqfn);
        end
        function w = get.workPath(this)
            assert(lexist(this.workPath_, 'dir') && lstrfind(this.workPath_, 'fsl'));
            w = this.workPath_;
        end
        
    end

    methods
        function this = Np755(workpth)
            assert(lexist(workpth, 'dir'));
            this.workPath_ = workpth;
            cd(this.workPath);
            
            import mlmr.* mlpet.* mlfsl.*;
            this.mab_ = MRAlignmentBuilder('reference', this.t1Cntxt);
            this.mad_ = MRAlignmentDirector( ...
                        AlignmentDirector(this.mab_));
            this.pad_ = PETAlignmentDirector( ...
                        AlignmentDirector( ...
                        PETAlignmentBuilder('reference', this.t1Cntxt)));                    
            this.morphd_ = MorphingDirector( ...
                           AlignmentDirector( ...
                           MorphingBuilder('reference', this.bettedStandardCntxt)));
        end
    end
    
    %% PRIVATE
    
    properties (Access = 'private')
        mab_
        mad_
        morphd_
        pad_
        workPath_
    end
    
    methods (Static, Access = 'private')
        function wp = parseWorkpath(varargin)
            p = inputParser;
            addOptional(p, 'workpth', pwd, @(w) lexist(w, 'dir') && lstrfind(w, 'fsl'));
            parse(p, varargin{:});
            wp = p.Results.workpth;
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

