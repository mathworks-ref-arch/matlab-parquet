classdef ParquetDatastore < matlab.io.Datastore & ...
        matlab.io.datastore.Partitionable & matlab.io.datastore.HadoopFileBased
    % Class for creating a Parquet datastore
    
    % Copyright (c) 2017, The MathWorks, Inc.

    properties(Access = private)
        % The current file index
        CurrentFileIndex double
        
        % The file set 
        FileSet matlab.io.datastore.DsFileSet
        
        % Parquet Reader properties
        ParquetReaderProps cell
    end
    
    % Property to support saving, loading, and processing of
    % datastore on different file system machines or clusters.
    % In addition, define the methods get.AlternateFileSystemRoots()
    % and set.AlternateFileSystemRoots() in the methods section.
    properties(Dependent)
        AlternateFileSystemRoots
    end
    
    methods
        function obj = ParquetDatastore(location,varargin)
            % Constructor for ParquetDatastore
                        
            dsFileSetProps = {'FileSplitSize','IncludeSubfolders',...
                'FileExtensions','AlternateFileSystemRoots'};            
            [~ , b1] = intersect(varargin(1 : 2 : end), dsFileSetProps);
            ind = (b1 - 1) * 2 + 1;
            ind = sort([ind; ind + 1]);
            dsProps = varargin(ind);
            
            % The other varargins to be used for ParquetFileReader
            obj.ParquetReaderProps = varargin(setdiff(1 : length(varargin), ind));
            
            obj.FileSet = matlab.io.datastore.DsFileSet(location, dsProps{:});
            obj.CurrentFileIndex = 1;
            
            obj.AlternateFileSystemRoots = obj.FileSet.AlternateFileSystemRoots;
            reset(obj);
        end
        
        function out = getFiles(obj)
            % Get the list of files in the datastore
            out = obj.FileSet;
        end
        
        % Define the hasdata method
        function tf = hasdata(obj)
            % Return true if more data is available
            tf = hasfile(obj.FileSet);
        end
        
        % Define the read method
        function [data,info] = read(obj)
            % Read data and information about the extracted data
            % See also: ParquetFileReader()
            if ~ hasdata(obj)
                error(['No more data to read.\nUse the reset ',...
                    'method to reset the datastore to the start of ' ,...
                    'the data. \nBefore calling the read method, ',...
                    'check if data is available to read ',...
                    'by using the hasdata method.']);
            end
            
            fileInfoTbl = nextfile(obj.FileSet);
            data = obj.ParquetFileReader(fileInfoTbl, obj.ParquetReaderProps);
            info.Size = size(data);
            info.FileName = fileInfoTbl.FileName;
            info.Offset = fileInfoTbl.Offset;
            
            % Update CurrentFileIndex for tracking progress
            if fileInfoTbl.Offset + fileInfoTbl.SplitSize >= ...
                    fileInfoTbl.FileSize
                obj.CurrentFileIndex = obj.CurrentFileIndex + 1 ;
            end
        end
        
        % Define the reset method
        function reset(obj)
            % Reset to the start of the data
            reset(obj.FileSet);
            obj.CurrentFileIndex = 1;
        end
        
        % Define the progress method
        function frac = progress(obj)
            % Determine percentage of data read from datastore
            if hasdata(obj)
                frac = (obj.CurrentFileIndex-1)/...
                    obj.FileSet.NumFiles;
            else
                frac = 1;
            end
            fprintf(1,'%.1f%% Completed\n',frac * 100);
        end
        
        % Define the partition method
        function subds = partition(obj,n,ii)
            subds = copy(obj);
            subds.FileSet = partition(obj.FileSet,n,ii);
            reset(subds);
        end
        
        % Getter for AlternateFileSystemRoots property
        function altRoots = get.AlternateFileSystemRoots(obj)
            altRoots = obj.FileSet.AlternateFileSystemRoots;
        end
        
        % Setter for AlternateFileSystemRoots property
        function set.AlternateFileSystemRoots(obj,altRoots)
            try
                % The DsFileSet object manages AlternateFileSystemRoots
                % for your datastore
                obj.FileSet.AlternateFileSystemRoots = altRoots;
                
                % Reset the datastore
                reset(obj);
            catch ME
                throw(ME);
            end
        end
        
        function initializeDatastore(obj,hadoopInfo)
            import matlab.io.datastore.DsFileSet;
            obj.FileSet = DsFileSet(hadoopInfo,...
                'FileSplitSize',obj.FileSet.FileSplitSize);
            reset(obj);
        end
        
        function loc = getLocation(obj)
            loc = obj.FileSet;
        end
        
        function tf = isfullfile(obj)
            tf = isequal(obj.FileSet.FileSplitSize,'file');
        end
        
    end
    
    methods(Access = protected)
        % If you use the  FileSet property in the datastore,
        % then you must define the copyElement method. The
        % copyElement method allows methods such as readall
        % and preview to remain stateless
        function dscopy = copyElement(ds)
            dscopy = copyElement@matlab.mixin.Copyable(ds);
            dscopy.FileSet = copy(ds.FileSet);
        end
        
        % Define the maxpartitions method
        function n = maxpartitions(myds)
            n = maxpartitions(myds.FileSet);
        end
    end
    
    methods(Static, Access = private)
        function data = ParquetFileReader(fileInfoTbl, prProps)
            % Custom file reader to read Parquet files
            %
            % MYFILEREADER
            
            % Create a reader object using FileName
            reader = matlab.io.datastore.DsFileReader(fileInfoTbl.FileName);
            
            % Seek to the offset
            seek(reader,fileInfoTbl.Offset,'Origin','start-of-file');
            
            % Read fileInfoTbl.SplitSize amount of data
            data = parquetread(fileInfoTbl.FileName, prProps{:});         
        end
    end
end
