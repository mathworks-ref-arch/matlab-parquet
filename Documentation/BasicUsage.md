[//]: #  (Copyright 2017, The MathWorks, Inc.)

# MATLAB Interface *for Apache Parquet*

## Getting Started
In MATLAB you can find help by navigating to **Documentation >
Supplemental Software > MATLAB Interface for Parquet Toolbox**, or by
running a command such as ```doc parquetread```.

The Parquet interface can handle writing and reading MATLAB container datatypes such as:

- numeric/string arrays
- cells
- structs
- table
- timetable

It supports all the core MATLAB types

- datetime
- duration
- numeric
- string
- char

## Writing and Reading Parquet Files
The two main function for reading and writing are wrappers around respective Reader and Writer classes.
As such the functions take as input optional *Property/Value* pairs which are public properties of the above classes.

- parquetwrite
- parquetread
- parquetDatastore

We also have utility functions

- parquetinfo  - Returns the meta information of the Parquet file as a structure
- parquettools - Runs parquet-tools.jar if it has been installed in the resources folder

### Write a Parquet file
Create a timetable of daily-stock returns for a portfolio of ten stocks for a year.

```matlab
days = datetime(2000,1,1) : datetime(2000,12,31);
n    = length(days);
s    = 10;
r    = cumsum(randn(n,s));
data = array2timetable(r,'RowTimes',days');

% Add an additional field named News that stores news event id's
data.News = "News_" + (1 : n)';
```

Write this data to tmp.parquet, and return the optional Writer class
```matlab
writer = parquetwrite('tmp.parquet', data)
```

Lets look at the Writer properties:
```
writer =
Writer with properties:

FileName: 'file:///Users/[username]/Work/mathworks/BigData/Parquet/Software/Source/MATLAB/matlab/doc/examples/tmp.parquet'
Schema: 'message MATLAB_Generated_Schema {↵required int32 Time (DATE) ;↵required double r1  ;↵required double r2  ;↵required double r3  ;↵required double r4  ;↵required double r5  ;↵required double r6  ;↵required double r7  ;↵required double r8  ;↵required double r9  ;↵required double r10  ;↵required binary News (UTF8) ;↵}'
CompressionCodec: SNAPPY
DictionaryEncoding: TRUE
MaxPaddingSize: 0
PageSize: 8388608
RowGroupSize: 134217728
Validation: TRUE
WriteMode: CREATE
WriterVersion: PARQUET_2_0
DeleteCRC: TRUE
AppendData: FALSE
AutoGenerateSchema: TRUE
MaxRows: 1000000
Data: [366×11 timetable]
MetaData: [2×2 string]
ShowJarLoadedMsg: FALSE
```

This uses the default Writer options, which we can use explicitly by calling the bigdata.parquet.Writer class, or we can return the Writer in the above example by specifying it as an output to **parquetwrite** with or without input arguments.


To get help at any time on an object remember we can do

```matlab
doc writer
```

Or

```matlab
help writer
```
```
--- help for bigdata.parquet.Writer ---

Class for writing Parquet files


See also bigdata.parquet.Writer/write, bigdata.parquet.Reader

Reference page for bigdata.parquet.Writer
```

To get specific help about a method or property such as the RowGroupSize, use the syntax

```matlab
help writer/RowGroupSize
```
```

>> help writer/RowGroupSize
--- help for bigdata.parquet.Writer/RowGroupSize ---

The RowGroup size in bytes, should be same as HDFS block size
```

By default you can see that we use Snappy compression with DictionaryEncoding, if we wanted to try Gzip option with no DictionaryEncoding. You can use TAB auto-completion after the '=' to see the valid options:
```matlab
writer.CompressionCodec   = 'GZIP';
writer.DictionaryEncoding = 'FALSE';
writer.WriteMode          = 'OVERWRITE';
writer.write
```

Using the function form:
```matlab
parquetwrite('tmp.parquet',data,'CompressionCodec','GZIP','DictionaryEncoding','FALSE','WriteMode','OVERWRITE')
```

### Parquet file information
We can read in detailed information about the Parquet file as a structure
```matlab
parquetinfo('tmp.parquet')
```

```
ans = struct with fields:
    fileMetaData: [1×1 struct]
    blocks: [1×1 struct]
    ```

    Similarly one could have run:

    ```matlab
    parquettools('meta','tmp.parquet')
    ```
    ```
    file:        file:/Users/[username]/Work/mathworks/BigData/Parquet/Software/Source/MATLAB/matlab/html/examples/tmp.parquet
    creator:     parquet-mr version 1.9.0 (build 38262e2c80015d0935dad20f8e18f2d6f9fbd03c)
    extra:       writer.model.name = Group
    extra:       matlab.datatype = timetable
    extra:       Time.matlab.datetime.Format = dd-MMM-uuuu

    file schema: MATLAB_Generated_Schema
    --------------------------------------------------------------------------------
    Time:        REQUIRED INT32 O:DATE R:0 D:0
    r1:          REQUIRED DOUBLE R:0 D:0
    r2:          REQUIRED DOUBLE R:0 D:0
    r3:          REQUIRED DOUBLE R:0 D:0
    r4:          REQUIRED DOUBLE R:0 D:0
    r5:          REQUIRED DOUBLE R:0 D:0
    r6:          REQUIRED DOUBLE R:0 D:0
    r7:          REQUIRED DOUBLE R:0 D:0
    r8:          REQUIRED DOUBLE R:0 D:0
    r9:          REQUIRED DOUBLE R:0 D:0
    r10:         REQUIRED DOUBLE R:0 D:0
    News:        REQUIRED BINARY O:UTF8 R:0 D:0

    row group 1: RC:366 TS:30558 OFFSET:4
    --------------------------------------------------------------------------------
    Time:         INT32 GZIP DO:0 FPO:4 SZ:72/62/0.86 VC:366 ENC:DELTA_BINARY_PACKED ST:[min: 2000-01-01, max: 2000-12-31, num_nulls: 0]
    r1:           DOUBLE GZIP DO:0 FPO:76 SZ:2902/2977/1.03 VC:366 ENC:PLAIN ST:[min: -21.194669299190764, max: 1.9623747075897313, num_nulls: 0]
    r2:           DOUBLE GZIP DO:0 FPO:2978 SZ:2941/2977/1.01 VC:366 ENC:PLAIN ST:[min: -14.311411840440215, max: 7.764961839175466, num_nulls: 0]
    r3:           DOUBLE GZIP DO:0 FPO:5919 SZ:2905/2977/1.02 VC:366 ENC:PLAIN ST:[min: -4.798400590384823, max: 16.0570623768234, num_nulls: 0]
    r4:           DOUBLE GZIP DO:0 FPO:8824 SZ:2915/2977/1.02 VC:366 ENC:PLAIN ST:[min: -21.286162010489313, max: 6.902528914377511, num_nulls: 0]
    r5:           DOUBLE GZIP DO:0 FPO:11739 SZ:2911/2977/1.02 VC:366 ENC:PLAIN ST:[min: -8.855479260687662, max: 41.863794203865325, num_nulls: 0]
    r6:           DOUBLE GZIP DO:0 FPO:14650 SZ:2845/2977/1.05 VC:366 ENC:PLAIN ST:[min: -30.43851473641735, max: -0.17459707997676358, num_nulls: 0]
    r7:           DOUBLE GZIP DO:0 FPO:17495 SZ:2926/2977/1.02 VC:366 ENC:PLAIN ST:[min: -3.659446373637675, max: 14.646868733576495, num_nulls: 0]
    r8:           DOUBLE GZIP DO:0 FPO:20421 SZ:2928/2977/1.02 VC:366 ENC:PLAIN ST:[min: -24.439467611973587, max: 6.712192568111136, num_nulls: 0]
    r9:           DOUBLE GZIP DO:0 FPO:23349 SZ:2911/2977/1.02 VC:366 ENC:PLAIN ST:[min: -11.841238603069216, max: 9.260105926489308, num_nulls: 0]
    r10:          DOUBLE GZIP DO:0 FPO:26260 SZ:2874/2977/1.04 VC:366 ENC:PLAIN ST:[min: -20.670224601210993, max: 1.8262276444731604, num_nulls: 0]
    News:         BINARY GZIP DO:0 FPO:29134 SZ:271/726/2.68 VC:366 ENC:DELTA_BYTE_ARRAY ST:[no stats for this column]
    ```

### Reading in a Parquet file
    Now lets read in the data, and also return the Reader class:

        ```matlab
        [read_data, reader] = parquetread('tmp.parquet');
        ```
        The reader can also support optional *Property/Value* pairs and we can see what they are:

        ```
        reader =
        Reader with properties:

        FetchFields: [0×0 string]
        FileName: 'file:///Users/[username]/Work/mathworks/BigData/Parquet/Software/Source/MATLAB/matlab/doc/examples/tmp.parquet'
        MaxRows: 10000000
        ShowJarLoadedMsg: FALSE
        ```

        We can specify only a subset of fields to fetch from the Parquet file and limit it to a certain number of rows to read as can be seen from the above properties.

        To verify data read in is the same as what we originally started with in MATLAB:

```matlab
assert(isequaln(read_data, data))
```

### Parquet files and datastore
In this example we will generate some files and then use a custom datastore to process the data using **tall** and a parallel pool of workers.

First create 20 Parquet files with one-million rows and two columns each of random data
```matlab
delete('*.parquet')
arrayfun(@(x) parquetwrite("tmp" + x + ".parquet", randn(1e6,2)), 1 : 20)
```

### ParquetDatastore
Using the ParquetDatastore we can easily perform analysis using tall arrays on a collection of Parquet files.
First create the datastore for all files in the current folder with file extension .parquet
```matlab
ds = parquetDatastore('*.parquet')
```
```
ds =
ParquetDatastore with properties:

AlternateFileSystemRoots: {}
```

Lets compute the mean by reading in all the data.
```matlab
tic
mean(ds.readall);
toc
```
```
Elapsed time is 8.198090 seconds.
```
You would not want to do this if the amount of data you have is much greater than your system memory. In that case you would want to use a tall array.

### ParquetDatastore and tall arrays
We can reuse the above datastore and create a tall array out of it

```matlab
t = tall(ds);
tic
gather(mean(t));
toc
```
```
Evaluating tall expression using the Local MATLAB Session:
- Pass 1 of 1: Completed in 7 sec
Evaluation completed in 7 sec
Elapsed time is 7.971272 seconds.
```

### ParquetDatastore tall arrays with Parallel Computing Toolbox
We can also run this in parallel on the local machine by using parpool

```matlab
parpool
```
```
Starting parallel pool (parpool) using the 'local' profile ...
connected to 4 workers.

ans =

Pool with properties:

        Connected: true
       NumWorkers: 4
          Cluster: local
    AttachedFiles: {}
AutoAddClientPath: true
      IdleTimeout: 30 minutes (30 minutes remaining)
      SpmdEnabled: true
```

```matlab
t = tall(ds);
```
The first time we run a tall after starting the parpool the run-time will be slower due to adding JAR's to the classpath and other initialization tasks. Subsequent runs will be much faster.

Time to run using our local worker pool:

```matlab
tic
gather(mean(t));
toc
```
```
Evaluating tall expression using the Parallel Pool 'local':
- Pass 1 of 1: 33% complete
Evaluation 30% complete
Adding to dynamic javaclasspath:
/Users/[username]/Work/mathworks/BigData/Parquet/Software/Source/MATLAB/matlab/resources/jar/parquet-0.8.jar

Adding to dynamic javaclasspath:
/Users/[username]/Work/mathworks/BigData/Parquet/Software/Source/MATLAB/matlab/resources/jar/parquet-0.8.jar

Adding to dynamic javaclasspath:
/Users/[username]/Work/mathworks/BigData/Parquet/Software/Source/MATLAB/matlab/resources/jar/parquet-0.8.jar

Adding to dynamic javaclasspath:
/Users/[username]/Work/mathworks/BigData/Parquet/Software/Source/MATLAB/matlab/resources/jar/parquet-0.8.jar
- Pass 1 of 1: Completed in 9 sec
Evaluation completed in 12 sec
```
```
Elapsed time is 13.443853 seconds.
```

Lets run this again now that our pool is warmed up
```matlab
tic
gather(mean(t));
toc
```
```
Evaluating tall expression using the Parallel Pool 'local':
- Pass 1 of 1: Completed in 3 sec
Evaluation completed in 3 sec
```
```
Elapsed time is 3.972116 seconds.
```
Thus we can see that there is quite an improvement reading Parquet files using a tall arrays in parallel versus using a serial datastore approach.


### ParquetDatastore tall arrays with Spark on a Hadoop cluster
This example has been tested on Cloudera CDH 5.14

Copy over our files to a temporary folder on HDFS
```matlab
[~, tmp] = fileparts(tempname);
system(['hdfs dfs -mkdir /user/ubuntu/data/', tmp]);
system(['hdfs dfs -put *.parquet /user/ubuntu/data/', tmp]);
```

Set our environment variables for Hadoop
```matlab
setenv('HADOOP_PREFIX', '/opt/cloudera/parcels/CDH/');
setenv('SPARK_HOME', '/opt/cloudera/parcels/CDH/lib/spark');
```
Setup our datastore
```matlab
ds = parquetDatastore(['hdfs:///user/ubuntu/data/', tmp]);
```

Define execution environment
```matlab
cluster = parallel.cluster.Hadoop;
cluster.ClusterMatlabRoot = '/home/ubuntu/R2017b-mdcs';
mr = mapreducer(cluster);
mr.Cluster.AttachedFiles = {'/home/ubuntu/Documents/MATLAB/Add-Ons/Toolboxes/MATLAB Interface for Parquet/code/'};
```

Create tall array
```matlab
t = tall(ds);
```
Find the mean
```matlab
gather(mean(t))
```
