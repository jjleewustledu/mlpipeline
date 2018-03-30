classdef Reporter 
	%% REPORTER accumulates string-data
    %  Version $Revision: 1613 $ was created $Date: 2012-08-23 23:09:13 -0500 (Thu, 23 Aug 2012) $ by $Author: jjlee $,
 	%  last modified $LastChangedDate: 2012-08-23 23:09:13 -0500 (Thu, 23 Aug 2012) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlpipeline/src/+mlpipeline/trunk/Reporter.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: Reporter.m 1613 2012-08-24 04:09:13Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

	properties (Access = 'protected')
        report_ % column-shaped
    end
    
    methods (Static)        
        
        function obj                   = readReport(fqfn)
            
            obj = mlpipeline.Reporter(sprintf('Report from Reporter.readReport(%s)', fqfn));
            try
                fid = fopen(fqfn);
                i   = 1;
                while 1
                    tline = fgetl(fid);
                    if (obj.hasXmlTag(tline))
                        obj.report_ = obj.xmlTagsToFields(tline, obj.report_);
                    end
                    if ~ischar(tline),   break,   end
                    obj.report_.lines{i} = tline;
                    i = i + 1;
                end
                fclose(fid);
            catch ME
                handexcept(ME);
            end
        end % static readReport  
        
        function obj                   = xmlToFields(astr, obj)
            [tag, val] = mlpipeline.Reporter.xmlTaggedValue(astr);
             obj.(tag) = val;
        end % static xmlToFields
        function [tag, val]            = xmlTaggedValue(astr)
            
            import mlpipeline.*;
            if (lstrfind(astr, '="'))
                [~, tag, val] = Reporter.xmlJoinedBrackets(astr);
            else
                   [tag, val] = Reporter.xmlSeparatedBrackets(astr);
            end
            if (isempty(tag)); tag = ''; end
            if (isempty(val)); val = ''; end
        end % static xmlTaggedValue
        function [tag, val]            = xmlSeparatedBrackets(astr)
            
            expr = '<(?<tag>\w+)>(?<val>\w+)</\k<tag>>';
            xml  = regexp(astr, expr, 'names');            
            tag  = xml.tag;
            val  = xml.val;
        end % static xmlSeparatedBrackets
        function [tag, subtag, subval, val] = xmlJoinedBrackets(astr)
            %tag    = ''; subtag = ''; subval = ''; val = '';
            expr   = '<(?<tag>\w+) (?<subtag>\w+)=.(?<subval>\w+).>(?<val>\w*)</\k<tag>>';
            xml    = regexp(astr, expr, 'names');
            tag    = xml.tag;
            subtag = xml.subtag;
            subval = xml.subval;
            val    = xml.val;
        end % static xmlJoinedBrackets
        
    end % static methods 
    
	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

 		function ca   = asCell(this)
            ca = this.report_.lines;
 		end % asCell
        function str  = asString(this)
            if (isfield(this.report_, 'title'))
                str = sprintf('<title>%s</title>\n', this.report_.title);
            end
            if (isfield(this.report_, 'subtitle'))
                str = sprintf('%s<subtitle>%s</subtitle>\n\n', str, this.report_.subtitle);
            end
            for r = 1:length(this.report_.lines)
                str = sprintf('%s%s\n', str, this.report_.lines{r});
            end            
        end % asString
        function sta  = asTextfile(this, fqfn)
            try
                fid = fopen(fqfn,'w');
                fprintf(fid, '%s\n', this.asString);
                sta = fclose(fid);
            catch ME
                handexcept(ME);
            end
        end % asTextfile
        function this = addStructArray(this, sa)
            %% ADDSTRUCTARRAY
            
            assert(isstruct(sa));
            length0 = length(this.report_.lines);
            this    = this.expandLines(sa);
            for s = 1:length(sa)  %#ok<*FORFLG,*PFUNK>
                this.report_.lines{length0+s} = struct2str(sa(s)); %#ok<*PFPIE>
            end
        end % addStructArray
        function this = addCellArray(this, ca)
            %% ADDCELLARRAY
            
            assert(iscell(ca));
            length0 = length(this.report_.lines);
            this    = this.expandLines(ca);
            for c = 1:length(ca)
                this.report_.lines{length0+c} = ca{c};
            end
        end % addCellArray
        
 		function this = Reporter(varargin)
 			%% REPORTER 
 			%  Usage:  obj = Reporter([title, subtitle]);
            
            this.report_ = struct([]);
            switch (nargin)
                case 0
                case 1
                    this.report_(1).title = varargin{1};
                otherwise
                    this.report_(1).title = varargin{1};
                    this.report_(1).subtitle = varargin{2};
            end
            this.report_.lines = {};
 		end % Reporter (ctor) 
    end % methods

    methods (Access = 'protected')
        
        function this = expandLines(this, toApp)
            %% EXPANDLINES expands this.report_ with empty cells
            %  Usage:   obj = obj.expandLines(to_append)
            
            if (isfield(this.report_, 'lines'))
                             lines0 = this.report_.lines;
                this.report_.lines  = cell(length(lines0)+length(toApp), 1);
                for n = 1:length(lines0)
                    this.report_.lines{n} = lines0{n};
                end
            else
                this.report_.lines  = cell(length(toApp),1);
            end
        end % expandLines
    end % protected methods
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

