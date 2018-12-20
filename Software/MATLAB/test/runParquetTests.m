function results = runParquetTests()
  % runParquetTests 
  %
  % Copyright (c) 2017, The MathWorks, Inc.

    here = fileparts(mfilename('fullpath'));
    TS = matlab.unittest.TestSuite.fromFolder(here, ...
        'IncludingSubfolders', true);

    results = TS.run();

end
