
#   parquetwin







Utility function for setting up winutils on Windows

VARARGOUT = parquetwin(OPT)

OPT can be one of the following

'hadoop_home', return the path needed for HADOOP_HOME

'existWinutils', return true if winutils.exe exists on path otherwise
false

'winutilsURL', retuns the winutils.exe URL

'testWinutils', test that winutils.exe is working correctly.
If you see a MSVCR100.dll is missing message popup then you will need
to install Microsoft Visual C++ 2010 SP1 Redistributable Package (x64)
https://www.microsoft.com/en-US/download/details.aspx?id=13523

'isValidHadoopHome', check that HADOOP_HOME is set to the correct path

'msgSetupHadoopHome', message for setting up HADOOP_HOME

'msgWinSetup', message for Windows users pointing to Getting Started

'msgWinutils', message for installing winutils.exe
