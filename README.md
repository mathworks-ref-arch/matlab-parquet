[//]: #  (Copyright 2017, The MathWorks, Inc.)

# MATLAB Interface *for Apache Parquet*
## Introduction
[Apache™ Parquet](https://parquet.apache.org/) is a columnar storage format
available to any project in the Hadoop ecosystem, regardless of the choice of
data processing framework, data model or programming language.

The MATLAB interface for Apache Parquet provides for reading and writing of Apache Parquet files from within MATLAB. Functionality includes:
* Read and write of local Parquet files
* Access to meta data of a Parquet file
* A MATLAB Datastore for reading Parquet files

For newer MATLAB releases, starting with R2019a, consider using the shipping Parquet support,
see https://www.mathworks.com/help/releases/R2019b/matlab/parquet-files.html.

## Requirements
### MathWorks Products (http://www.mathworks.com)
* Requires MATLAB release R2017b or newer

### 3rd Party Products:
For building the JAR file, please make sure the following products are already installed (or install & downlaod from provided links):
- [Maven](https://maven.apache.org/download.cgi)
- [JDK 8](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
- Apache™ Hadoop®

#### Apache Hadoop installation and configuration
##### Linux/MacOS
Download & unzip binaries from Apache Hadoop official [website](https://hadoop.apache.org/releases.html) to a local folder.

##### Microsoft® Windows®
On Windows, a compatible utility version called ```winutils.exe``` can be downloaded from
[https://github.com/steveloughran/winutils/raw/master/hadoop-2.8.3/bin/winutils.exe](https://github.com/steveloughran/winutils/raw/master/hadoop-2.8.3/bin/winutils.exe).
After download, we would recommend placing the executable under `<repo_root>\Software\MATLAB\lib\hadoop\bin\winutils.exe`

*Note that you will need to first manually create the `lib\hadoop\bin` folders*

More detailed information on Windows install can be found
[here](Documentation/Windows.md).

## Installation
Installation of the interface requires building the support package (Jar file) and setting the environment variable value for HADOOP_HOME. Before proceeding:
* Install Java SDK and Maven.
* Clone repository or download + unzip/tar latest sources [release](https://github.com/mathworks-ref-arch/matlab-parquet/releases).
* Create/Set HADOOP_HOME environment variable to point to Apache™ Hadoop® installation local folder *(Linux/MacOS)* or to the folder where ```winutils.exe``` executable is located (as suggested/explained below) *(Windows)*

The links to download these products are provided in the section [3rd party products](#3rd-party-products).

To set the environment variable, please follow rules for your operating system.
Please note, that this environment variable must be set **prior** to starting MATLAB.
*Changing the environment variable from within MATLAB will not have the desired effect.*

### Build the Jar file
To install the interface, you must first build the Jar file.
```bash
cd <this_repo>
cd Software/Java
mvn clean package
```

### Install & Verify MATLAB package
Now you can open MATLAB and install the support package.
```MATLAB
cd <this_repo>/Software
install
```
Restart MATLAB, and verify installation:
Windows
```matlab
parquetwin('verify')
```

In case of issues, please refer to the following [documentation](Documentation/Windows.md).
Otherwise, you're good to go.

Linux
```matlab
parquettools('meta')
```

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
The license for MATLAB interface *for Parquet* is available in the [LICENSE.md](LICENSE.md) file in this GitHub repository.
This package uses certain third-party content which is licensed under separate license agreements.
See the [pom.xml](Software/Java/pom.xml) file for third-party software downloaded at build time.

## Enhancement Request
Provide suggestions for additional features or capabilities using the following link:   
https://www.mathworks.com/products/reference-architectures/request-new-reference-architectures.html

## Support
Email: `mwlab@mathworks.com`

------------
