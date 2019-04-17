[//]: #  (Copyright 2017, The MathWorks, Inc.)

# MATLAB Interface *for Apache Parquet*

## Overview
[Apache Parquet](https://parquet.apache.org/) is a columnar storage format
available to any project in the Hadoop ecosystem, regardless of the choice of
data processing framework, data model or programming language.

Parquet is built from the ground up with complex nested data structures in mind,
and uses the record shredding and assembly algorithm derived from Dremel,  [https://blog.twitter.com/engineering/en_us/a/2013/dremel-made-simple-with-parquet.html](https://blog.twitter.com/engineering/en_us/a/2013/dremel-made-simple-with-parquet.html).

Parquet is built to support very efficient compression and encoding schemes.
Multiple projects have demonstrated the performance impact of applying the
right compression and encoding scheme to the data.
Parquet allows compression schemes to be specified on a per-column level,
and is future-proofed to allow adding more encodings as they are invented and
implemented.

## Contents:
1. System Requirements

    [MATLAB](https://www.mathworks.com/support/sysreq.html) 2017b or newer

2. Installing the support package

    Please see the top level [README](../README.md) for installation instructions.

3. Basic usage

    See the [usage](BasicUsage.md) guide on how to get started.

4. API reference

    The functions and classes for working with Apache Parquet files in MATLAB.

    The markdown versions of the help may not include all links and one should consult the shipped Help documentation for full documentation set.

    - [Functions](Functions.md)
    - [Classes](Classes.md)


