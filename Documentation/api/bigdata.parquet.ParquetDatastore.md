
#   bigdata.parquet.ParquetDatastore 







Class for creating a Parquet datastore



## Class Details 

Attributes | Class
:------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Superclasses      | [matlab.io.Datastore](matlab.io.Datastore.md), [matlab.io.datastore.Partitionable](matlab.io.datastore.Partitionable.md), [matlab.io.datastore.HadoopFileBased](matlab.io.datastore.HadoopFileBased.md)
Sealed            | false
Construct on load | false



## Constructor Summary

Constructor | Summary
:------------------------------------------------------------------------------------- | :-----------------------------------
[ParquetDatastore](bigdata.parquet.ParquetDatastore.ParquetDatastore.md) | Constructor for ParquetDatastore 



## Property Summary

Property | Summary
:----------------------------------------------------------------------------------------------------- | :---
[AlternateFileSystemRoots](bigdata.parquet.ParquetDatastore.AlternateFileSystemRoots.md) |  



## Method Summary

Attributes | Method | Summary
:------------- | :------------------------------------------------------------------------------------------- | :-------------------------------------------------------
Sealed     |  [copy](bigdata.parquet.ParquetDatastore.copy.md)                              |  Copy MATLAB array of handle objects.  
protected  |  [copyElement](bigdata.parquet.ParquetDatastore.copyElement.md)                |  Copy scalar MATLAB object.  
           |  [delete](bigdata.parquet.ParquetDatastore.delete.md)                          |  Delete a handle object. 
           |  [getFiles](bigdata.parquet.ParquetDatastore.getFiles.md)                      |  Get the list of files in the datastore 
           |  [getLocation](bigdata.parquet.ParquetDatastore.getLocation.md)                |  Return the location of the files in Hadoop. 
           |  [hasdata](bigdata.parquet.ParquetDatastore.hasdata.md)                        |  Return true if more data is available 
           |  [initializeDatastore](bigdata.parquet.ParquetDatastore.initializeDatastore.md)|  Initialize the datastore with necessary 
           |  [isfullfile](bigdata.parquet.ParquetDatastore.isfullfile.md)                  |  Return whether datastore supports full file or not. 
Sealed     |  [isvalid](bigdata.parquet.ParquetDatastore.isvalid.md)                        |  Test handle validity. 
protected  |  [maxpartitions](bigdata.parquet.ParquetDatastore.maxpartitions.md)            |  Return the maximum number of partitions possible for 
Sealed     |  [numpartitions](bigdata.parquet.ParquetDatastore.numpartitions.md)            |  Return an estimate for a reasonable number of 
           |  [partition](bigdata.parquet.ParquetDatastore.partition.md)                    |  Return a partitioned part of the Datastore. 
           |  [preview](bigdata.parquet.ParquetDatastore.preview.md)                        |  Preview the data contained in the datastore. 
           |  [progress](bigdata.parquet.ParquetDatastore.progress.md)                      |  Determine percentage of data read from datastore 
           |  [read](bigdata.parquet.ParquetDatastore.read.md)                              |  data and information about the extracted data 
           |  [readall](bigdata.parquet.ParquetDatastore.readall.md)                        |  Attempt to read all data from the datastore. 
           |  [reset](bigdata.parquet.ParquetDatastore.reset.md)                            |  to the start of the data 



## Event Summary

Event | Summary
:--------------------------------------------------------------------------------------------- | :------------------------------------------------------------------
[ObjectBeingDestroyed](bigdata.parquet.ParquetDatastore.ObjectBeingDestroyed.md) | Notifies listeners that a particular object has been destroyed. 
