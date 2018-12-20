function ME = checkStaticClasspath(ME)
% Check if jar on static classpath
% Copyright (c) 2017, The MathWorks, Inc.

if isa(ME,'matlab.exception.JavaException') && ...
        any(strfind(ME.message,'com.mathworks.bigdata.parquet'))
    root = fileparts(fileparts(which('parquetread')));
    file = dir(fullfile(root,'lib','jar','*.jar'));

    if ~ any(strcmp(fullfile(file.folder,file.name), javaclasspath('-static')))
        [~, tbx] = fileparts(root);
        error(['Please restart MATLAB to correctly set the classpath for ', ...
            tbx])
    end
else
    throwAsCaller(ME)
end
