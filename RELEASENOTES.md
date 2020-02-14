#  MATLAB Interface *for Apache Parquet* - Release Notes

## Release 0.25.1 February 14th 2020
* Update to license

## Release 0.25.0 December 20th 2018
* parquetreader file handle fix
* Add unit tests

## 0.24
- Documentation improvements

## 0.23
- Improved GettingStarted guide for windows users and include non-toolbox install option

## 0.21
- Better error handling and documentation updates

## 0.20
- This re-introduces parquet-tools and other changes related to folder structure, more auto-completion for functions and updated help.

## 0.19
 - Maintenance release - adding latest GettingStarted.html from mlx

## 0.16
- Cleanup paths after Build.run and remove prj.bak from toolbox packaging
- All issues from bash fixed except for better message for when writing over existing files
- This is the first release that does not ship 3p libraries

## 0.15   
- Latest release supports int96 timestamps and  missing values

## 0.13
- Updated toolbox prj file � 6 months ago

## 0.12
- Fixed bug when writing table's with empty RowName property

## 0.11
- Improved toolbox documentation and layout

## 0.10
- Initial version of datastore support, added parquettools and parquetinfo.

## 0.9
This fixes a small bug for Windows installs and improves setup instructions
for Windows users

## 0.8.1
- This is the same as 0.8 release in terms of functionality except support for
distribution by Add-on manager as a Toolbox added.

## 0.8
- ContextClassLoaderGuard moved to util package
- Core.m/addJars recursively adds JAR's in the resources/jar folder now
- Core.m added ShowJarLoadedMsg property to manage whether JAR already loaded message appears, false by default
- Core.m fix to conversion type, fat fingered 'v' instead of 'b', but thankfully the condition was never possible due to there so far being no numeric Enums
- Reader.m addJars now called in constructor again
- Reader.m/read method now deals with tables with RowNames property
- Writer.m addJars now called in constructor again
- Writer.m/write method examples tidied up
- Writer.m/convertData add extra metadata table-rownames for tables with RowNames
- parquetReadScript.m removed merge conflict message
- testingWriter.m tidied up with better comments
- Removed Example method from Writer which was for internal testing, not needed
- Removed startup/shutdown files and updated pom to 0.8

## 0.7
- Removed printFooter from Reader so getMetaData now works on Windows, and moved
 script files to test

## 0.6
- Reader.java now returns nested data such as LIST and MAP as a List
- Reader.m if file not written by MATLAB return as a cell array for now, table
does not like Java objects. Nested data is for the moment stored in an
ArrayList which we would need to iterate through
- Removed DefaultFS property no longer used
- getMetaData method returns a structure array of all metadata
- Writer.m change some method names to be more reflective of what they are
- Adding writeScript.m to profile various write options
- Updated pom to 0.6

## 0.5
- This fixes the memory leakage problem when writing, passing a string array
has a memory leak issue. Once we changed to a cellstr the write behave nicely.
- Refactored into bigdata.parquet, thus the classes are now:
    bigdata.parquet.Writer
    bigdata.parquet.Reader
    bigdata.parquet.Tools
- datetime/duration and data class types are now captured as extra metadata
within the Parquet file and not embedded into the fieldname.
Thus fieldnames are not modified as in the temporary solution in 0.4 release
write should not leak memory now, we cast string arrays to cellstr to
prevent this until there is a fix in core MATLAB

## 0.4
- timetable preserved when writing and reading back from Parquet file,
including fieldname for the time column
- improved precision of datetimes being written and read from Parquet file
- first version of append data to current open Parquet file writer

## 0.3
- Fixes the order in which columns are written
- Adds option to delete CRC files which are generated
- MaxRows can be 'file'
- Fixed small bug reading Parquet from HDFS
- Faster write performance
- Code refactor

## 0.2  
- Support for writing to HDFS, and most of MATLAB core data types, numeric,
logical, datetime, duration, string,..., and more.
- parquet-tools  This is the parquet-tools.jar which can be added to the
*resources/jar* folder

## 0.1
- First release of ParquetReader, writer being worked on
