classdef (Abstract) CcirJson
    %% CCIRJSON manages *.json and *.mat data repositories for CNDA-related data such as subjects, experiments, aliases.
    %  
    %  Created 23-Feb-2022 18:06:03 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlpipeline/src/+mlpipeline.
    %  Developed on Matlab 9.11.0.1873467 (R2021b) Update 3 for MACI64.  Copyright 2022 John J. Lee.
    
    methods (Static, Abstract)
        loadConstructed()
    end

    properties (Dependent)        
        sesFolders
        subFolders
    end

    methods
        
        %% GET

        function g = get.sesFolders(this)
            g = this.sesFolders_;
        end
        function g = get.subFolders(this)
            g = this.subFolders_;
        end

        %%

        function dt = datetime(this, varargin)
            dt = this.datetime_(varargin{:});
        end
        function S = struct(this)
            S = this.S_;
        end
        function T = table(this, varargin)
            xid = ascol(fields(struct(this)));
            subf = ascol(this.subFolders);
            sesf = ascol(this.sesFolders);
            dt = ascol(datetime(this));
            T = table(xid, subf, sesf, dt, ...
                'VariableNames', {'xid', 'subjectFolder', 'sesFolder', 'datetime'});
        end
        function sesf = tradt_to_sessionFolder(this, tradt)   
            re = regexp(tradt, '^[a-z]+dt(?<datetime>\d+)\S*', 'names');
            date = re.datetime(1:8);
            exp = this.date2experimentMap_(date);         
            exp = strsplit(exp, '_');
            sesf = ['ses-' exp{2}];
        end

        function this = CcirJson(varargin)
            this.S_ = this.loadConstructed();
            this.date2experimentMap_ = containers.Map;
            this = this.buildDate2experimentMap(this.S_);
            this.datetime_ = this.buildDatetime();
            this.sesFolders_ = this.buildSesFolders();
            this.subFolders_ = this.buildSubFolders();
        end
    end
    
    %% PROTECTED

    properties (Access = protected)
        S_
        datetime_
        date2experimentMap_
        sesFolders_
        subFolders_
        xidToSubFolder_
    end

    methods (Access = protected)
        function this = buildDate2experimentMap(this, node)
            for sub = asrow(fields(node))
                dates = node.(sub{1}).dates;
                for exp = asrow(fields(dates))
                    date = node.(sub{1}).dates.(exp{1});
                    this.date2experimentMap_(date) = exp{1};
                end
            end
        end
        function dt = buildDatetime(this)
            S = struct(this);
            xids = fields(S);
            dt = NaT(1, length(xids));
            for i = 1:length(xids)
                expment_ = S.(xids{i}).experiments;
                str = S.(xids{i}).dates.(expment_{1});
                try
                    dt(i) = datetime(str, 'InputFormat', 'yyyyMMddHHmmss');
                catch
                    dt(i) = datetime(str, 'InputFormat', 'yyyyMMdd');
                end
            end
        end
        function ca = buildSesFolders(this)
            S = struct(this);
            xids = fields(S);
            ca = cell(1, length(xids));
            for i = 1:length(xids)
                expment_ = S.(xids{i}).experiments;
                ss = strsplit(expment_{1}, '_');
                ca{i} = strcat('ses-', ss{2});
            end
        end
        function ca = buildSubFolders(this)
            S = struct(this);
            xids = fields(S);
            ca = cell(1, length(xids));
            for i = 1:length(xids)
                sid_ = S.(xids{i}).sid;
                ss = strsplit(sid_, '_');
                ca{i} = strcat('sub-', ss{2});
            end
        end
    end

    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
