classdef Types
    % Enumeration between MATLAB and Parquet native and logical types
    
    % Copyright (c) 2017, The MathWorks, Inc.
    
    properties
        % Parquet native type
        Native
        
        % Parquet logical type
        Logical
    end
    
    methods
        function obj = Types(a,b)
            obj.Native  = lower(a);
            obj.Logical = b;
        end
    end
    
    enumeration
        % -----------------------------------------------------
        %       These are fundamental MATLAB types
        % -----------------------------------------------------
        %
        % web(fullfile(docroot,
        % 'matlab/matlab_prog/fundamental-matlab-classes.html'))
        %
        % MATLABTYPE (PARQUET-NATIVE, PARQUET-LOGICAL)
        
        % logical to Parquet native and logical type
        LOGICAL ('BOOLEAN','')
        
        % double to Parquet native and logical type
        DOUBLE  ('DOUBLE','')
        
        % single to Parquet native and logical type
        SINGLE  ('FLOAT','')
        
        % int64 to Parquet native and logical type
        INT64   ('INT64','INT_64')
        
        % int32 to Parquet native and logical type
        INT32   ('INT32','INT_32')
        
        % int16 to Parquet native and logical type
        INT16   ('INT32','INT_16')
        
        % int8 to Parquet native and logical type
        INT8    ('INT32','INT_8')
        
        % uint64 to Parquet native and logical type
        UINT64  ('INT64','UINT_64')
        
        % uint32 to Parquet native and logical type
        UINT32  ('INT32','UINT_32')
        
        % uint16 to Parquet native and logical type
        UINT16  ('INT32','UINT_16')
        
        % uint8 to Parquet native and logical type
        UINT8   ('INT32','UINT_8')
        
        % string to Parquet native and logical type
        STRING  ('BINARY','UTF8')
        
        % char to Parquet native and logical type
        CHAR    ('BINARY','UTF8')              
        
        % -----------------------------------------------------
        %       What follows are other derived classes
        % -----------------------------------------------------
        
        % date with yyyy-mm-dd format to Parquet native and logical type
        DATE ('INT32','DATE')
        
        % duration unlimited precision to Parquet native and logical type
        DURATION ('FIXED_LEN_BYTE_ARRAY','INTERVAL')
        
        % duration with millisecond precision to Parquet native and logical type
        DURATION_MILLIS ('INT32','TIME_MILLIS')
        
        % duration with microsecond precision to Parquet native and logical type
        DURATION_MICROS ('INT64','TIME_MICROS')
        
        % datetime with millisecond precision to Parquet native and logical type
        DATETIME_MILLIS ('INT64','TIMESTAMP_MILLIS')
        
        % same as datetime_millis but derived from INT96 
        DATETIME_MILLIS_INT96 ('INT96','INT96')
        
        % datetime with microsecond precision to Parquet native and logical type
        DATETIME_MICROS ('INT64','TIMESTAMP_MICROS')
        
        % JSON to Parquet native and logical type
        JSON ('BINARY','JSON')
    end
    
end