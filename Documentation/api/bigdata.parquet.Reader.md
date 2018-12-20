
#   bigdata.parquet.Reader 







Class for reading Parquet files

#### Example: Read in at most 100 rows from a Parquet file

import bigdata.parquet.Reader
p = Reader('FileName','tmp.parquet','MaxRows',100)
data = p.read;



See also



[bigdata.parquet.Reader/read](bigdata.parquet.Reader/read.md),
[bigdata.parquet.Writer](bigdata.parquet.Writer.md)



## Class Details 

Attributes | Class
:------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------
Superclasses      | [bigdata.parquet.util.Core](bigdata.parquet.util.Core.md), [bigdata.parquet.util.ParquetCommon](bigdata.parquet.util.ParquetCommon.md)
Sealed            | false
Construct on load | false



## Constructor Summary

Constructor | Summary
:------------------------------------------------------- | :---------------------------------
[Reader](bigdata.parquet.Reader.Reader.md) | Constructor for Parquet Reader 



## Property Summary

Property | Summary
:----------------------------------------------------------------------- | :---------------------------------------------------------------------
[FetchFields](bigdata.parquet.Reader.FetchFields.md)       | Fields to fetch as a string array, empty string returns all fields 
[FileName](bigdata.parquet.Reader.FileName.md)             | to read 
[MaxRows](bigdata.parquet.Reader.MaxRows.md)               | Number of rows to read, if \< 0 read all rows in file 
[ReplaceMissing](bigdata.parquet.Reader.ReplaceMissing.md) | Replace null/missing values with the MATLAB missing value 



## Method Summary

Attributes | Method | Summary
:---------- | :------------------------------------------------------------------------------- | :----------------------------------------------------------------------------
        |  [addJars](bigdata.parquet.Reader.addJars.md)                      |  Dynamically add JAR\'s from the lib/jar folder 
        |  [addListeners](bigdata.parquet.Reader.addListeners.md)            |  Add our PostSet listeners for properties 
        |  [addMissing](bigdata.parquet.Reader.addMissing.md)                |  Replace missing values in the data with the MISSING datatype 
        |  [addlistener](bigdata.parquet.Reader.addlistener.md)              |  Add listener for event. 
        |  [clearJars](bigdata.parquet.Reader.clearJars.md)                  |  Clear dynamic JAR\'s from the resourcs/jar folder 
        |  [construct](bigdata.parquet.Reader.construct.md)                  |  the object using default initialization steps 
        |  [delete](bigdata.parquet.Reader.delete.md)                        |  Delete a handle object. 
        |  [eq](bigdata.parquet.Reader.eq.md)                                |  == (EQ) Test handle equality. 
        |  [findobj](bigdata.parquet.Reader.findobj.md)                      |  Find objects matching specified conditions. 
        |  [findprop](bigdata.parquet.Reader.findprop.md)                    |  Find property of MATLAB handle object. 
        |  [ge](bigdata.parquet.Reader.ge.md)                                |  \>= (GE) Greater than or equal relation for handles. 
        |  [getFieldNames](bigdata.parquet.Reader.getFieldNames.md)          |  Get the field names present in the file 
        |  [getMetadata](bigdata.parquet.Reader.getMetadata.md)              |  Get the metadata and return as a JSON struct 
        |  [getMissingIndices](bigdata.parquet.Reader.getMissingIndices.md)  |  Return as a vector the row/column pairs where data is missing 
        |  [getNumRows](bigdata.parquet.Reader.getNumRows.md)                |  Get the number of rows in the file 
        |  [getResourcesFolder](bigdata.parquet.Reader.getResourcesFolder.md)|  Get the path to the resources folder 
        |  [getSchema](bigdata.parquet.Reader.getSchema.md)                  |  Return the schema for the parquet file 
        |  [getSourceFolder](bigdata.parquet.Reader.getSourceFolder.md)      |  Return the Source folder path 
        |  [gt](bigdata.parquet.Reader.gt.md)                                |  \> (GT) Greater than relation for handles. 
Sealed  |  [isvalid](bigdata.parquet.Reader.isvalid.md)                      |  Test handle validity. 
        |  [le](bigdata.parquet.Reader.le.md)                                |  \<= (LE) Less than or equal relation for handles. 
        |  [listener](bigdata.parquet.Reader.listener.md)                    |  Add listener for event without binding the listener to the source object. 
        |  [lt](bigdata.parquet.Reader.lt.md)                                |  \< (LT) Less than relation for handles. 
        |  [ne](bigdata.parquet.Reader.ne.md)                                |  \~= (NE) Not equal relation for handles. 
        |  [notify](bigdata.parquet.Reader.notify.md)                        |  Notify listeners of event. 
        |  [parseInputs](bigdata.parquet.Reader.parseInputs.md)              |  Parse property values as property/value pairs 
        |  [read](bigdata.parquet.Reader.read.md)                            |  the Parquet file into a table 
        |  [setter](bigdata.parquet.Reader.setter.md)                        |  Callback for property PostSet listener 
Static  |  [validateFile](bigdata.parquet.Reader.validateFile.md)            |  Validate the File property 
Static  |  [validateFiles](bigdata.parquet.Reader.validateFiles.md)          |  Validate an array of files 



## Event Summary

Event | Summary
:----------------------------------------------------------------------------------- | :------------------------------------------------------------------
[ObjectBeingDestroyed](bigdata.parquet.Reader.ObjectBeingDestroyed.md) | Notifies listeners that a particular object has been destroyed. 
