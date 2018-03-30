classdef StudyAlignmentDirector  
	%% STUDYALIGNMENTDIRECTOR orchestration alignemnt operations for entire NP-studies

	%  $Revision: 2631 $ 
 	%  was created $Date: 2013-09-16 01:19:51 -0500 (Mon, 16 Sep 2013) $ 
 	%  by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2013-09-16 01:19:51 -0500 (Mon, 16 Sep 2013) $ 
 	%  and checked into repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/src/+mlpipeline/trunk/StudyAlignmentDirector.m $,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id: StudyAlignmentDirector.m 2631 2013-09-16 06:19:51Z jjlee $ 
 	 

	methods 
        function this = alignPet(this, sessionPattern)
            
            dt = mlsystem.DirTools(sessionPattern);
            fprintf('StudyAlignmentDirector.alignPet:  \n\tpreparing sessions:  \n \t\t%s\n\n', cell2str(dt.dns));
            import mlpet.*;
            files  = {O15Builder.HO_MEANVOL_FILEPREFIX O15Builder.OO_MEANVOL_FILEPREFIX 'tr_default.nii.gz' 't1_default.nii.gz'};
            files2 = ['oc_default.nii.gz' files];
            pad    = mlpet.PETAlignmentDirector;
            for d = 1:length(dt.dns)
                try
                    if (lexist(fullfile(dt.fqdns{d}, 'fsl', 'oc_default.nii.gz'), 'file'))
                        fqfiles = cellfun(@(x) fullfile(dt.fqdns{d}, 'fsl', x), files2, 'UniformOutput', false);
                    else
                        fqfiles = cellfun(@(x) fullfile(dt.fqdns{d}, 'fsl', x), files, 'UniformOutput', false);
                    end
                    fprintf('.......... alignPet is working in %s\n', dt.fqdns{d});
                    pad.alignSequentially(fqfiles);
                catch ME
                    handwarning(ME);
                end
            end            
        end
        function this = StudyAlignmentDirector(varargin)
 			%% STUDYALIGNMENTDIRECTOR 
 			%  Usage:  this = StudyAlignmentDirector([anAlignmentBuilder]) 

            p = inputParser;
            addOptional(p, 'petbldr', mlpet.PETAlignmentBuilder, ...                
                      @(x) isa(x, 'mlpet.PETAlignmentBuilder'));
            addOptional(p, 'mrbldr',  mlmr.MRAlignmentBuilder, ...
                      @(x) isa(x, 'mlmr.MRAlignmentBuilder'));
            parse(p, varargin{:});
            this.petAlignmentBuilder_ = p.Results.petbldr;
             this.mrAlignmentBuilder_ = p.Results.mrbldr;

 		end 
 	end 
 
    properties (Access = 'private')
        petAlignmentBuilder_
         mrAlignmentBuilder_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

