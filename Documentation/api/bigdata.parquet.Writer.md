
#   bigdata.parquet.Writer 







Class for writing Parquet files



See also



[bigdata.parquet.Writer/write](bigdata.parquet.Writer/write.md),
[bigdata.parquet.Reader](bigdata.parquet.Reader.md)



## Class Details 

Attributes | Class
:------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------
Superclasses      | [bigdata.parquet.util.Core](bigdata.parquet.util.Core.md), [bigdata.parquet.util.ParquetCommon](bigdata.parquet.util.ParquetCommon.md)
Sealed            | false
Construct on load | false



## Constructor Summary

Constructor | Summary
:------------------------------------------------------- | :---------------------------------
[Writer](bigdata.parquet.Writer.Writer.md) | Constructor for Parquet Writer 



## Property Summary

Property | Summary
:------------------------------------------------------------------------------- | :--------------------------------------------------------------------
[AppendData](bigdata.parquet.Writer.AppendData.md)                 | Append the data being written to current open writer 
[AutoGenerateSchema](bigdata.parquet.Writer.AutoGenerateSchema.md) | If set to true will try to auto-generate schema from data 
[CompressionCodec](bigdata.parquet.Writer.CompressionCodec.md)     | The compression codec to use 
[Data](bigdata.parquet.Writer.Data.md)                             | The data we will be writing 
[DeleteCRC](bigdata.parquet.Writer.DeleteCRC.md)                   | Select TRUE to delete any generated checksum CRC files 
[DictionaryEncoding](bigdata.parquet.Writer.DictionaryEncoding.md) | Enable/disable dictionary encoding 
[FileName](bigdata.parquet.Writer.FileName.md)                     | to write 
[MaxPaddingSize](bigdata.parquet.Writer.MaxPaddingSize.md)         | Max RowGroup padding size 
[MaxRows](bigdata.parquet.Writer.MaxRows.md)                       | Number of rows to write 
[MetaData](bigdata.parquet.Writer.MetaData.md)                     | File metadata entry of the form \[\"key\", \"value\"\] 
[PageSize](bigdata.parquet.Writer.PageSize.md)                     | The page size in bytes 
[RowGroupSize](bigdata.parquet.Writer.RowGroupSize.md)             | The RowGroup size in bytes, should be same as HDFS block size 
[Schema](bigdata.parquet.Writer.Schema.md)                         | The Parquet file schema, this can be a string/char or MessageType 
[Validation](bigdata.parquet.Writer.Validation.md)                 | Validate the file has been written 
[WriteMode](bigdata.parquet.Writer.WriteMode.md)                   | Write mode being used 
[WriterVersion](bigdata.parquet.Writer.WriterVersion.md)           | Writer version being used 



## Method Summary

Attributes | Method | Summary
:---------- | :----------------------------------------------------------------------------------- | :----------------------------------------------------------------------------
        |  [addJars](bigdata.parquet.Writer.addJars.md)                          |  Dynamically add JAR\'s from the lib/jar folder 
        |  [addListeners](bigdata.parquet.Writer.addListeners.md)                |  Add our PostSet listeners for properties 
        |  [addlistener](bigdata.parquet.Writer.addlistener.md)                  |  Add listener for event. 
        |  [append](bigdata.parquet.Writer.append.md)                            |  Append to existing parquet file 
Static  |  [bytes](bigdata.parquet.Writer.bytes.md)                              |  Convert human readable size input to bytes 
        |  [clearJars](bigdata.parquet.Writer.clearJars.md)                      |  Clear dynamic JAR\'s from the resourcs/jar folder 
        |  [construct](bigdata.parquet.Writer.construct.md)                      |  the object using default initialization steps 
Static  |  [convertColumn](bigdata.parquet.Writer.convertColumn.md)              |  Convert this MATLAB column to correct type for Parquet Writer 
        |  [convertData](bigdata.parquet.Writer.convertData.md)                  |  Converts the data for the Parquet writer 
        |  [delete](bigdata.parquet.Writer.delete.md)                            |  Release Java objects 
        |  [eq](bigdata.parquet.Writer.eq.md)                                    |  == (EQ) Test handle equality. 
        |  [findobj](bigdata.parquet.Writer.findobj.md)                          |  Find objects matching specified conditions. 
        |  [findprop](bigdata.parquet.Writer.findprop.md)                        |  Find property of MATLAB handle object. 
        |  [finish](bigdata.parquet.Writer.finish.md)                            |  appending data 
        |  [ge](bigdata.parquet.Writer.ge.md)                                    |  \>= (GE) Greater than or equal relation for handles. 
        |  [generateSchemaString](bigdata.parquet.Writer.generateSchemaString.md)|  Generate a Parquet schema string from underlying data 
        |  [getColumnParquetType](bigdata.parquet.Writer.getColumnParquetType.md)|  Get the column type used for Parquet auto-generated schema 
Static  |  [getMatlabType](bigdata.parquet.Writer.getMatlabType.md)              |  Get the MATLAB data type 
        |  [getResourcesFolder](bigdata.parquet.Writer.getResourcesFolder.md)    |  Get the path to the resources folder 
        |  [getSizeAndFields](bigdata.parquet.Writer.getSizeAndFields.md)        |  Get the data size and fields 
        |  [getSourceFolder](bigdata.parquet.Writer.getSourceFolder.md)          |  Return the Source folder path 
        |  [gt](bigdata.parquet.Writer.gt.md)                                    |  \> (GT) Greater than relation for handles. 
Sealed  |  [isvalid](bigdata.parquet.Writer.isvalid.md)                          |  Test handle validity. 
        |  [le](bigdata.parquet.Writer.le.md)                                    |  \<= (LE) Less than or equal relation for handles. 
        |  [listener](bigdata.parquet.Writer.listener.md)                        |  Add listener for event without binding the listener to the source object. 
        |  [lt](bigdata.parquet.Writer.lt.md)                                    |  \< (LT) Less than relation for handles. 
        |  [ne](bigdata.parquet.Writer.ne.md)                                    |  \~= (NE) Not equal relation for handles. 
        |  [notify](bigdata.parquet.Writer.notify.md)                            |  Notify listeners of event. 
        |  [parseInputs](bigdata.parquet.Writer.parseInputs.md)                  |  Parse property values as property/value pairs 
        |  [setter](bigdata.parquet.Writer.setter.md)                            |  Callback for property PostSet listener 
Static  |  [validateFile](bigdata.parquet.Writer.validateFile.md)                |  Validate the File property 
Static  |  [validateFiles](bigdata.parquet.Writer.validateFiles.md)              |  Validate an array of files 
        |  [write](bigdata.parquet.Writer.write.md)                              |  data to Parquet file 



## Event Summary

Event | Summary
:----------------------------------------------------------------------------------- | :------------------------------------------------------------------
[ObjectBeingDestroyed](bigdata.parquet.Writer.ObjectBeingDestroyed.md) | Notifies listeners that a particular object has been destroyed. 
