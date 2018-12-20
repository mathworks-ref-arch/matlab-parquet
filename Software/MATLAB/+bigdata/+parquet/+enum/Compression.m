classdef Compression
    % List of enumeration properties for Parquet Compression
    
    % Copyright (c) 2017, The MathWorks, Inc.
    
    enumeration
        % Enumeration for Gzip compression
        GZIP
        
        % Enumeration for LZO compression
        LZO
        
        % Enumeration for Snappy compression
        SNAPPY
        
        % Enumeration for no compression
        UNCOMPRESSED
    end
    
end