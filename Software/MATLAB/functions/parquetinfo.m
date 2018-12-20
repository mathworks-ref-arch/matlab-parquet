function out = parquetinfo(file)
% Get meta information about a Parquet file
%
% PARQUETINFO(FILE)
%
% Example: Get info about tmp.parquet
%
%   info = parquetinfo('tmp.parquet')
%
% See also bigdata.parquet.Tools

% Copyright (c) 2017, The MathWorks, Inc.

try
    bigdata.parquet.checkRelease();
    
    reader = bigdata.parquet.Reader('FileName', file);
    out = reader.getMetadata;
catch ME
    bigdata.checkStaticClasspath(ME)
end