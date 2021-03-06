classdef ParPoolParquet < matlab.unittest.TestCase
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
        % delete(gcp('nocreate'))
    end

    methods(Test)

        function meanParallelTall(this)
            if ispc
                return
            end
            N = 50;
            parfor k=1:N
                fn = sprintf('tmp%02d.parquet', k);
                parquetwrite(fn, randn(1e6,2));
            end
            ds = parquetDatastore('*.parquet');
            ta = tall(ds);
            M = gather(mean(ta));
        end
    end
end
