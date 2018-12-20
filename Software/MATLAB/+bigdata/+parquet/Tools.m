classdef Tools < bigdata.parquet.util.Core & bigdata.parquet.util.ParquetCommon
    % Get information on a Parquet file
    %
    % CAT    Prints the content of a Parquet file. The output contains only
    % the data, no metadata is displayed.
    % WARNING: This can dump a lot of data to the command window and take a
    % long to display, you generally dont want to use this for large files.
    %
    % HEAD   Prints the first n record of the Parquet file
    %
    % SCHEMA Prints the schema of Parquet file(s)
    %
    % META   Prints the metadata of Parquet file(s)
    %
    % DUMP   Prints the content and metadata of a Parquet file
    %
    % MERGE  Merges multiple Parquet files into one. The command doesn't
    % merge row groups, just places one after the other. When used to merge
    % many small files, the resulting file will still contain small row
    % groups, which usually leads to bad query performance.
    %
    % Example: Get detailed meta information
    %
    %   import bigdata.parquet.Tools;
    %
    %   Tools.meta('tmp.parquet')
    %
    % See also parquettools
    
    % Copyright (c) 2017, The MathWorks, Inc.
    
    properties
        ToolPath
    end
    
    methods
        function obj = Tools
            % Constructor
            
            jar = dir(obj.getResourcesFolder('jar','*.jar'));
            obj.ToolPath = fullfile(jar.folder,jar.name);
        end
        
        function cat(obj,varargin)
            %  Prints the content of a Parquet file
            %
            % The output contains only the data, no metadata is displayed.
            %
            % WARNING: This can dump a lot of data to the command window
            % and take a long to display, you generally dont want to use
            % this for large files.
            
            obj.run('cat',varargin{:})
        end
        
        function head(obj,varargin)
            % Prints the first n record of the Parquet file
            %
            % Example: Print first 10 lines of tmp.parquet
            %
            %   bigdata.parquet.Tools.head('-n 10','tmp.parquet')
            
            obj.run('head',varargin{:})
        end
        
        function schema(obj,varargin)
            % Prints the schema of Parquet file(s)
            
            obj.run('schema',varargin{:})
        end
        
        function meta(obj,varargin)
            % Prints the metadata of Parquet file(s)
            
            obj.run('meta',varargin{:})
        end
        
        function dump(obj,varargin)
            % Prints the content and metadata of a Parquet file
            
            obj.run('dump',varargin{:})
        end
        
        function merge(obj,varargin)
            % Merges multiple Parquet files into one
            %
            % The command doesn't merge row groups, just places one after
            % the other. When used to merge many small files, the resulting
            % file will still contain small row groups, which usually leads
            % to bad query performance.
            
            obj.run('merge',varargin{:})
        end
        
        function help(obj)
            % Get help for parquet-tools
            
            m = {'cat','head','schema','meta','dump','merge'};          
            cellfun(@(x) obj.(x)('-h'), m);
        end
    end
    
    methods(Access=private)
        function run(obj,varargin)
            % Run the given parquet-tools command
            
            if nargin == 1
                system(['java -jar "',obj.ToolPath,'" --help']);
            else
                if nargin == 2
                    varargin{end + 1} = '-h';
                end
                system(['java -jar "',obj.ToolPath,'" ',sprintf('%s ',varargin{:})]);
            end
        end
    end
end
