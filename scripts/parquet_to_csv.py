#!/usr/bin/env python3

import pyarrow.parquet as pq

# Open the Parquet file
parquet_file = pq.ParquetFile("/home1/s.paragkamian/databases/obis_20241202.parquet")

# Open the TSV file for writing
with open("/home1/s.paragkamian/databases/obis_20241202.tsv", "w", encoding="utf-8") as tsv_file:
    # Get column names and write as header
    column_names = parquet_file.schema.names
    tsv_file.write("\t".join(column_names) + "\n")

    # Read and write one row at a time
    for batch in parquet_file.iter_batches(batch_size=1):  # Read one row at a time
        for row in batch.to_pylist():  # Convert batch to a Python list of dictionaries
            tsv_file.write("\t".join(str(row[col]) if row[col] is not None else "" for col in column_names) + "\n")
