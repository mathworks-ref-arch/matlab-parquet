
#   bigdata.parquet.Tools 







Get information on a Parquet file

CAT    Prints the content of a Parquet file. The output contains only
the data, no metadata is displayed.
WARNING: This can dump a lot of data to the command window and take a
long to display, you generally dont want to use this for large files.

HEAD   Prints the first n record of the Parquet file

SCHEMA Prints the schema of Parquet file(s)

META   Prints the metadata of Parquet file(s)

DUMP   Prints the content and metadata of a Parquet file

MERGE  Merges multiple Parquet files into one. The command doesn't
merge row groups, just places one after the other. When used to merge
many small files, the resulting file will still contain small row
groups, which usually leads to bad query performance.

#### Example: Get detailed meta information

import bigdata.parquet.Tools;

Tools.meta('tmp.parquet')



See also



[parquettools](parquettools.md)



## Class Details 

Attributes | Class
:------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------
Superclasses      | [bigdata.parquet.util.Core](bigdata.parquet.util.Core.md), [bigdata.parquet.util.ParquetCommon](bigdata.parquet.util.ParquetCommon.md)
Sealed            | false
Construct on load | false



## Constructor Summary

Constructor | Summary
:---------------------------------------------------- | :--------------
[Tools](bigdata.parquet.Tools.Tools.md) | Constructor 



## Property Summary

Property | Summary
:---------------------------------------------------------- | :---
[ToolPath](bigdata.parquet.Tools.ToolPath.md) |  



## Method Summary

Attributes | Method | Summary
:---------- | :------------------------------------------------------------------------------ | :----------------------------------------------------------------------------
        |  [addJars](bigdata.parquet.Tools.addJars.md)                      |  Dynamically add JAR\'s from the lib/jar folder 
        |  [addListeners](bigdata.parquet.Tools.addListeners.md)            |  Add our PostSet listeners for properties 
        |  [addlistener](bigdata.parquet.Tools.addlistener.md)              |  Add listener for event. 
        |  [cat](bigdata.parquet.Tools.cat.md)                              |  Prints the content of a Parquet file 
        |  [clearJars](bigdata.parquet.Tools.clearJars.md)                  |  Clear dynamic JAR\'s from the resourcs/jar folder 
        |  [construct](bigdata.parquet.Tools.construct.md)                  |  the object using default initialization steps 
        |  [delete](bigdata.parquet.Tools.delete.md)                        |  Delete a handle object. 
        |  [dump](bigdata.parquet.Tools.dump.md)                            |  Prints the content and metadata of a Parquet file 
        |  [eq](bigdata.parquet.Tools.eq.md)                                |  == (EQ) Test handle equality. 
        |  [findobj](bigdata.parquet.Tools.findobj.md)                      |  Find objects matching specified conditions. 
        |  [findprop](bigdata.parquet.Tools.findprop.md)                    |  Find property of MATLAB handle object. 
        |  [ge](bigdata.parquet.Tools.ge.md)                                |  \>= (GE) Greater than or equal relation for handles. 
        |  [getResourcesFolder](bigdata.parquet.Tools.getResourcesFolder.md)|  Get the path to the resources folder 
        |  [getSourceFolder](bigdata.parquet.Tools.getSourceFolder.md)      |  Return the Source folder path 
        |  [gt](bigdata.parquet.Tools.gt.md)                                |  \> (GT) Greater than relation for handles. 
        |  [head](bigdata.parquet.Tools.head.md)                            |  Prints the first n record of the Parquet file 
        |  [help](bigdata.parquet.Tools.help.md)                            |  Get help for parquet-tools 
Sealed  |  [isvalid](bigdata.parquet.Tools.isvalid.md)                      |  Test handle validity. 
        |  [le](bigdata.parquet.Tools.le.md)                                |  \<= (LE) Less than or equal relation for handles. 
        |  [listener](bigdata.parquet.Tools.listener.md)                    |  Add listener for event without binding the listener to the source object. 
        |  [lt](bigdata.parquet.Tools.lt.md)                                |  \< (LT) Less than relation for handles. 
        |  [merge](bigdata.parquet.Tools.merge.md)                          |  Merges multiple Parquet files into one 
        |  [meta](bigdata.parquet.Tools.meta.md)                            |  Prints the metadata of Parquet file(s) 
        |  [ne](bigdata.parquet.Tools.ne.md)                                |  \~= (NE) Not equal relation for handles. 
        |  [notify](bigdata.parquet.Tools.notify.md)                        |  Notify listeners of event. 
        |  [parseInputs](bigdata.parquet.Tools.parseInputs.md)              |  Parse property values as property/value pairs 
        |  [schema](bigdata.parquet.Tools.schema.md)                        |  Prints the schema of Parquet file(s) 
        |  [setter](bigdata.parquet.Tools.setter.md)                        |  Callback for property PostSet listener 
Static  |  [validateFile](bigdata.parquet.Tools.validateFile.md)            |  Validate the File property 
Static  |  [validateFiles](bigdata.parquet.Tools.validateFiles.md)          |  Validate an array of files 



## Event Summary

Event | Summary
:---------------------------------------------------------------------------------- | :------------------------------------------------------------------
[ObjectBeingDestroyed](bigdata.parquet.Tools.ObjectBeingDestroyed.md) | Notifies listeners that a particular object has been destroyed. 
