function checkRelease
    % bigdata.parquet.checkRelease - Checks what release is used
    %
    % This function will throw an error if Release R2019a or later is being
    %   used, since this release provides a native Parquet implementation.
    
    persistent releaseTooNew releaseTooOld
    if isempty(releaseTooNew)
        releaseTooNew = ~verLessThan('matlab', '9.6');
        releaseTooOld = verLessThan('matlab','9.3'); % R2017b
    end
    
    if releaseTooOld
        error('MATLAB Release between R2017b and R2018b is required');
    end
    
    if releaseTooNew
        error(['This support package should not be used in release R2019a or later.', ...
            newline, ...
            'Please use the native Parquet support instead.']);
    end
    
    
end