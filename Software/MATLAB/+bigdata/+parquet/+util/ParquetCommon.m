classdef (Abstract) ParquetCommon < handle
    % Class for common tasks specifically related to Parquet files
    
    % Copyright (c) 2017, The MathWorks, Inc.
    
    methods(Static)
        function file = validateFile(file)
            % Validate the File property
            %
            % Checks for presence of 'file:' or 'hdfs' at beginning of file
            % string. If not there will create a fullfile name at the
            % current path.
            %
            % VALIDATEFILE
            
            file = string(file);
            if ~ (startsWith(file, "file:") || startsWith(file, "hdfs://"))
                pre    = "file:///";
                if isunix || ismac
                    pre = "file://";
                end
                if ispc && ~ isempty(regexp(file, '.:', 'once'))
                    % We are going to guess that file starts with a drive
                    % letter and so we have a fullfile name, something like
                    % C:\folder\myfile.parquet
                    file = pre + file;
                elseif ispc
                    % Drive letter is missing so lets add pwd
                    file = pre + fullfile(pwd, char(file));
                elseif (isunix || ismac) && startsWith(file,'/')
                    % We are on *ux/mac so if we start with / good bet its
                    % the fullfile
                    file = pre + file;
                else
                    % otherwise *ux/mac and create fullpath using pwd
                    file = pre + fullfile(pwd, char(file));
                end
            end
            file = char(file);
        end
        
        function files = validateFiles(files)
            % Validate an array of files
            %
            % VALIDATEFILES
            
            files = string(files);
            for j = 1 : length(files)
                files(j) = bigdata.parquet.util.ParquetCommon.validateFile(files(j));
            end
        end                
    end
    
end