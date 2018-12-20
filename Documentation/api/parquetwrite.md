
#   parquetwrite 







Write data to a Parquet file

parquetwrite(FILE, DATA, *Property, Value*,...) Writes DATA to a Parquet
FILE using optional *Property, Value* pairs defined by the Writer class.

WRITER = parquetwrite(...) optionally return the Writer object.

#### Example: Create an array and write to tmp.parquet

parquetwrite('tmp.parquet', randn(10))



See also



[bigdata.parquet.Writer](bigdata.parquet.Writer.md),
[parquetread](parquetread.md)
