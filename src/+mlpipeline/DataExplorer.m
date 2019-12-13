classdef DataExplorer  
	%% DATAEXPLORER provides methods to survey imaging data from study populations
	%  $Revision: 2371 $
 	%  was created $Date: 2013-03-05 06:42:59 -0600 (Tue, 05 Mar 2013) $
 	%  by $Author: jjlee $, 
 	%  last modified $LastChangedDate: 2013-03-05 06:42:59 -0600 (Tue, 05 Mar 2013) $
 	%  and checked into repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/src/+mlpipeline/trunk/DataExplorer.m $, 
 	%  developed on Matlab 8.0.0.783 (R2012b)
 	%  $Id: DataExplorer.m 2371 2013-03-05 12:42:59Z jjlee $
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	properties
 		% N.B. (Abstract, Access=private, GetAccess=protected, SetAccess=protected, Constant, Dependent, Hidden, Transient)
        studyPaths
        products
 	end

	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

 		function this = manyPatientsManyModalitiesManySessionsManyRois(this, varargin)
 			%% MANYPATIENTSMANYMODALITIESMANYSESSIONSMANYROIS  
 			%  Usage:   this = this.manyPatientsManyModalitiesManySessionsManyRois([ ...
            %                  'patients', patient_list, ...
            %                  'modalities', modalities_list, ...
            %                  'sessions', sessions_list, ...
            %                  'rois', rois_list]) % lists are strings or cell-arrays; rois_list may be a column vector
            %                                      % ignoring a specifier loads all values of the specifier
            
            p = inputParser;
            addParamValue(p, 'patients', '*', @ischar);
            addParamValue(p, 'modalities', '*', @ischar);
            addParamValue(p, 'sessions', '*', @ischar);
            addParamValue(p, 'rois', '*', @(x) ischar(x) || isnumeric(x));
            parse(p, varargin{:});
            modalpths = this.modalityPaths(p.Results.patients, p.Results.sessions, p.Results.modalities);
            for m = 1:length(modalpths)
                dr = mlfourd.FslDirector.createFromModalPath(modalpths{m});
                dr.doAll;
            end            
 		end 
 		function this = onePatientOneModalityOneSession(this)
 			%% ONEPATIENTONEMODALITYONESESSION  
 			%  Usage:   
        end 
        function this = oneSeries(this, varargin)
            p = inputParser;
            addParamValue(p, 'fqfilename', @isfolder);
            parse(p, varargin{:});
            dr = mlfourd.FslDirector.createFromFilename(p.Results.fqfilename);
        end
        
        function slicesdir(this, set)
        end
        function fslview(this, set)
        end
        function osirix(this, set)
        end
 		function this = DataExplorer(studypths, varargin) 
 			%% DATAEXPLORER 
 			%  Usage:  obj = DataExplorer() 

            studypths = ensureCell(studypths);
            for p = 1:length(studypths)
                assert(lexist(studypths{p}, 'dir')); end
            this.studyPaths = studypths;
 		end %  ctor 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

