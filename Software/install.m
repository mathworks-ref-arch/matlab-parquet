function install(doSavePath)
    % Install script
    %
    % User should restart MATLAB after install.
    %
    % Copyright (c) 2017, The MathWorks, Inc.
    
    if nargin < 1
        doSavePath = true;
    end

    tbx = dir('*.mltbx');

    if ~ isempty(tbx)
        installToolbox
    else
        installFiles
        if doSavePath
            savepath
        end
    end

end


function accept = optionDialog(msg, dlgTitle)
    % Options yes/no dialog
    answer = questdlg(msg, dlgTitle, 'Yes', 'No', 'Yes');
    accept = strcmp('Yes', answer);
end



function msg = additionalDownloads
    % Any additional downloads go here

    msg = '';

    % For Windows we need winutils.exe
    if ispc
        winutilsInstalled = false;
        file = parquetwin('winutilsURL');

        if ~parquetwin('existWinutils')
            error(['You will not be able to write Parquet files on Windows ',...
                'until you save ',newline, file, ' into, ', newline, ...
                fullfile(parquetwin('hadoop_home'),'bin'), newline])
        end

        % Windows user HADOOP_HOME message
        if ~ parquetwin('isValidHadoopHome')
            % Copy the HADOOP_HOME path to the clipboard
            if winutilsInstalled
                disp(parquetwin('msgSetupHadoopHome'))
            else
                disp(parquetwin('msgWinSetup'))
            end
        else
            msg = '';
        end
    end
end

function installToolbox
    % Install the toolbox

    tbname = dir(fullfile('*.mltbx'));
    [~, tbname] = fileparts(tbname.name);

    % Check for previously installed toolbox
    toolboxes = matlab.addons.toolbox.installedToolboxes;
    if ~ isempty(toolboxes)
        ind = strcmp(tbname,{toolboxes.Name});
        if any(ind)
            ind  = find(ind);
            % Ask to uninstall
            for j = ind
                if optionDialog(['Do you wish to uninstall existing ',...
                        tbname, ' ', toolboxes(j).Version], ...
                        'Uninstall Toolbox')
                    matlab.addons.toolbox.uninstallToolbox(toolboxes(j))
                end
            end
        end
    end

    % Briefly turn off warning about jars on static classpath
    warning('off','MATLAB:javaclasspath:jarAlreadySpecified')
    matlab.addons.toolbox.installToolbox([tbname,'.mltbx'], true);
    warning('on','MATLAB:javaclasspath:jarAlreadySpecified')

    % Download any additional resources
    msg = additionalDownloads;

    disp(['Installed ',tbname,' Toolbox'])

    % Ask to restart MATLAB
    if isempty(msg)
        disp('Please restart MATLAB')
        msgbox([msg, tbname, ' successfully installed.', newline, ...
            'Please restart MATLAB'], 'Restart MATLAB')
    else
        disp(msg)
        msgbox([tbname, ' successfully installed.', newline, newline, ...
            msg], 'Restart MATLAB')
    end
end

function installFiles
    % Install the files needed to run the interface

    % Add the paths and save

    here = fileparts(mfilename('fullpath'));
    root = fullfile(here, 'MATLAB');

    addpath(root, '-end')
    try
        bigdata.parquet.checkRelease
    catch ME
        rmpath(root);
        throw(ME);
    end
    addpath(fullfile(root,'functions'), '-end')
    addpath(fullfile(root,'test'), '-end')
    addpath(fullfile(root,'doc'), '-end')
    addpath(fullfile(root,'doc','examples'), '-end')

    % Add any jars to the static javaclasspath
    addStaticClassPath;

end

function addStaticClassPath
    % Add the jar to the users javaclasspath.txt in prefdir

    % Add jar to users static javaclasspath in prefdir
    here = fileparts(mfilename('fullpath'));

    % Add the paths and save
    % root = 'MATLAB';
    root = fullfile(here, 'MATLAB');
    jarfile = dir(fullfile(root,'lib','jar','*.jar'));
    if isempty(jarfile)
        error('No JAR-file was found in "%s".\nYou may need to run "mvn clean package" in the folder "%s".\n', ...
            fullfile(root,'lib','jar'), ...
            fullfile(here, 'Java'));
    end

    % Use the prefdir folder to write our javaclasspath
    file = fullfile(prefdir, 'javaclasspath.txt');

    % Read javaclasspath.txt
    if ~ isempty(dir(file))
        fid = fopen(file);
        jarpath = textscan(fid, '%s\n');
        fclose(fid);
        jarpath = jarpath{:};
    else
        jarpath = [];
    end
    writeToFile = false;

    % Add jars to javaclasspath
    arrayfun(@(x) addJarEntry(x), jarfile);

    % Write javaclasspath to file
    writeJavaclasspath

    % Ask to restart MATLAB
    if writeToFile
        msgbox('MATLAB needs to be restarted','Restart MATLAB')
    end

    function addJarEntry(x)
        % Add new JAR to javaclasspath list

        if ~ any(strcmp(fullfile(x.folder,x.name), jarpath))
            % Add our entry to the top of the list
            jarpath = [{fullfile(x.folder,x.name)}; jarpath];
            disp([fullfile(x.folder,x.name), ' has been added to ', ...
                'javaclasspath.txt'])
            writeToFile = true; % we will need to write to file
        end
    end

    function writeJavaclasspath
        % This function writes to prefidr/javaclasspath.txt

        if ~ writeToFile
            % javaclasspath.txt was not modified
            return
        end

        try
            % Write to javaclasspath.txt
            fid = fopen(file,'w');
            fprintf(fid,'%s\n', jarpath{:});
            fclose(fid);
        catch ME
            throw(ME)
        end
        disp(['See https://www.mathworks.com/help/matlab/matlab_external/', ...
            'static-path.html for more info on setting static classpaths'])
    end

end
