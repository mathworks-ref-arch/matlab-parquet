classdef MetaDataParquet < matlab.unittest.TestCase
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

        function testReadInfo(this)
            D1 = struct2table(getStruct(6e3));
            fn = 'tmpTable.parquet';
            parquetwrite(fn, D1);
            D2 = parquetinfo(fn);
            assertClass(this, D2, 'struct', 'The fileinfo should be a struct');
            fn = fieldnames(D2);
            fnT = {'fileMetaData', 'blocks'};
            assertLength(this, union(fn, fnT), 2, 'There should be two elements');
            assertLength(this, intersect(fn, fnT), 2, 'There should be two elements');
        end

        function testParquetToolsMeta(this)
            D1 = struct2table(getStruct(50));
            fn = 'tmp.parquet';
            parquetwrite(fn, D1);
            try
                parquettools('meta', fn);
            catch ME
                assertEqual(this, 1, 2, ...
                    sprintf('The parquettools should be able to read meta information.\n\t%s\n', ME.message));
            end
        end

        function testParquetToolsHead(this)
            D1 = struct2table(getStruct(50));
            fn = 'tmp.parquet';
            parquetwrite(fn, D1);
            try
                parquettools('head', '-n 20', fn);
            catch ME
                assertEqual(this, 1, 2, ...
                    sprintf('The parquettools should be able to read head information.\n\t%s\n', ME.message));
            end
        end

        function testParquetToolsSchema(this)
            D1 = struct2table(getStruct(50));
            fn = 'tmp.parquet';
            parquetwrite(fn, D1);
            try
                parquettools('schema', fn);
            catch ME
                assertEqual(this, 1, 2, ...
                    sprintf('The parquettools should be able to read schema information.\n\t%s\n', ME.message));
            end
        end

        function testParquetToolsDump(this)
            D1 = struct2table(getStruct(50));
            fn = 'tmp.parquet';
            parquetwrite(fn, D1);
            try
                parquettools('dump', fn);
            catch ME
                assertEqual(this, 1, 2, ...
                    sprintf('The parquettools should be able to dump information.\n\t%s\n', ME.message));
            end
        end

        function testParquetToolsCat(this)
            D1 = struct2table(getStruct(50));
            fn = 'tmp.parquet';
            parquetwrite(fn, D1);
            try
                parquettools('cat', fn);
            catch ME
                assertEqual(this, 1, 2, ...
                    sprintf('The parquettools should be able to cat information.\n\t%s\n', ME.message));
            end
        end
    end
end

function S = getStruct(N)
    x = linspace(0,10,N+1)';
    x(end) = [];
    S = struct('Time', x, ...
        'Sin', sin(x), ...
        'Cos', cos(x));
end
