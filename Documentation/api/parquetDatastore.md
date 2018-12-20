
#   parquetDatastore 







Create a datastore for Parquet files

DS = parquetDatastore(FILE, *Property, Value*,...) Create a Parquet
datastore using FILE with optional *Property, Value* pairs defined by the
ParquetDatastore class and return the datastore DS.

Theres a special case for FILE, '-getHDFSHome' that returns the HDFS home
URI.

#### Example: Create a Parquet datastore

ds = parquetDatastore('hdfs:///user/ubuntu/data/*.parquet');

#### Example: Return the HDFS home URI

uri = parquetDatastore('-getHDFSHome');



See also



[bigdata.parquet.ParquetDatastore](bigdata.parquet.ParquetDatastore.md),
[parquetread](parquetread.md)
