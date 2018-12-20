
#   parquetread 







Read a Parquet file

DATA = parquetread(FILE, *Property, Value*,...) Read the Parquet FILE with
optional *Property, Value* pairs defined by the Reader class and return as
DATA.

[DATA, READER] = parquetread(...) optional second argument returns the
Reader class.

Valid *Property, Value* pairs are:

'FetchFields', (string array) fields to fetch, empty string returns
all fields and is the default.

'ReplaceMissing',(boolean) replace missing values in Parquet file with
the MATLAB missing value. Default is false. Also see help on
Reader.addMissing

'FileName' (char) the name of the Parquet file to read

'MaxRows', (double) number of rows to read, if < 0 read all rows in file

#### Example: Read in a Parquet file

data = parquetread('tmp.parquet');

#### Example: Read in a Parquet file and replace missing values with the missing datatype

data = parquetread('tmp.parquet','ReplaceMissing', true);



See also



[bigdata.parquet.Reader](bigdata.parquet.Reader.md),
[parquetwrite](parquetwrite.md)
