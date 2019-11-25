classdef (Abstract) DicomSorter 
	%% DICOMSORTER  

	%  $Revision$
 	%  was created 05-Sep-2018 19:56:51 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
 	%% It was developed on Matlab 9.4.0.813654 (R2018a) for MACI64.  Copyright 2018 John Joowon Lee.

    methods (Abstract, Static)
        this  = Create(varargin)
        this  = CreateSorted(varargin)
    end
    
    methods (Abstract)
        fp = dcm2imagingFormat(this, varargin)
        g  = getDcmConverter(this)
    end
    
    methods (Static)
        function c = fillEmpty(c)
            if (isempty(c))
                c = num2str(rand);
            end
        end
    end
    
    properties
        cachedDcminfosFilename = 'DicomSorter_dcminfos_infos.mat';
        preferredInfoFields = {'SequenceName' 'SeriesDescription' 'ProtocolName' 'ImageType' 'SequenceName'}
        resetCached = false
        scansTags = {'scans' 'SCANS'}
    end

	properties (Dependent)
 		buildVisitor
        dcmConverter
        sessionData
        studyData
    end
    
	methods 
        
        %% GET/SET
        
        function g    = get.buildVisitor(this)
            g = this.buildVisitor_;
        end
        function g    = get.dcmConverter(this)
            g = this.getDcmConverter;
        end
        function sd   = get.sessionData(this)
            sd = this.sessionData_;
        end
        function sd   = get.studyData(this)
            assert(~isempty(this.sessionData_));
            sd = this.sessionData_.studyData;
        end
        
        %%
      
        function n       = canonicalName(this, info)
            %% CANONICALNAME 
            %  @param dcminfo result, a struct.
            %  @returns <info.SeriesDescription>_series<info.SeriesNumber>.
            
            assert(isstruct(info) && ~isempty(info));
            n = sprintf('%s_series%g', info.SeriesDescription, info.SeriesNumber);
            n = this.scrubCanonicalName(n);
        end
        function [infos,fqdns] = dcmInfos(this, varargin)
            %% DCMINFOS
            %  @param srcPath points to rawdata/SessionName, the top-level folder which is not 'SCANS'.  Default <- pwd.
            %  @returns infos, a cell array containing struct results of dcminfo acting in srcPath.
            %  @returns fqdns, a cell array containing /path/to/DICOM.
            
            ip = inputParser;
            addOptional(ip, 'srcPath', pwd, @isfolder); % top-level folder, not 'SCANS'
            parse(ip, varargin{:});
            
            import mlsystem.* mlio.*;
            pwd0 = pushd(ip.Results.srcPath);
            scans = DirTool('*');
            for iscan = 1:length(scans.fqdns)
                if (lstrfind(scans.fqdns{iscan}, this.scansTags))
                    cd(scans.fqdns{iscan});  
                    series = DirTool('*');
                    fqdns  = series.fqdns;
                    if (lexist(this.cachedDcminfosFilename, 'file') && ~this.resetCached)
                        load(this.cachedDcminfosFilename);
                        popd(pwd0);
                        return
                    end                    
                    infos  = cell(1, length(fqdns));
                    for iseries = 1:length(fqdns)
                        try
                            dcms = DirTool(fullfile(fqdns{iseries}, 'DICOM', ['*' mlpipeline.ResourcesRegistry.instance().dicomExtension]));
                            if (~isempty(dcms.fqfns))
                                infos{iseries} = dicominfo(dcms.fqfns{1});
                            end
                        catch ME
                            handwarning(ME);
                        end
                    end 
                    save(this.cachedDcminfosFilename, 'infos');
                end                
            end
            popd(pwd0);
        end    
        function [info, fqdn ] = findDcmInfo(this, ordinal, tofind, varargin)
            %% FINDDCMINFO
            %  @param ordinal is the index of desireable results from findDcmInfos:  1, 2, 3, ....
            %  @param tofind is a string or cell-array of strings for filtering information from dcminfo operating in srcPath.
            %  @param srcPath points to rawdata/SessionName but has the pwd as default.
            %  @returns info, the struct obtained from dcminfo.
            %  @returns fqdn, the /path/to/DICOM.
            
            assert(isnumeric(ordinal));
            [infos,fqdns] = this.findDcmInfos(tofind, varargin{:});
            assert(~isempty(infos));
            assert(~isempty(fqdns));
            info = infos{ordinal};
            fqdn = fqdns{ordinal};
        end
        function [infos,fqdns] = findDcmInfos(this, tofind, varargin)
            %% FINDDCMINFOS            
            %  @param tofind is a string or cell-array of strings for filtering information from dcminfo operating in srcPath.
            %  @param srcPath points to rawdata/SessionName but has the pwd as default.
            %  @returns infos, a cell array of info structs obtained from dcminfo.
            %  @returns fqdns, a cell array containing /path/to/DICOM.
            
            if (ischar(tofind))
                tofind = {tofind};
            end
            assert(iscell(tofind));
            
            [infos0,fqdns0] = this.dcmInfos(varargin{:});
            infos = {};
            fqdns = {};
            for idx = 1:length(infos0)
                for fdx = 1:length(tofind)
                    if (~isempty(infos0{idx}))
                        if (this.filterMatch(infos0{idx}, tofind{fdx})) %%%, 'fields', fields(infos0{idx})))
                            infos = [infos infos0{idx}]; %#ok<AGROW>
                            fqdns = [fqdns fqdns0{idx}]; %#ok<AGROW>
                        end
                    end
                end
            end
        end  
        function this          = sessionDcmConvert(this, varargin)
            ip = inputParser;
            ip.KeepUnmatched = true;
            addRequired( ip, 'srcPath',            @isfolder); % top-level folder for session raw data
            addOptional( ip, 'destPath', pwd,      @ischar);
            addParameter(ip, 'sessionData', [],      @(x) isa(x, 'mlpipeline.ISessionData'));
            addParameter(ip, 'seriesFilter', {[]}, @(x) iscell(x) || ischar(x));
            addParameter(ip, 'preferredInfoFields', {'SeriesDescription'}, @iscell);
            addParameter(ip, 'preferredName', 'unknown', @ischar);
            parse(ip, varargin{:});            
            if (~isfolder(ip.Results.destPath))
                mkdir(ip.Results.destPath);
            end
            
            import mlfourdfp.* mlsystem.* mlio.*;
            this.preferredInfoFields = ip.Results.preferredInfoFields;
            pwd0 = pushd(ip.Results.srcPath);
            [infos,fqdns] = this.findDcmInfos(ip.Results.seriesFilter);
            
            filteredNames = {};
            for idns = 1:length(fqdns)
                try
                    canonFp = this.dcm2imagingFormat(infos{idns}, fqdns{idns}, ip.Results.destPath);
                    if (~this.lexistConverted(fullfile(ip.Results.destPath, canonFp)))
                        movefile([canonFp '.*'], ip.Results.destPath);
                    end
                    canonFqfp = fullfile(ip.Results.destPath, canonFp);
                    filteredNames = [filteredNames canonFqfp]; %#ok<AGROW>
                catch ME
                    handwarning(ME);
                end
            end
            if (~isempty(filteredNames))
                this.usePreferredName(filteredNames, ip.Results.preferredName);
            end            
            popd(pwd0);
        end 
        function this          = sessionSort(this, varargin)
            %% SESSIONSORT sorts structural, TOF, ASL and BOLD.
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'srcPath',       @isfolder); % top-level folder for session raw data
            addParameter(ip, 'destPath', pwd, @ischar);
            addParameter(ip, 'sessionData', [], @(x) isa(x, 'mlpipeline.ISessionData'));
            addParameter(ip, 'ct', false, @islogical);
            parse(ip, varargin{:});

            if (this.isct(ip.Results))
                seriesList = {'AC_CT'};
                targetList = {'ct'};
            else
                seriesList = {'t1_mprage_sag' 't2_spc_sag' }; %'TOF' 'pcasl' 'ep2d_bold'
                targetList = {'mpr' 't2' }; %'tof' 'pcasl' 'bold'
            end
            for s = 1:length(seriesList)
                try
                    this = this.sessionDcmConvert( ...
                        ip.Results.srcPath, ip.Results.destPath, ...
                        'seriesFilter', seriesList{s}, ...
                        'sessionData', ip.Results.sessionData, ...
                        'preferredName', targetList{s});
                catch ME
                    dispwarning(ME);
                end
            end
        end
        
 		function this = DicomSorter(varargin)
            %% DICOMSORTER
            %  @param 'sessionData' is an mlpipeline.ISessionData; 
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'sessionData', [], @(x) isa(x, 'mlpipeline.ISessionData') || isempty(x));
            parse(ip, varargin{:});            
            this.sessionData_  = ip.Results.sessionData; 
            
            [~,found] = mlbash(['which ' this.dcmConverter]);
            assert(~isempty(found), 'mlfourd:unixError', [this.dcmConverter ' not found']);
 		end
 	end 
    
    %% PROTECTED
    
    properties (Access = protected)
        buildVisitor_
        sessionData_
    end
    
    methods (Static, Access = protected)                          
    end
    
    methods (Access = protected)
        function [s,r] = appendInfoFieldToIfh(~, info, ifield, canonFp)
            if (~isfield(info, ifield))
                return
            end
            if (isnumeric(info.(ifield)))
                str = sprintf('%s := %g', ifield, info.(ifield));
            else
                str = sprintf('%s := %s', ifield, info.(ifield));
            end
            [s,r] = mlbash(sprintf('echo "%s" >> %s.4dfp.ifh', str, canonFp));
        end
        function [s,r] = copyConverted(~, varargin)
            error('mlpipeline:NotImplementedError', 'DicomSorter.copyConverted');
        end      
        function re    = ctFolderRegexp(~, str)
            %% CTFOLDERREGEXP
            %  @param string for regexp.
            %  @returns regexp result with name:  subjid.
            
            assert(ischar(str));
            re = regexp(str, '(?<subjid>^([A-Za-z]+\d+|[A-Za-z]+\d+_\d+|[A-Za-z]+\d+-\d+))(_|-)[A-Za-z_-]+\w*', 'names');
        end    
        function tf    = filterMatch(this, varargin)
            %% FILTERMATCH
            %  @param info is a struct produced by dcminfo.
            %  @param tomatch is a filtering string.
            %  @param named 'fields' is a cell array of field names to inquire of info; default is
            %  this.preferredInfoFields.
            %  @returns tf, which is logical.
            
            ip = inputParser;
            addRequired( ip, 'info', @isstruct);
            addRequired( ip, 'tomatch', @(x) ~isempty(x) && ischar(x));
            addParameter(ip, 'fields', this.preferredInfoFields, @iscell);
            parse(ip, varargin{:});
            
            values = {};            
            for f = 1:length(ip.Results.fields)
                if (isfield(ip.Results.info, ip.Results.fields{f}))
                    value  = ip.Results.info.(ip.Results.fields{f});
                    if (ischar(value))
                        values = [values this.scrubCanonicalName(value)]; %#ok<AGROW>
                    end
                end
            end
            tf = lstrfind(values, ip.Results.tomatch);
        end  
        function tf    = isct(~, ipr)
            assert(isstruct(ipr));
            tf = ipr.ct || ...
                 lstrfind(ipr.srcPath, 'CT')  || ...
                 lstrfind(ipr.srcPath, 'CAL');
        end  
        function tf    = lexistConverted(this, varargin)
            error('mlpipeline:NotImplementedError', 'DicomSorter.lexistConverted');
        end
        function [s,r] = moveConverted(this, varargin)
            error('mlpipeline:NotImplementedError', 'DicomSorter.moveConverted');
        end 
        function n     = scrubCanonicalName(~, n)
            %% SCRUBCANONICALNAME removes '*', '[', ']', ' '; and replaces '<', '>', '(', ')', ':' with '_'.
            
            n = strrep(n, '*', '');
            n = strrep(n, '<', '_');
            n = strrep(n, '>', '_');
            n = strrep(n, '[', '');
            n = strrep(n, ']', '');
            n = strrep(n, '(', '_');
            n = strrep(n, ')', '_');
            n = strrep(n, ' ', '');
            n = strrep(n, ':', '_');
        end        
        function n     = scrubSubjectID(~, n)
            %% SCRUBSUBJECTID replaces '-' with '_'.
            
            n = strrep(n, '-', '_');
        end
        function names = sortBySeriesNumber(~, names)
            seriesNums = zeros(1,length(names));
            for n = 1:length(names)                
                re = regexp(names{n}, '\S+_series(?<series>\d+)\S*', 'names');
                seriesNums(n) = str2double(re.series);
            end
            tbl   = table(seriesNums', names', 'VariableNames', {'seriesNums' 'names'});
            tbl   = sortrows(tbl);
            names = tbl.names;
        end   
        function [s,r] = usePreferredName(this, filteredNames, preferredName)
            assert(iscell(filteredNames));
            assert(ischar(preferredName));
            
            pwd0 = pushd(myfileparts(filteredNames{1}));    
            filteredNames = this.sortBySeriesNumber(filteredNames);
            if (~this.lexistConverted(preferredName))
                [s,r] = this.moveConverted(filteredNames{1}, preferredName);
            end
            popd(pwd0);
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

