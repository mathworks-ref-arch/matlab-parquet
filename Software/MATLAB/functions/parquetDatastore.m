function varargout = parquetDatastore(file, varargin)
% Create a datastore for Parquet files
%
% DS = PARQUETDATASTORE(FILE, Property, Value,...) Create a Parquet
% datastore using FILE with optional Property, Value pairs defined by the
% ParquetDatastore class and return the datastore DS.
%
% Theres a special case for FILE, '-getHDFSHome' that returns the HDFS home
% URI.
%
% Example: Create a Parquet datastore
%
%   ds = parquetDatastore('hdfs:///user/ubuntu/data/*.parquet');
%
% Example: Return the HDFS home URI
%
%   uri = parquetDatastore('-getHDFSHome');
%
% See also bigdata.parquet.ParquetDatastore, parquetread

% Copyright (c) 2017 MathWorks, Inc.

try
    bigdata.parquet.checkRelease();

    if ispc
        error('parquetDatastore is not currently supported on Windows');
    else
        % TODO test if macOS Bash supports command -v
        % note this will not source a .bashrc file and so may not find it
        % if defined in that way
        status = system('command -v hdfs >/dev/null 2>&1');
        if status ~= 0
            error('Required hdfs command not found');
        end
    end



    if ~ nargin || isempty(file)
        return
    end

    if strcmp(file,'-getHDFSHome')
        [~ , ds] = system('hdfs -getconf confKey fs.defaulFS');
        ds = strip(ds);
    else
        ds = bigdata.parquet.ParquetDatastore(file, varargin{:});
    end

    if nargout
        varargout{1} = ds;
    end
catch ME
    bigdata.checkStaticClasspath(ME)
end
