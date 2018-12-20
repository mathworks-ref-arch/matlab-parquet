[//]: #  (Copyright 2017, The MathWorks, Inc.)

# MATLAB Interface *for Apache Parquet*

## Requirements
### MathWorks Products (http://www.mathworks.com)
* Requires MATLAB release R2017b or newer

### 3rd Party Products:
For building the JAR file:
- [Maven](https://maven.apache.org/download.cgi)
- [JDK 8](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
- [Apache Hadoop](https://hadoop.apache.org/releases.html)


## Introduction
[Apache™ Parquet](https://parquet.apache.org/) is a columnar storage format
available to any project in the Hadoop ecosystem, regardless of the choice of
data processing framework, data model or programming language.

The MATLAB interface for Apache Parquet provides for reading and writing of Apache Parquet files from within MATLAB. Functionality includes:
* Read and write of local Parquet files
* Access to meta data of a Parquet file
* A MATLAB Datastore for reading Parquet files


## Installation
Installation of the interface requires building the support package (Jar file) and setting the environment variable value for HADOOP_HOME. Before proceeding, ensure that  
a) Java SDK and Maven are installed.  
b) HADOOP_HOME environment variable is set to a Apache™ Hadoop® installation. See instructions [below](#setting-hadoop_home-on-windows) for Microsoft® Windows®.

The links to download these products are provided in the section [3rd party products](#3rd-party-products).
To set the environment variable run the command below in MATLAB
```
setenv('HADOOP_HOME','<path to Apache Hadoop installation>');
```
Note that the above command needs to be run everytime MATLAB is restarted. Information on setting environment variables in MATLAB can be found [here](https://www.mathworks.com/help/matlab/ref/setenv.html).

### Setting HADOOP_HOME on Windows

On Windows, the environment variable **HADOOP_HOME** can point to a compatible utility version called ```winutils.exe```. The exact value of **HADOOP_HOME** to be used
on Windows can be found by this command:
```matlab
>> parquetwin('hadoop_home')
ans =
    '<repo_root>\Software\MATLAB\lib\hadoop'
```

This file can be downloaded from
[https://github.com/steveloughran/winutils/raw/master/hadoop-2.8.3/bin/winutils.exe](https://github.com/steveloughran/winutils/raw/master/hadoop-2.8.3/bin/winutils.exe).

The downloaded file should be placed in
```matlab
<repo_root>\Software\MATLAB\lib\hadoop\bin\winutils.exe
```

More detailed information on Windows install can be found
[here](Documentation/Windows.md).

### Build the Jar file
To install the interface, you must first build the Jar file.
```bash
cd <this_repo>
cd Software/Java
mvn clean package
```

### Install MATLAB package
Now you can open MATLAB and install the support package.
```MATLAB
cd <this_repo>/Software
install
```
Restart MATLAB, and you're good to go.


## Usage

To write a variable to a Parquet file:
```MATLAB
A = magic(5);
parquetwrite('m5.parquet', A);
```

and you can read the same file with
```MATLAB
B = parquetread('m5.parquet');
```

A few unit tests can be run with
```MATLAB
results = runParquetTests()
```

For more details, look at the [Basic Usage document](Documentation/BasicUsage.md).


## Documentation
See [documentation](Documentation/README.md) for more information.


## License
The license for MATLAB interface *for Parquet* is available in the [LICENSE.TXT](LICENSE.TXT) file in this GitHub repository.
This package uses certain third-party content which is licensed under separate license agreements.
See the [pom.xml](Software/Java/pom.xml) file for third-party software downloaded at build time.

## Enhancement Request
Provide suggestions for additional features or capabilities using the following link:   
https://www.mathworks.com/products/reference-architectures/request-new-reference-architectures.html

## Support
Email: `mwlab@mathworks.com`

------------
