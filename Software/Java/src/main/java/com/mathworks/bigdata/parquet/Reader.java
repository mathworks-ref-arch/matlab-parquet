/**
 * The Class Reader.
 */
/**
 *
 * Copyright (c) 2017, The MathWorks, Inc.
 */

package com.mathworks.bigdata.parquet;

import java.io.Closeable;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.LocalFileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.log4j.PropertyConfigurator;
import org.apache.parquet.example.data.Group;
import org.apache.parquet.format.converter.ParquetMetadataConverter;
import org.apache.parquet.format.converter.ParquetMetadataConverter.MetadataFilter;
import org.apache.parquet.hadoop.ParquetFileReader;
import org.apache.parquet.hadoop.ParquetReader;
import org.apache.parquet.hadoop.example.GroupReadSupport;
import org.apache.parquet.hadoop.metadata.ParquetMetadata;
import org.apache.parquet.io.api.Binary;
import org.apache.parquet.schema.MessageType;
import org.apache.parquet.schema.OriginalType;
import org.apache.parquet.schema.PrimitiveType.PrimitiveTypeName;
import org.apache.parquet.schema.Type;
import org.apache.parquet.schema.Type.Repetition;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.primitives.Ints;


public class Reader implements Closeable {

	/** The Constant logger. */
	private static final Logger logger = LoggerFactory.getLogger(Reader.class);

	/** The file name. */
	private String fileName;

	/** The max rows. */
	private int maxRows = 10_000_000;

	/** The parquet file reader. */
	private ParquetFileReader parquetFileReader;

	/** The start row. */
	private long startRow = 0;

	/** The is required. */
	private boolean[] isRequired;

	/** The missing data index. */
	private List<Integer> missingDataIndex = new ArrayList<>();

	/**
	 * Instantiates a new reader.
	 */
	public Reader() {
	}

	/**
	 * Instantiates a new reader.
	 *
	 * @param file the file
	 */
	public Reader(String file) {
		setFileName(file);
	}

	/**
	 * Close.
	 *
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public void close() throws IOException {
		parquetFileReader.close();
	}


	/**
	 * Gets the data.
	 *
	 * @return the data
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public Object[] getData() throws IOException {
		return readData(getFieldNames(parquetFileReader.getFileMetaData().getSchema()));
	}

	/**
	 * Gets the data.
	 *
	 * @param fields the fields
	 * @return the data
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public Object[] getData(String[] fields) throws IOException {
		return readData(selectFields(fields));

	}

	/**
	 * Gets the field names.
	 *
	 * @param schema the schema
	 * @return the field names
	 */
	public String[] getFieldNames(MessageType schema) {
		int i = 0;
		int fieldCount = schema.getFieldCount();

		// Get the field names
		String[] fieldNames = new String[fieldCount];

		for (Type type : schema.getFields()) {
			fieldNames[i++] = type.getName();
		}

		return fieldNames;
	}

	/**
	 * Gets the file name.
	 *
	 * @return the file name
	 */
	public String getFileName() {
		return fileName;
	}

	/**
	 * Gets the max rows.
	 *
	 * @return the max rows
	 */
	public int getMaxRows() {
		return maxRows;
	}

	/**
	 * Gets the metadata.
	 *
	 * @return the metadata
	 */
	public String getMetadata() {
		return ParquetMetadata.toPrettyJSON(parquetFileReader.getFooter());
	}

	/**
	 * Gets the parquet file reader.
	 *
	 * @return the parquet file reader
	 */
	public ParquetFileReader getParquetFileReader() {
		return parquetFileReader;
	}

	/**
	 * Gets the start row.
	 *
	 * @return the start row
	 */
	public long getStartRow() {
		return startRow;
	}

