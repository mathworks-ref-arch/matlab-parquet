classdef Writer < bigdata.parquet.util.Core & bigdata.parquet.util.ParquetCommon
    % Class for writing Parquet files
    %
    %
    % See also bigdata.parquet.Writer/write, bigdata.parquet.Reader
    
    % Copyright (c) 2017, The MathWorks, Inc.
    
    properties(SetObservable, AbortSet)
        % FileName to write
        FileName char
        
        % The Parquet file schema, this can be a string/char or MessageType
        Schema {bigdata.parquet.Writer.mustBeStringOrMessageType} = '';
        
        % The compression codec to use
        CompressionCodec bigdata.parquet.enum.Compression = ...
            bigdata.parquet.enum.Compression.SNAPPY;
        
        % Enable/disable dictionary encoding
        DictionaryEncoding bigdata.parquet.enum.Boolean  = true;
        
        % Max RowGroup padding size
        MaxPaddingSize(1,1) double ...
            {mustBeInteger, mustBeNonnegative, mustBeFinite} = 0;
        
        % The page size in bytes
        PageSize(1,1) double ...
            {mustBeInteger, mustBePositive, mustBeFinite} = ...
            bigdata.parquet.Writer.bytes('8M');
        
        % The RowGroup size in bytes, should be same as HDFS block size
        RowGroupSize(1,1) double ...
            {mustBeInteger, mustBePositive, mustBeFinite} = ...
            bigdata.parquet.Writer.bytes('128M');
        
        % Validate the file has been written
        Validation bigdata.parquet.enum.Boolean = true;
        
        % Write mode being used
        WriteMode bigdata.parquet.enum.WriteMode = ...
            bigdata.parquet.enum.WriteMode.CREATE;
        
        % Writer version being used
        WriterVersion bigdata.parquet.enum.WriterVersion = ...
            bigdata.parquet.enum.WriterVersion.PARQUET_2_0;
        
        % Select TRUE to delete any generated checksum CRC files
        DeleteCRC bigdata.parquet.enum.Boolean = true;
        
        % Append the data being written to current open writer
        AppendData bigdata.parquet.enum.Boolean = false;
    end
    
    properties(SetAccess = private, Hidden)
        % An instance of the Writer
        JavaHnd
    end
    
    properties
        % If set to true will try to auto-generate schema from data
        AutoGenerateSchema bigdata.parquet.enum.Boolean = true;
        
        % Number of rows to write
        MaxRows(1,1) double ...
            {mustBeInteger, mustBePositive, mustBeFinite} = 1e6;
        
        % The data we will be writing
        Data
        
        % File metadata entry of the form ["key", "value"]
        MetaData(:,2) string;
    end
    
    methods
        function obj = Writer(varargin)
            % Constructor for Parquet Writer
            %
            % You can pass in property/value pairs
            %
            % Example: Create a writer that will write to 'temp.parquet'
            %
            %   writer = bigdata.parquet.Writer('FileName','tmp.parquet')
            
            obj.JavaHnd = com.mathworks.bigdata.parquet.Writer;
            obj.construct(varargin{:})
        end
        
        function write(obj,data,varargin)
            % Write data to Parquet file
            %
            % WRITE(DATA, Property, Value,...) Write the DATA to file, this
            % can be followed by additional Property/Value pairs.
            %
            %   Example: Write a table to a Parquet file
            %
            %       % Initialize the Writer
            %       import bigdata.parquet.*;
            %       writer = Writer('FileName','tmp.parquet');
            %
            %       % Create table of values
            %       rows = 100;
            %       cols = 2;
            %       maxi = 65536;
            %       data = array2table([(1 : rows)', randi(maxi,rows,cols)]);
            %
            %       % Add some RowNames, we will write these too.
            %       data.Properties.RowNames = cellstr("Row"+(1:100))';
            %
            %       % Overwrite existing tmp Parquet file
            %       writer.WriteMode = 'OVERWRITE';
            %       writer.write(data)
            %
            % WRITE
            
            % Check when running under Windows
            obj.checkForHadoopHome

            % Parse any property/value pairs
            obj.parseInputs(varargin{:})
            
            % Check if file exists
            if isempty(obj.FileName)
                error('''FileName'' property can not be empty')
            elseif obj.WriteMode ~= bigdata.parquet.enum.WriteMode.OVERWRITE
                pre    = "file:///";
                if isunix || ismac
                    pre = "file://";
                end
                if isfile(regexprep(obj.FileName,pre,''))
                    error([obj.FileName,' exists, choose different filename, ',...
                        'delete existing filename or set ''WriteMode'' property to OVERWRITE'])
                end
            end
            
            % Reset the metadata
            obj.MetaData = [];
            if nargin > 1 && ~ isempty(data)
                obj.Data = data;
            end
            
            if obj.AutoGenerateSchema
                [obj.Schema, type] = obj.generateSchemaString;
            end
            
            [v,rows,fields] = obj.convertData(type,varargin{:});
            obj.setExtraMetaData
            obj.JavaHnd.writeData(fields,v,rows)
            
            % Delete any CRC files that may have been generated
            obj.deleteCRC
        end
        
        function finish(obj)
            % Finish appending data
            %
            % FINISH
            
            obj.JavaHnd.finish
            obj.AppendData = false;
            obj.deleteCRC
        end
        
        function delete(obj)
            % Release Java objects
            %
            % DELETE
            obj.JavaHnd.close();
            obj.JavaHnd = [];
        end
        
        function set.FileName(obj, file)
            % Set the FileName property and check for validity
            %
            % SET.FILE
            
            obj.FileName = obj.validateFile(file);
        end
        
        function append(obj,files,file)
            % APPEND Append to existing parquet file
            
            files = obj.validateFiles(files);
            file  = obj.validateFile(file);
            obj.JavaHnd.append(files,file)
        end
        
        function [schema, type] = generateSchemaString(obj)
            % Generate a Parquet schema string from underlying data
            %
            % GENERATESCHEMASTRING
            
            [type, fields] = obj.getColumnParquetType;
            clmn   = type.Count;
            schema = ['message MATLAB_Generated_Schema {', newline];
            
            for j = 1 : clmn
                f = fields{j};
                logical = type(f).Logical;
                if ~ isempty(logical)
                    logical = ['(',logical,')'];
                end
                schema = [schema, 'required ', type(f).Native,' ',f ,' ',...
                    logical,' ;', newline]; %#ok<*AGROW>
            end
            schema = [schema, '}'];
        end
        
        function [out, fields] = getColumnParquetType(obj)
            % Get the column type used for Parquet auto-generated schema
            %
            % Returns a containers.Map object K=COLUMN_NAME, V=TYPE
            % where TYPE is a struct with fields indicating 'Native' and
            % 'Logical' type values used in schema generation, as well as
            % the 'MATLAB' field for the underlying MATLAB type.
            %
            % NOTE: We return fields in there original order, if we
            % extract them from the Map using the keys value then the
            % fields will be alphabetically sorted which can mess up the
            % order in which fields are written.
            %
            % GETCOLUMNPARQUETTYPE
            
            import bigdata.parquet.enum.Types
            [~, clmn, fields] = obj.getSizeAndFields;
            
            out  = containers.Map;
            data = obj.Data;
            for j = 1 : clmn
                if isa(data,'table') || isa(data,'timetable')
                    if isa(data,'timetable') && j == 1
                        c = obj.getMatlabType(data.Properties.RowTimes);
                    elseif isa(data,'table') && j == 1 && ...
                            ~ isempty(data.Properties.RowNames)
                        c = obj.getMatlabType(data.Properties.RowNames);
                    else
                        c = obj.getMatlabType(data.(fields{j}));
                    end
                elseif (isnumeric(data) || islogical(data))
                    c = obj.getMatlabType(data(:,j));
                elseif isstruct(data)
                    c = obj.getMatlabType(data.(fields{j}));
                elseif iscell(data)
                    c = obj.getMatlabType(data{j});
                end
                out(fields{j}) = struct('Native',Types.(c).Native,...
                    'Logical',Types.(c).Logical,'MATLAB',c);
            end
        end
        
        function [rows,clmn,fields] = getSizeAndFields(obj)
            % Get the data size and fields
            %
            % Third output argument is fields for structs
            %
            % GETSIZEANDFIELDS
            
            fields = [];
            data   = obj.Data;
            if isa(data,'timetable')
                fields = [data.Properties.DimensionNames(1),...
                    data.Properties.VariableNames];
                clmn = length(fields);
                rows = height(data);
            elseif isa(data,'table')
                fields = data.Properties.VariableNames;
                if ~ isempty(data.Properties.RowNames)
                    fields = [data.Properties.DimensionNames(1), fields];
                end
                clmn = length(fields);
                rows = height(data);
            elseif (isnumeric(data) || islogical(data))
                [rows, clmn] = size(data);
                fields = "Field_" + (1 : clmn);
            elseif isstruct(data)
                fields = fieldnames(data);
                clmn   = length(fields);
                rows   = numel(data.(fields{1}));
            elseif iscell(data)
                rows = numel(data{1});
                clmn = length(data);
                fields = "Field_" + (1 : length(data));
            end
        end
        
        function [val, rows, fields] = convertData(obj,type,varargin)
            % Converts the data for the Parquet writer
            %
            % VAL    - Cell array, one per column of data
            % ROWS   - Number of rows in the data
            % FIELDS - The name of the fields as a cellstr
            %
            % CONVERTDATA
            
            data = obj.Data;
            [rows,clmn,fields] = obj.getSizeAndFields;
            if nargin == 3
                fields = varargin{1};
            end
            
            val = cell(1, clmn);
            
            for j = 1 : clmn
                f = fields{j};
                t = type(f);
                md = [];
                if isa(data,'table') || isa(data,'timetable')
                    if isa(data,'timetable') && j == 1
                        [val{j}, md] = obj.convertColumn(...
                            data.Properties.RowTimes,t,f);
                    elseif isa(data,'table') && j == 1 && ...
                            ~ isempty(data.Properties.RowNames)
                        [val{j}, md] = obj.convertColumn(...
                            string(data.Properties.RowNames),t,f);
                    else
                        [val{j}, md] = obj.convertColumn(data.(f),t,f);
                    end
                elseif (isa(data,'numeric') || isa(data, 'logical'))
                    [val{j}, md] = obj.convertColumn(data(:,j),t,f);
                elseif isa(data,'struct')
                    [val{j}, md] = obj.convertColumn(data.(f),t,f);
                elseif isa(data,'cell')
                    [val{j}, md] = obj.convertColumn(data{j},t,f);
                end
                obj.addMetaData(md)
            end
            
            % Finally add metadata about the class of data being written
            if istable(data) && ~ isempty(data.Properties.RowNames)
                obj.addMetaData({'matlab.datatype','table-rownames'})
            else
                obj.addMetaData({'matlab.datatype', class(data)})
            end
        end
    end
    
    methods(Access = private)
        function addMetaData(obj,md)
            % Add MATLAB specific metadata used for reading file
            %
            % MD - An M x 2 cell array of chars, {'key', 'value'} or string
            %      arrays ["key","value"]
            %
            % Example: addMetaData({'matlab.datatype','table'})
            %
            % ADDMETADATA
            
            if isempty(md)
                return
            end
            
            if (isa(md,'cell') || isa(md,'string')) && size(md,2) == 2
                obj.MetaData = [obj.MetaData; string(md)];
            end
        end
        
        function setExtraMetaData(obj)
            % Set the extra metadata for the Parquet file
            %
            % SETEXTRAMETADATA
            
            if ~ isempty(obj.MetaData)
                md = cellstr(obj.MetaData);
                obj.JavaHnd.setExtraMetaData(md(:,1), md(:,2));
            end
        end
        
        function deleteCRC(obj)
            % Delete CRC files
            if ispc && obj.DeleteCRC && ~ obj.AppendData
                [f, n, ext] = fileparts(obj.FileName);
                %  Dont use fullfile as it flips file:/// to file:\\\
                f = [f, filesep, '.', n, ext, '.crc'];
                delete(regexprep(f,'file:///',''))
            end
        end
    end
    
    methods(Static)
        function out = getMatlabType(data)
            % Get the MATLAB data type
            %
            % For most cases we will use what is returned by class(data)
            % whereas for other types such as datetime or duration we will
            % convert to one of the types as defined in
            % bigdata.parquet.enum.Types
            %
            % For instance if a datetime Format string has no time
            % component we will return this as of type DATE, which is
            % processed by Parquet as a INT32 rather than an INT64.
            %
            % See the bigdata.parquet.enum.Types for how values returned by
            % this method, GETMATLABTYPE, are written to Parquet.
            %
            % Only called by GETCOLUMNTYPE
            %
            % GETMATLABTYPE
            
            import bigdata.parquet.enum.Types
            
            % TODO warn if anything other than
            %
            % numerics,string,datetime,duration, and logical
            
            if isa(data,'datetime')
                if isempty(regexp(data.Format,'[hHmsS]','once'))
                    % We have no hours/minutes or seconds so can use int32
                    out = Types.DATE.char;
                elseif contains(data.Format,{'SSSSSS','SSSSS','SSSS'})
                    out = Types.DATETIME_MICROS.char;
                else
                    out = Types.DATETIME_MILLIS.char;
                end
            elseif isa(data,'duration')
                if contains(data.Format,{'SSSSSS','SSSSS','SSSS'})
                    out = Types.DURATION_MICROS.char;
                else
                    out = Types.DURATION_MILLIS.char;
                end
            elseif iscellstr(data) %#ok<ISCLSTR>
                out = Types.STRING.char;
            else
                out = upper(class(data));
            end
        end
        
        function [data, md] = convertColumn(data, type, field)
            % Convert this MATLAB column to correct type for Parquet Writer
            %
            % DATA - The converted data ready to be written to Parquet
            % MD   - Additional metadata key-value pair about the datatype
            %        as a cellarray {'key','value'}
            %
            % CONVERTCOLUMN
            
            md = [];
            switch type.MATLAB
                case 'CHAR'
                    
                case 'STRING'
                    % TODO revise this for 18a+
                    % Using a cellstr as it was better performant under 17b
                    % than a string
                    data = cellstr(data);
                case 'DATE'
                    md   = {[field,'.matlab.datetime.Format'],data.Format};
                    data = int32(posixtime(data) / 86400);
                case 'DURATION_MILLIS'
                    md   = {[field,'.matlab.duration.Format'],data.Format};
                    data = int32(milliseconds(data));
                case 'DURATION_MICROS'
                    md   = {[field,'.matlab.duration.Format'],data.Format};
                    data = int64(milliseconds(data) * 1e7);
                case {'DATETIME_MILLIS','DATETIME_MICROS'}
                    md   = {[field,'.matlab.datetime.Format'],data.Format};
                    data = int64(posixtime(data) * 1e7);
                case {'JSON','DURATION'}
                otherwise
                    % This should be all the logical, *int, single and
                    % double types.Thus a user could pass in double values
                    % which might all be integers, and if the user schema
                    % is set to one of the integer types, such as int32
                    % then this will get written as a correct integer type.
                    switch type.Native
                        case 'FLOAT'
                            data = single(data);
                        case 'BOOLEAN'
                            data = logical(data);
                        case 'INT64'
                            data = int64(data);
                        case 'INT32'
                            data = int32(data);
                    end
            end
        end
        
        function out = bytes(s)
            % Convert human readable size input to bytes
            %
            % Example: Specify 8 MB
            %
            % bytes('8M') % returns 8 * 1024^2 bytes
            %
            % BYTES
            
            % Can only use K(kilobytes), M(megabytes) or G(gigabytes)
            if isnumeric(s)
                out = s;
                return
            end
            
            F = ["k","m","g"];
            s = lower(s);
            if any(s(end) == F)
                n = str2double(s(1 : end - 1));
                out = 1024 ^ find(s(end) == F) * n;
            else
                out = str2double(s);
            end
        end
        
    end
    
    methods(Static, Access = private)
        function checkForHadoopHome
            % Check for HADOOP_HOME on Windows
            persistent needsCheck
            if isempty(needsCheck)
                needsCheck = true;
            end
            
            if needsCheck
                if ispc
                    msg = [];
                    if ~ parquetwin('isValidHadoopHome')
                        msg = parquetwin('msgSetupHadoopHome');
                    end
                    if ~ parquetwin('existWinutils')
                        msg = [msg, newline, newline, parquetwin('msgWinutils')];
                    end
                    if ~ isempty(msg)
                        error(msg)
                    else
                        needsCheck = false;
                    end
                end
            end
        end
        
        function mustBeStringOrMessageType(schema)
            % Property validation function for Schema
            %
            % MUSTBESTRINGORMESSAGETYPE
            
            if ~ (ischar(schema) || isstring(schema) || ...
                    isa(schema,'org.apache.parquet.schema.MessageType'))
                error('Needs to be a char, string or MessageType')
            end
        end
    end
end
