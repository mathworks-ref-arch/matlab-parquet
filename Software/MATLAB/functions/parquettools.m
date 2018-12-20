function parquettools(varargin)
% Run parquet-tools on given file
%
% PARQUETTOOLS(ARG, FILE, ... ) Run parquet-tools ARG on
% FILE using optional properties for ARG.
%
% Example: Get help on all commands available
%
%   parquettools
%
% Example: Get help on meta
%
%   parquettools('meta')
%
% Example: Get meta of tmp.parquet
%
%   parquettools('meta','tmp.parquet')
%
% See also bigdata.parquet.Tools

% Copyright (c) 2017, The MathWorks, Inc.

try
    if ~ nargin
        tools = bigdata.parquet.Tools;
        tools.help
        return
    end
    
    tools = bigdata.parquet.Tools;
    tools.(varargin{1})(varargin{2 : end});
catch ME
    bigdata.checkStaticClasspath(ME)
end