	/**
	 * Initialize data.
	 *
	 * @param numRows the num rows
	 * @param fields  the fields
	 * @return the object[]
	 */
	private Object[] initializeData(int numRows, String[] fields) {

		// Get the schema
		MessageType schema = parquetFileReader.getFileMetaData().getSchema();

		// The number of fields
		int fieldCount = fields.length;

		// Initialize object array to store values and field names
		Object[] data = new Object[fieldCount + 3];

		// Initialize object array to store values and field names
		Object[] dataMissing = new Object[fieldCount];

		// Assign the field names
		data[fieldCount] = fields;

		// Array for storing the primitive types
		List<PrimitiveTypeName> typeName = new ArrayList<>();
		data[fieldCount + 1] = typeName;

		// Array for storing the logical types
		List<OriginalType> logicalType = new ArrayList<>();
		data[fieldCount + 2] = logicalType;

		// Contains array indicating if field is required
		isRequired = new boolean[fields.length];

		int column = 0;
		PrimitiveTypeName name;

		for (String field : fields) {

			// The logical type, UTF8, DATE_TIME, etc as defined in
			// https://github.com/apache/parquet-format/blob/master/LogicalTypes.md
			logicalType.add(schema.getType(field).getOriginalType());

			boolean required = schema.getType(field).getRepetition() == Repetition.REQUIRED;
			boolean optional = schema.getType(field).getRepetition() == Repetition.OPTIONAL;

			isRequired[column] = required;

			// Get the primitive name if field is primitive
			if (schema.getType(field).isPrimitive()) {
				name = schema.getType(field).asPrimitiveType().getPrimitiveTypeName();
				typeName.add(name);

				if (optional)
					dataMissing[column] = new long[numRows];

				switch (name) {
				case BOOLEAN:
					data[column] = new boolean[numRows];
					break;
				case DOUBLE:
					data[column] = new double[numRows];
					break;
				case FLOAT:
					data[column] = new float[numRows];
					break;
				case INT32:
					data[column] = new int[numRows];
					break;
				case INT64:
					data[column] = new long[numRows];
					break;
				case BINARY:
					boolean utf8 = logicalType.get(logicalType.size() - 1).equals(OriginalType.UTF8);
					if (utf8)
						data[column] = new String[numRows];
					break;
				case INT96:
					data[column] = new long[numRows];
					break;
				case FIXED_LEN_BYTE_ARRAY:
					data[column] = new Binary[numRows];
					break;
				default:
				}
			} else {
				// For Groups at the moment such as LIST and MAP

				// From the schema we can get the paths, getPaths as a List and then use those
				// entries to get the primitive value of the final elements in the LIST/MAP
				// schema.getType(schema.getPaths()[0])
				// Then from that get MaxRepetitonLevel
				// schema.getType(schema.MaxRepetitonLevel()[0])
				// this would then give us enough information to construct a primitive array of
				// this length

				typeName.add(null);
				data[column] = new ArrayList<>();
			}
			column++;
		}
		return data;
	}

	/**
	 * Initialize file reader.
	 *
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	private void initializeFileReader() throws IOException {

		Configuration conf = new Configuration();

		conf.set("fs.hdfs.impl", "org.apache.hadoop.hdfs.DistributedFileSystem");
		conf.set("fs.file.impl", LocalFileSystem.class.getName());

		MetadataFilter filter = ParquetMetadataConverter.NO_FILTER;
		parquetFileReader = new ParquetFileReader(conf, new Path(fileName), filter);
	}

	/**
	 * Initialize reader.
	 *
	 * @return the parquet reader
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	private ParquetReader<Group> initializeReader() throws IOException {

		GroupReadSupport groupReadSupport = new GroupReadSupport();
		return ParquetReader.builder(groupReadSupport, new Path(fileName)).build();
	}

	/**
	 * Inits the logger.
	 *
	 * @param logConfigFile the log config file
	 */
	public void initLogger(String logConfigFile) {
		PropertyConfigurator.configure(logConfigFile);
	}

	/**
	 * Process data row.
	 *
	 * @param data    the data
	 * @param group   the group
	 * @param row     the row
	 * @param column  the column
	 * @param field   the field
	 * @param type    the type
	 * @param logical the logical
	 */
	@SuppressWarnings("unchecked")
	private void processDataRow(Object[] data, Group group, int row, int column, String field, PrimitiveTypeName type,
			OriginalType logical) {

		if (group.getFieldRepetitionCount(field) == 0) {
			missingDataIndex.add(row);
			missingDataIndex.add(column);
			return;
		}

		if (type == null)
			((List<Group>) data[column]).add(group.getGroup(field, 0));
		else {
			switch (type) {
			case BOOLEAN:
				((boolean[]) data[column])[row] = group.getBoolean(field, 0);
				break;
			case DOUBLE:
				((double[]) data[column])[row] = group.getDouble(field, 0);
				break;
			case FLOAT:
				((float[]) data[column])[row] = group.getFloat(field, 0);
				break;
			case INT32:
				((int[]) data[column])[row] = group.getInteger(field, 0);
				break;
			case INT64:
				((long[]) data[column])[row] = group.getLong(field, 0);
				break;
			case INT96:
				((long[]) data[column])[row] = int96TimeStamp(group.getInt96(field, 0));
				break;
			case BINARY:
				if (logical.equals(OriginalType.UTF8))
					((String[]) data[column])[row] = group.getString(field, 0);
				break;
			case FIXED_LEN_BYTE_ARRAY:
				((Binary[]) data[column])[row] = group.getBinary(field, 0);
				break;
			default:
			}
		}
	}

