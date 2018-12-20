classdef Reader < bigdata.parquet.util.Core & bigdata.parquet.util.ParquetCommon
    % Class for reading Parquet files
    %
    % Example: Read in at most 100 rows from a Parquet file
    %
    %   import bigdata.parquet.Reader
    %   p = Reader('FileName','tmp.parquet','MaxRows',100)
    %   data = p.read;
    %
    % See also bigdata.parquet.Reader/read, bigdata.parquet.Writer
    
   % Copyright (c) 2017, The MathWorks, Inc.
    
    properties
        % Fields to fetch as a string array, empty string returns all fields
        FetchFields string
        
        % Replace null/missing values with the MATLAB missing value
        ReplaceMissing bigdata.parquet.enum.Boolean  = false;
    end
    
    properties(SetObservable)
        % FileName to read
        FileName char
        
        % Number of rows to read, if < 0 read all rows in file
        MaxRows double {mustBeInteger} = 1e7;
    end
    
    properties(SetAccess = private, Hidden)
        % An instance of the Reader
        JavaHnd
        
        % The returned field names
        FieldNames
    end
    
    methods
        function obj = Reader(varargin)
            % Constructor for Parquet Reader
            %
            % You can pass in property/value pairs
            %
            % Example: Pass in the file and MaxRows to read
            %
            %   import bigdata.parquet.Reader;
            %   p = Reader('FileName','tmp.parquet','MaxRows',1000)
            %
            % READER
            
            obj.JavaHnd = com.mathworks.bigdata.parquet.Reader;
            obj.construct(varargin{:})
        end
        
        function delete(obj)
            obj.JavaHnd.close();
            obj.JavaHnd = [];
        end
        
        function data = read(obj,varargin)
            % Read the Parquet file into a table
            %
            % You can pass in property/value pairs such as MaxRows and
            % which fields to read
            %
            % Example: Read in only fields 'height','weight'
            %
            % p.read('FetchFields',{'height','weight'})
            %
            % NOTE Any properties you pass such as FetchFields will be used
            % in subsequent calls to read unless you either change them or
            % create a new instance of Parquet Reader.
            %
            % READ
            
            obj.parseInputs(varargin{:})
            
            % Check if file exists
            if isempty(obj.FileName)
                error('''FileName'' property can not be empty')
            else
                pre    = "file:///";
                if isunix || ismac
                    pre = "file://";
                end
                if ~ isfile(regexprep(obj.FileName,pre,''))
                    error(['Problem reading file:', newline, ...
                        regexprep(obj.FileName,pre,''), ...
                        newline, 'Check the name of the file.'])
                end
            end
            
            % Get the data
            data = cell(obj.JavaHnd.getData(obj.FetchFields));
            
            % Get any extra metadata for Formating datetime/durations
            md = obj.JavaHnd.getParquetFileReader.getFileMetaData.getKeyValueMetaData;
            
            typeNames   = data{end - 1};
            fieldNames  = data{end - 2};
            logicalType = data{end};
            
            for j = 1 : length(fieldNames)
                logicalValue = '';
                if ~ isempty(logicalType.get(j - 1))
                    logicalValue = char(logicalType.get(j - 1).toString);
                elseif strcmp(typeNames.get(j - 1),'INT96')
                    logicalValue = 'INT96';
                end
                if ~ isempty(logicalValue)
                    % If Parquet logical exists convert to correct datatype
                    [data{j},fieldNames{j}] = obj.convertToMatlab(data{j},...
                        logicalValue, fieldNames{j}, md);
                end
            end
            
            ind = 1 : length(fieldNames);
            
            mlType = md.get('matlab.datatype');
            if isempty(mlType)
                % Data not written by MATLAB, 'matlab.datatype' key does
                % not exist. Turn into a 'table' by default.
                mlType = 'table';
            end
            
            % The underlying data type if Parquet file was written by MATLAB
            switch mlType
                case 'timetable'
                    % First column is the RowTimes
                    ind  = setdiff(ind, 1);
                    data = timetable(data{1}, data{ind},...
                        'VariableNames', fieldNames(ind));
                    data.Properties.DimensionNames{1} = fieldNames{1};
                case 'table'
                    data = table(data{ind}, 'VariableNames', fieldNames);
                case 'table-rownames'
                    ind = 2 : length(ind);
                    data = table(data{ind}, ...
                        'VariableNames', fieldNames(ind),...
                        'RowNames',cellstr(data{1}));
                case 'struct'
                    data = cell2struct(data(ind), fieldNames);
                case 'cell'
                    data = data(ind);
                otherwise
                    % Array
                    data = [data{ind}];
            end
            
            % Replace missing values if needed
            obj.FieldNames = fieldNames;
            if obj.ReplaceMissing
                data = obj.addMissing(data);
            end
        end
        
        function data = addMissing(obj,data)
            % Replace missing values in the data with the MISSING datatype
            %
            % This function will convert integer types to double as they
            % are not available to be used with missing. You may not want
            % to use this feature for that reason.
            %
            % If the ReplaceMissing property is TRUE this method gets
            % called automatically. For performance when reading files you
            % may want to set it to FALSE and deal with missing values
            % later.
            %
            % Example: Read in data with ReplaceMissing set to false
            %
            %   [data, reader] = parquetread('tmp.parquet','ReplaceMissing',false);
            %
            % Find the mising values and replace with missing datatype
            %
            %   data = reader.addMising(data);
            %
            % See also bigdata.parquet.Reader/getMissingIndices
            
            % Get the index for the missing data, (row1,col1,row2,col2,...)
            missingIndex = obj.JavaHnd.getMissingDataIndex + 1;
            
            if ~ isempty(missingIndex)
                type = class(data);
                
                % column/fields with missing values
                colVals = unique(missingIndex(2 : 2 : end));
                
                for j = 1 : length(colVals)
                    cj = colVals(j);
                    switch type
                        case {'timetable','table','struct'}
                            if isa(data.(obj.FieldNames{cj}),'integer')
                                data.(obj.FieldNames{cj}) = double(data{:,cj});
                            end
                        case 'cell'
                            if isa(data{1,cj},'integer')
                                data{1,cj} = double(data{1,cj});
                            end
                        otherwise
                            if isa(data(1,cj),'integer')
                                data(1,cj) = double(data(1,cj));
                            end
                    end
                end
                
                indRow = missingIndex(1 : 2 : end);
                indCol = missingIndex(2 : 2 : end);
                
                for ind = 1 : numel(colVals)
                    data.(colVals(ind))(indRow(indCol == colVals(ind))) = missing;
                end
            end
        end
        
        function out = getMissingIndices(obj)
            % Return as a vector the row/column pairs where data is missing
            %
            % OUT is a [ROW_1, COL_1, ... , ROW_N, COL_N] that indicates
            % the location of missing value in the returned data.
            %
            % Thus DATA{OUT(1),OUT(1)} would be the first missing value
            %
            % To add the missing datatype to these locations call the
            % ADDMISSING method
            %
            % See also bigdata.parquet.Reader/addMissing
            
            out = obj.JavaHnd.getMissingDataIndex + 1;
        end
        
        function out = getSchema(obj)
            % Return the schema for the parquet file
            %
            % GETSCHEMA
            
            out = obj.JavaHnd.getParquetFileReader.getFileMetaData.getSchema;
        end
        
        function out = getFieldNames(obj)
            % Get the field names present in the file
            %
            % GETFIELDNAMES
            
            out = cell(obj.JavaHnd.getFieldNames(obj.getSchema));
        end
        
        function out = getNumRows(obj)
            % Get the number of rows in the file
            %
            % GETNUMROWS
            
            out = obj.JavaHnd.getParquetFileReader.getRecordCount;
        end
        
        function set.FileName(obj, file)
            % Set the FileName property and check for validity
            %
            % SET.FILE
            
            obj.FileName = obj.validateFile(file);
        end
        
        function out = getMetadata(obj)
            % Get the metadata and return as a JSON struct
            %
            % GETMETADATA
            
            out = jsondecode(char(obj.JavaHnd.getMetadata));
        end
    end
    
    methods(Static, Access = private)
        function [v, fieldName] = convertToMatlab(...
                v,parquetLogical,fieldName, metaData)
            % Convert to the correct MATLAB type from Parquet
            %
            % DATA        - The returned MATLAB datatype
            % FIELDNAME   - The field name
            
            import bigdata.parquet.enum.Types;
            
            % function for generating key string
            fmtfun = @(x)[fieldName,'.matlab.',x,'.Format'];
            fmt    = [];
            
            switch parquetLogical
                case Types.DATE.Logical
                    v = datetime(v * 86400,'ConvertFrom','posixtime',...
                        'Format','defaultdate');
                    fmt = fmtfun('datetime');
                case Types.DURATION_MILLIS.Logical
                    v = duration(0,0,0,v);
                    fmt = fmtfun('duration');
                case Types.DURATION_MICROS.Logical
                    v = duration(0,0,0,v / 1e7);
                    fmt = fmtfun('duration');
                case {Types.DATETIME_MILLIS.Logical,...
                        Types.DATETIME_MICROS.Logical}
                    v = datetime(double(v) / 1e7,'ConvertFrom','posixtime');
                    fmt = fmtfun('datetime');
                case Types.DATETIME_MILLIS_INT96.Logical
                    v = datetime(double(v),'ConvertFrom','posixtime');
                    fmt = fmtfun('datetime');
                case Types.STRING.Logical
                    v = string(v);
            end
            
            % Apply same format to datetime/duration as original data
            if metaData.containsKey(fmt)
                v.Format = metaData.get(fmt);
            end
        end
    end
end