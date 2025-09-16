"""
Tests for utility functions.
"""

import pytest
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, IntegerType
import datetime

from databricks_etl.utils import validate_dataframe, clean_data, write_with_audit

@pytest.fixture
def spark():
    """Create a Spark session for testing."""
    return SparkSession.builder.appName("test").master("local[1]").getOrCreate()

@pytest.fixture
def sample_dataframe(spark):
    """Create a sample DataFrame for testing."""
    schema = StructType([
        StructField("id", IntegerType(), True),
        StructField("name", StringType(), True),
        StructField("amount", IntegerType(), True),
        StructField("string_cols", StringType(), True),
        StructField("numeric_cols", IntegerType(), True)
    ])
    
    data = [
        (1, "John", 100, "value1", 10),
        (2, "Jane", None, None, None),
        (3, "Bob", 300, "value3", 30)
    ]
    
    return spark.createDataFrame(data, schema)

def test_validate_dataframe(sample_dataframe):
    """Test validate_dataframe function."""
    # Test with all columns present
    assert validate_dataframe(sample_dataframe, ["id", "name", "amount"]) == True
    
    # Test with missing columns
    assert validate_dataframe(sample_dataframe, ["id", "name", "missing_column"]) == False

def test_clean_data(sample_dataframe):
    """Test clean_data function."""
    cleaned_df = clean_data(sample_dataframe)
    
    # Check that nulls were replaced
    assert cleaned_df.filter("string_cols IS NULL").count() == 0
    assert cleaned_df.filter("numeric_cols IS NULL").count() == 0
    
    # Check that amount was cleaned
    assert cleaned_df.filter("clean_amount IS NULL").count() == 0
    
    # Check that audit columns were added
    assert "processed_timestamp" in cleaned_df.columns
    assert "processing_date" in cleaned_df.columns
    
    # Check specific values
    row_with_null = cleaned_df.filter("id = 2").collect()[0]
    assert row_with_null["string_cols"] == ""
    assert row_with_null["numeric_cols"] == 0
    assert row_with_null["clean_amount"] == 0

def test_write_with_audit(spark, sample_dataframe, tmp_path):
    """Test write_with_audit function."""
    # Convert pytest tmp_path to string
    output_path = str(tmp_path)
    
    # Call the function
    write_with_audit(sample_dataframe, output_path)
    
    # Read the data back
    written_df = spark.read.format("delta").load(output_path)
    
    # Check that the data was written correctly
    assert written_df.count() == sample_dataframe.count()
    assert "processed_timestamp" in written_df.columns