	/**
	 * Int 96 time stamp.
	 *
	 * @param int96 the int 96
	 * @return the long
	 */
	private long int96TimeStamp(Binary int96) {
		ByteBuffer buf = int96.toByteBuffer();
		buf.order(ByteOrder.LITTLE_ENDIAN);
		long timeOfDayNanos = buf.getLong();
		int julianDay = buf.getInt();
		return (julianDay - 2440588) * 86400 + timeOfDayNanos / (1000 * 1000 * 1000);
	}

	/**
	 * Read data.
	 *
	 * @param fieldNames the field names
	 * @return the object[]
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	private Object[] readData(String[] fieldNames) throws IOException {

		// Number of rows in file
		long numRows = parquetFileReader.getRecordCount();

		// Limit to maxRows
		if (maxRows > 0)
			numRows = numRows < maxRows ? numRows : maxRows;

		// Initialize the data array
		Object[] data = initializeData((int) numRows, fieldNames);

		@SuppressWarnings("unchecked")
		List<PrimitiveTypeName> typeNames = (List<PrimitiveTypeName>) data[fieldNames.length + 1];

		@SuppressWarnings("unchecked")
		List<OriginalType> logicalType = (List<OriginalType>) data[fieldNames.length + 2];

		// Get our reader
		ParquetReader<Group> reader = initializeReader();
		Group group;

		// Iterate through each row in the group and add to data
		for (int i = 0; i < numRows; i++) {
			try {
				group = reader.read();
				int j = 0;
				for (String field : fieldNames) {
					processDataRow(data, group, i, j, field, typeNames.get(j), logicalType.get(j));
					j++;
				}
			} catch (Exception e) {
				logger.error("readData problem at row = " + i, e);
			}
		}
		reader.close();
		return data;
	}

	/**
	 * Select fields.
	 *
	 * @param fields the fields
	 * @return the string[]
	 */
	private String[] selectFields(String[] fields) {
		// Fields in the file
		String[] fieldNames = getFieldNames(parquetFileReader.getFileMetaData().getSchema());

		if (fields != null) {
			List<String> list = new ArrayList<>(Arrays.asList(fieldNames));

			// Fields list to fetch
			List<String> fetchList = new ArrayList<>();

			for (String field : fields) {
				// Check if requested field exists in the file
				if (list.contains(field))
					fetchList.add(field);
			}
			fieldNames = fetchList.toArray(new String[fetchList.size()]);
		}
		return fieldNames;
	}

	/**
	 * Sets the file name.
	 *
	 * @param fileName the new file name
	 */
	public void setFileName(String fileName) {

		if (fileName != null && !fileName.isEmpty()) {
			this.fileName = fileName;
			try {
				initializeFileReader();
			} catch (Exception e) {
				logger.error("Problem initializing ParquetFile reader with File: " + fileName, e);
			}
		}
	}

	/**
	 * Sets the max rows.
	 *
	 * @param maxRows the new max rows
	 */
	public void setMaxRows(int maxRows) {
		this.maxRows = maxRows;
	}

	/**
	 * Sets the start row.
	 *
	 * @param startRow the new start row
	 */
	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}

	/**
	 * Gets the missing data index.
	 *
	 * @return the missing data index
	 */
	public int[] getMissingDataIndex() {
		return Ints.toArray(missingDataIndex);
	}

	class Data {
		// Get the schema
		MessageType schema;

		// The number of fields
		int fieldCount;

		// Initialize object array to store values and field names
		Object[] columnValues;

		// Initialize object array to store values and field names
		Object[] dataMissing;

		// Assign the field names
		String[] fieldNames;

		// Array for storing the primitive types
		List<PrimitiveTypeName> typeName = new ArrayList<>();

		// Array for storing the logical types
		List<OriginalType> logicalType = new ArrayList<>();

		// Contains array indicating if field is required
		boolean[] isRequired;
	}

}
