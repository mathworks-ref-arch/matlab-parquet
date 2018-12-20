classdef DataStoreParquet < matlab.unittest.TestCase
%
% Copyright (c) 2017, The MathWorks, Inc.
    
    methods(TestMethodSetup)
        function addHelpers(testCase)
            import matlab.unittest.fixtures.TemporaryFolderFixture;
            import matlab.unittest.fixtures.CurrentFolderFixture;

            % Create a temporary folder and make it the current working
            % folder.
            tempFolder = testCase.applyFixture(TemporaryFolderFixture);
            testCase.applyFixture(CurrentFolderFixture(tempFolder.Folder));
        end
    end
    methods(TestMethodTeardown)
    end

    methods(Test)
        function readDataStoreSimple(this)
            if ispc
                return
            end
            try
                N = 20;
                parfor k=1:N
                    fn = sprintf('tmp%d.parquet', k);
                    parquetwrite(fn, randn(1e6,2));
                end
                ds = parquetDatastore('*.parquet');
                mean(ds.readall);
            catch ME
                this.assertEqual(1,0, sprintf('parquetDataStore Error: "%s"', ME.message));
            end
        end
    end
end
