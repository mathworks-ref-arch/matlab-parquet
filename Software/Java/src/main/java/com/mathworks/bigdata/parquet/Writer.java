/**
 * The Class Writer.
 */
/**
 *
 * Copyright (c) 2017, The MathWorks, Inc.
 */

package com.mathworks.bigdata.parquet;

import java.io.Closeable;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.LocalFileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.log4j.PropertyConfigurator;
import org.apache.parquet.column.ParquetProperties.WriterVersion;
import org.apache.parquet.example.data.Group;
import org.apache.parquet.example.data.simple.SimpleGroupFactory;
import org.apache.parquet.hadoop.ParquetFileWriter;
import org.apache.parquet.hadoop.ParquetFileWriter.Mode;
import org.apache.parquet.hadoop.ParquetWriter;
import org.apache.parquet.hadoop.ParquetWriter.Builder;
import org.apache.parquet.hadoop.api.WriteSupport;
import org.apache.parquet.hadoop.metadata.CompressionCodecName;
import org.apache.parquet.hadoop.metadata.FileMetaData;
import org.apache.parquet.schema.MessageType;
import org.apache.parquet.schema.MessageTypeParser;
import org.apache.parquet.schema.OriginalType;
import org.apache.parquet.schema.PrimitiveType.PrimitiveTypeName;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class Writer implements Closeable {
	public static void main(String args[]) {
		System.out.println("Hello world!");
	}

	/**
	 * The Class PQWBuilder.
	 */
	public static class PQWBuilder extends Builder<Group, PQWBuilder> {

		/** The extra meta data. */
		private Map<String, String> extraMetaData;

		/** The schema. */
		private MessageType schema;

		/**
		 * Instantiates a new PQW builder.
		 *
		 * @param file the file
		 * @throws IOException Signals that an I/O exception has occurred.
		 */
		protected PQWBuilder(Path file) throws IOException {
			super(file);
		}

		/*
		 * (non-Javadoc)
		 *
		 * @see
		 * org.apache.parquet.hadoop.ParquetWriter.Builder#getWriteSupport(org.apache.
		 * hadoop.conf.Configuration)
		 */
		@Override
		protected WriteSupport<Group> getWriteSupport(Configuration conf) {
			GroupWriteSupport.setSchema(schema, conf);
			return new GroupWriteSupport(schema, extraMetaData);
		}

		/*
		 * (non-Javadoc)
		 *
		 * @see org.apache.parquet.hadoop.ParquetWriter.Builder#self()
		 */
		@Override
		protected PQWBuilder self() {
			return this;
		}

		/**
		 * With extra meta data.
		 *
		 * @param extraMetaData the extra meta data
		 * @return the PQW builder
		 */
		public PQWBuilder withExtraMetaData(Map<String, String> extraMetaData) {
			this.extraMetaData = extraMetaData;
			return this;
		}

		/**
		 * With schema.
		 *
		 * @param schema the schema
		 * @return the PQW builder
		 */
		public PQWBuilder withSchema(MessageType schema) {
			this.schema = schema;
			return this;
		}

	}

	/** The Constant logger. */
	private static final Logger logger = LoggerFactory.getLogger(Writer.class);

	/** The append data. */
	private boolean appendData = false;

	/** The compression codec. */
	private CompressionCodecName compressionCodec = CompressionCodecName.SNAPPY;

	/** The delete CRC. */
	private boolean deleteCRC = true;

	/** The dictionary encoding. */
	private boolean dictionaryEncoding = true;

	/** The extra meta data. */
	private Map<String, String> extraMetaData;

	/** The file name. */
	private String fileName;

	/** The max padding size. */
	private int maxPaddingSize = 0;

	/** The page size. */
	private int pageSize = 1024 * 1024;

	/** The parquet writer. */
	private ParquetWriter<Group> parquetWriter;

	/** The row group size. */
	private int rowGroupSize = 1024 * 1024 * 128;

	/** The schema. */
	private MessageType schema;

	/** The simple group factory. */
	private SimpleGroupFactory simpleGroupFactory;

	/** The validation. */
	private boolean validation = true;

	/** The write data calls. */
	private int writeDataCalls = 0;

	/** The write mode. */
	private Mode writeMode = Mode.CREATE;

	/** The writer version. */
	private WriterVersion writerVersion = WriterVersion.PARQUET_2_0;

	/**
	 * Instantiates a new writer.
	 *
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public Writer() throws IOException {
	}

	/**
	 * Instantiates a new writer.
	 *
	 * @param file the file
	 */
	public Writer(String file) {
		setFileName(file);
	}

	/**
	 * Append.
	 *
	 * @param inputFiles the in
	 * @param outputFile the out
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public void append(String[] inputFiles, String outputFile) throws IOException {

		Configuration conf = new Configuration();

		// Create the list of input file paths
		List<Path> inFiles = new ArrayList<>();
		for (String infile : inputFiles) {
			inFiles.add(new Path(infile));
		}

		// Merge schema and extraMeta
		FileMetaData mergedMeta = ParquetFileWriter.mergeMetadataFiles(inFiles, conf).getFileMetaData();

		// Create writer for merging of data
		ParquetFileWriter writer = new ParquetFileWriter(conf, mergedMeta.getSchema(), new Path(outputFile),
				ParquetFileWriter.Mode.CREATE);

		// Iterate through files
		writer.start();
		for (Path inFile : inFiles) {
			writer.appendFile(conf, inFile);
		}
		writer.end(mergedMeta.getKeyValueMetaData());

		// Delete checksum if asked
		if (deleteCRC)
			deleteCRCFile(outputFile);
	}

	/**
	 * Close.
	 *
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public void close() throws IOException {
		if (parquetWriter != null) {
			parquetWriter.close();
		}
	}

	/**
	 * Creates the file writer.
	 */
	private void createFileWriter() {
		Configuration conf = new Configuration();

		conf.set("fs.hdfs.impl", "org.apache.hadoop.hdfs.DistributedFileSystem");
		conf.set("fs.file.impl", LocalFileSystem.class.getName());

		// We can either use the conf files to define defaultFS and other parameters:
		// conf.addResource(new Path("conf/core-site.xml"))
		// conf.addResource(new Path("conf/hdfs-site.xml"))
		simpleGroupFactory = new SimpleGroupFactory(schema);

		try {
			PQWBuilder pqwBuilder = new Writer.PQWBuilder(new Path(fileName));

			parquetWriter = pqwBuilder.withCompressionCodec(compressionCodec)
					.withConf(conf)
					.withDictionaryEncoding(dictionaryEncoding)
					.withMaxPaddingSize(maxPaddingSize)
					.withPageSize(pageSize)
					.withRowGroupSize(rowGroupSize)
					.withSchema(schema)
					.withExtraMetaData(extraMetaData)
					.withValidation(validation)
					.withWriteMode(writeMode)
					.withWriterVersion(writerVersion)
					.build();
		} catch (Exception e) {
			logger.error("Problem creating writer", e);
		}
	}

	/**
	 * Delete CRC file.
	 *
	 * @param file the file
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	private void deleteCRCFile(String file) throws IOException {
		// Delete the CRC file
		Path path2 = new Path(file);
		FileSystem fileSystem = path2.getFileSystem(new Configuration());
		String crcFileName = file.substring(file.lastIndexOf('/') + 1, file.length());
		String pathName = file.substring(0, file.lastIndexOf('/') + 1);

		fileSystem.delete(new Path(pathName + "." + crcFileName + ".crc"), false);
	}

	/**
	 * Finish.
	 *
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public void finish() throws IOException {
		// Reset the writeDataCalls
		writeDataCalls = 0;

		// Close the writer
		parquetWriter.close();

		// Delete checksum if asked
		if (deleteCRC)
			deleteCRCFile(fileName);

		parquetWriter = null;

	}

	/**
	 * Gets the compression codec.
	 *
	 * @return the compression codec
	 */
	public CompressionCodecName getCompressionCodec() {
		return compressionCodec;
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
	 * Gets the max padding size.
	 *
	 * @return the max padding size
	 */
	public int getMaxPaddingSize() {
		return maxPaddingSize;
	}

	/**
	 * Gets the page size.
	 *
	 * @return the page size
	 */
	public int getPageSize() {
		return pageSize;
	}

	/**
	 * Gets the parquet writer.
	 *
	 * @return the parquet writer
	 */
	public ParquetWriter<Group> getParquetWriter() {
		return parquetWriter;
	}

	/**
	 * Gets the row group size.
	 *
	 * @return the row group size
	 */
	public int getRowGroupSize() {
		return rowGroupSize;
	}

	/**
	 * Gets the schema.
	 *
	 * @return the schema
	 */
	public MessageType getSchema() {
		return schema;
	}

	/**
	 * Gets the simple group factory.
	 *
	 * @return the simple group factory
	 */
	public SimpleGroupFactory getSimpleGroupFactory() {
		return simpleGroupFactory;
	}

	/**
	 * Gets the write mode.
	 *
	 * @return the write mode
	 */
	public Mode getWriteMode() {
		return writeMode;
	}

	/**
	 * Gets the writer version.
	 *
	 * @return the writer version
	 */
	public WriterVersion getWriterVersion() {
		return writerVersion;
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
	 * Checks if is delete CRC.
	 *
	 * @return true, if is delete CRC
	 */
	public boolean isDeleteCRC() {
		return deleteCRC;
	}

	/**
	 * Checks if is dictionary encoding.
	 *
	 * @return true, if is dictionary encoding
	 */
	public boolean isDictionaryEncoding() {
		return dictionaryEncoding;
	}

	/**
	 * Checks if is validation.
	 *
	 * @return true, if is validation
	 */
	public boolean isValidation() {
		return validation;
	}

	/**
	 * Sets the append data.
	 *
	 * @param appendData the new append data
	 */
	public void setAppendData(boolean appendData) {
		this.appendData = appendData;
	}

	/**
	 * Sets the compression codec.
	 *
	 * @param compressionCodec the new compression codec
	 */
	public void setCompressionCodec(CompressionCodecName compressionCodec) {
		this.compressionCodec = compressionCodec;
	}

	/**
	 * Sets the compression codec.
	 *
	 * @param compressionCodec the new compression codec
	 */
	public void setCompressionCodec(String compressionCodec) {
		this.compressionCodec = CompressionCodecName.valueOf(compressionCodec);
	}

	/**
	 * Sets the delete CRC.
	 *
	 * @param deleteCRC the new delete CRC
	 */
	public void setDeleteCRC(boolean deleteCRC) {
		this.deleteCRC = deleteCRC;
	}

	/**
	 * Sets the dictionary encoding.
	 *
	 * @param dictionaryEncoding the new dictionary encoding
	 */
	public void setDictionaryEncoding(boolean dictionaryEncoding) {
		this.dictionaryEncoding = dictionaryEncoding;
	}

	/**
	 * Sets the extra meta data.
	 *
	 * @param key   the key
	 * @param value the value
	 */
	public void setExtraMetaData(String[] key, String[] value) {
		this.extraMetaData = new HashMap<>();

		for (int i = 0; i < key.length; i++) {
			this.extraMetaData.put(key[i], value[i]);
		}
	}

	/**
	 * Sets the file name.
	 *
	 * @param file the new file name
	 */
	public void setFileName(String file) {
		this.fileName = file;
	}

	/**
	 * Sets the max padding size.
	 *
	 * @param maxPaddingSize the new max padding size
	 */
	public void setMaxPaddingSize(int maxPaddingSize) {
		this.maxPaddingSize = maxPaddingSize;
	}

	/**
	 * Sets the page size.
	 *
	 * @param pageSize the new page size
	 */
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	/**
	 * Sets the row group size.
	 *
	 * @param rowGroupSize the new row group size
	 */
	public void setRowGroupSize(int rowGroupSize) {
		this.rowGroupSize = rowGroupSize;
	}

	/**
	 * Sets the schema.
	 *
	 * @param schema the new schema
	 */
	public void setSchema(MessageType schema) {
		this.schema = schema;
	}

	/**
	 * Sets the schema.
	 *
	 * @param schema the new schema
	 */
	public void setSchema(String schema) {
		this.schema = MessageTypeParser.parseMessageType(schema);
	}

	/**
	 * Sets the validation.
	 *
	 * @param validation the new validation
	 */
	public void setValidation(boolean validation) {
		this.validation = validation;
	}

	/**
	 * Sets the write mode.
	 *
	 * @param writeMode the new write mode
	 */
	public void setWriteMode(Mode writeMode) {
		this.writeMode = writeMode;
	}

	/**
	 * Sets the write mode.
	 *
	 * @param writeMode the new write mode
	 */
	public void setWriteMode(String writeMode) {
		this.writeMode = Mode.valueOf(writeMode);
	}

	/**
	 * Sets the writer version.
	 *
	 * @param writerVersion the new writer version
	 */
	public void setWriterVersion(String writerVersion) {
		this.writerVersion = WriterVersion.valueOf(writerVersion);
	}

	/**
	 * Sets the writer version.
	 *
	 * @param writerVersion the new writer version
	 */
	public void setWriterVersion(WriterVersion writerVersion) {
		this.writerVersion = writerVersion;
	}

	/**
	 * Write data.
	 *
	 * @param fieldName the field name
	 * @param data      the data
	 * @param numRows   the num rows
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public void writeData(String[] fieldName, Object[] data, int numRows) throws IOException {

		// Initialize the file writer
		if (writeDataCalls == 0)
			createFileWriter();

		List<PrimitiveTypeName> primitiveType = new ArrayList<>();
		List<OriginalType> originalType = new ArrayList<>();
		String[] fa = new String[1];

		// Loop through fields to get the native and logical types
		for (String field : fieldName) {
			// This for the moment assumes the path to the column is a simple non-nested and
			// in the same file we are writing to.
			fa[0] = field;

			// The primitive type
			primitiveType.add(schema.getColumnDescription(fa).getType());

			// The original/logical type
			originalType.add(schema.getType(fa).getOriginalType());
		}

		// Group for adding column values to the row
		Group group = null;

		for (int j = 0; j < numRows; j++) {
			// For each row create a new Group
			int i = 0;
			group = simpleGroupFactory.newGroup();

			for (String field : fieldName) {
				switch (primitiveType.get(i)) {
				case BOOLEAN:
					if (numRows < 2) {
						group.add(field, ((boolean) data[i]));
					} else {
						group.add(field, ((boolean[]) data[i])[j]);
					}
					break;
				case INT32:
					if (numRows < 2) {
						group.add(field, ((int) data[i]));
					} else {
						group.add(field, ((int[]) data[i])[j]);
					}
					break;
				case INT64:
					if (numRows < 2) {
						group.add(field, ((long) data[i]));
					} else {
						group.add(field, ((long[]) data[i])[j]);
					}
					break;
				case INT96:
					break;
				case FLOAT:
					if (numRows < 2) {
						group.add(field, ((float) data[i]));
					} else {
						group.add(field, ((float[]) data[i])[j]);
					}
					break;
				case DOUBLE:
					if (numRows < 2) {
						group.add(field, ((double) data[i]));
					} else {
						group.add(field, ((double[]) data[i])[j]);
					}
					break;
				case FIXED_LEN_BYTE_ARRAY:
				case BINARY:
					// If original-logical is UTF8 add as String
					if (originalType.get(i).equals(OriginalType.UTF8))
						group.add(field, ((String[]) data[i])[j]);
					break;
				default:
				}
				i++;
			}
			// Write the row Group
			parquetWriter.write(group);
		}

		writeDataCalls++;
		if (!appendData)
			finish();
	}

}
