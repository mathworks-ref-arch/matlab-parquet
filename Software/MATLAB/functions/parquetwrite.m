function varargout = parquetwrite(file, data, varargin)
% Write data to a Parquet file
%
% PARQUETWRITE(FILE, DATA, Property, Value,...) Writes DATA to a Parquet
% FILE using optional Property, Value pairs defined by the Writer class.
%
% WRITER = PARQUETWRITE(...) optionally return the Writer object.
%
% Example: Create an array and write to tmp.parquet
%
%   parquetwrite('tmp.parquet', randn(10))
%
% See also bigdata.parquet.Writer, parquetread

% Copyright (c) 2017, The MathWorks, Inc.

try
    bigdata.parquet.checkRelease();
    
    if ~ nargin || isempty(data) || isempty(file)
        if nargout
            varargout{1} = bigdata.parquet.Writer;
        end
        return
    end
    
    writer = bigdata.parquet.Writer(varargin{:});
    writer.FileName = file;
    writer.write(data);
    if nargout == 1
        varargout{1} = writer;
    end
catch ME
    bigdata.checkStaticClasspath(ME)
end
