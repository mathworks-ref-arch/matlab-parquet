function out = parquetwin(opt)
% Utility function for setting up winutils on Windows
%
% VARARGOUT = PARQUETWIN(OPT)
%
% OPT can be one of the following
%
%   'hadoop_home', return the path needed for HADOOP_HOME
%
%   'existWinutils', return true if winutils.exe exists on path otherwise
%   false
%
%   'winutilsURL', retuns the winutils.exe URL
%
%   'testWinutils', test that winutils.exe is working correctly.
%   If you see a MSVCR100.dll is missing message popup then you will need
%   to install Microsoft Visual C++ 2010 SP1 Redistributable Package (x64)
%   https://www.microsoft.com/en-US/download/details.aspx?id=13523
%
%   'isValidHadoopHome', check that HADOOP_HOME is set to the correct path
%
%   'msgSetupHadoopHome', message for setting up HADOOP_HOME
%
%   'msgWinSetup', message for Windows users pointing to Getting Started
%
%   'msgWinutils', message for installing winutils.exe

% Copyright (c) 2017, The MathWorks, Inc.

% Path to the hadoop root folder
hadoop =  fullfile(fileparts(fileparts(which('parquetread'))),'lib', ...
    'hadoop');

% winutils.exe that needs to be downloaded
winutils = ['https://github.com/steveloughran/winutils/raw/master/', ...
    'hadoop-2.8.3/bin/winutils.exe'];

switch opt
    case 'hadoop_home'
        % Return hadoop folder for HADOOP_HOME
        out = hadoop;

    case 'winutilsURL'
        % Return winutils.exe URL
        out = winutils;
    case 'existWinutils'
        % Is winutils.exe installed
        out = ~ isempty(dir(fullfile(hadoop, 'bin', 'winutils.exe')));
    case 'testWinutils'
        % Test that winutils.exe runs correctly
        [out, ~] = system(fullfile(hadoop,'bin','winutils.exe systeminfo'));
    case 'isValidHadoopHome'
        % Check that HADOOP_HOME is set to the correct path
        out = strcmp(getenv('HADOOP_HOME'), parquetwin('hadoop_home'));
    case 'msgSetupHadoopHome'
        % Message for setting up HADOOP_HOME
        out = ['There is a problem with the System environment variable ', ...
            'HADOOP_HOME, this value needs to be set to the following:', ...
            newline,parquetwin('hadoop_home'), ...
            newline, ...
            'Please ensure you paste this value into System environment variable ',...
            'HADOOP_HOME, and then restart MATLAB.', newline, ...
            'See Help > Supplemental Software > ', ...
            'MATLAB Interface for Parquet Toolbox > Getting Started for more information.', newline];
    case 'msgWinSetup'
        % Message for Windows users pointing to Getting Started
        out = [parquetwin('winutilsURL'), ' was not installed. ', newline, ...
            'Please see Help > Supplemental Software > ', ...
            'MATLAB Interface for Parquet Toolbox > Getting Started ', ...
            'on manually setting up winutils and HADOOP_HOME'];
    case 'msgWinutils'
        % Message for installing winutils.exe
        out = ['To write Parquet files on Windows save:',...
            newline, winutils, newline , ...
            'To the folder:', newline, ...
            fullfile(parquetwin('hadoop_home'),'bin'),...
            ... newline, newline, ...
            ...'otherwise see Help > Supplemental Software > ', ...
            ...'MATLAB Interface for Parquet Toolbox > Getting Started for more information.', newline, ...
            ];
    case 'msgWinutilsRun'
        out = ['If you see a MSVCR100.dll is missing message popup then you will need to install:',...
            newline, ...
            'Microsoft Visual C++ 2010 SP1 Redistributable Package (x64)',...
            newline, ...
            ' https://www.microsoft.com/en-US/download/details.aspx?id=13523'];
    case 'verify'
        yes = char(10004);
        fprintf('1. Checking HADOOP_HOME ')
        if ~ parquetwin('isValidHadoopHome')
            fprintf(2,'\n%s\n',parquetwin('msgSetupHadoopHome'))
        else
            fprintf('%s\n', yes);
        end
        
        fprintf('2. Checking winutils install ')
        if ~parquetwin('existWinutils')
            fprintf(2,'\n%s\n',parquetwin('msgWinutils'))
        else
            fprintf('%s\n', yes)
            fprintf('3. Testing winutils ')
            if parquetwin('testWinutils')
                fprintf(2,'\n%s\n',parquetwin('msgWinutilsRun'));
            else
                fprintf('%s\n', yes)
            end
        end
    case 'additionalDownloads'
        out = '';
        
        % For Windows we need winutils.exe
        if ispc
            winutilsInstalled = false;
            file = parquetwin('winutilsURL');
            
            disp(['You will not be able to write Parquet files on Windows ',...
                'until you save ',newline, file, ' into, ', newline, ...
                fullfile(parquetwin('hadoop_home'),'bin'), newline])
            
            % Windows user HADOOP_HOME message
            if ~ parquetwin('isValidHadoopHome')
                % Copy the HADOOP_HOME path to the clipboard
                if winutilsInstalled
                    disp(parquetwin('msgSetupHadoopHome'))
                else
                    disp(parquetwin('msgWinSetup'))
                end
            else
                out = '';
            end
        end
end

end

function accept = optionDialog(msg, dlgTitle)
% Options yes/no dialog

frame = javaObjectEDT('javax.swing.JFrame');
img = fullfile(fileparts(fileparts(which('parquetwin'))), 'doc', ...
    'images','mwlogo.png');
icon = javaObjectEDT('javax.swing.ImageIcon', img);
frame.setIconImage(icon.getImage);
optionType = 0;
messageType = 3;
accept = ~ javaMethodEDT('showOptionDialog','javax.swing.JOptionPane', ...
    frame, msg, dlgTitle, optionType, messageType, [], {'Yes','No'},'Yes');

end
