"""
Utility functions for Databricks ETL processing.
"""

import logging
from datetime import datetime
from pyspark.sql import DataFrame
from pyspark.sql.functions import col, when, lit, current_timestamp

logger = logging.getLogger(__name__)

def validate_dataframe(df: DataFrame, required_columns: list) -> bool:
    """
    Validate that a DataFrame contains all required columns.
    
    Args:
        df: DataFrame to validate
        required_columns: List of column names that must be present
        
    Returns:
        bool: True if all required columns are present, False otherwise
    """
    existing_columns = df.columns
    missing_columns = [col for col in required_columns if col not in existing_columns]
    
    if missing_columns:
        logger.error(f"DataFrame is missing required columns: {missing_columns}")
        return False
    
    return True

def clean_data(df: DataFrame) -> DataFrame:
    """
    Clean data by handling nulls and standardizing formats.
    
    Args:
        df: DataFrame to clean
        
    Returns:
        DataFrame: Cleaned DataFrame
    """
    # Replace nulls with default values for specific columns
    df = df.na.fill("", ["string_cols"])
    df = df.na.fill(0, ["numeric_cols"])
    
    # Handle specific data quality issues
    df = df.withColumn(
        "clean_amount", 
        when(col("amount").isNull(), 0).otherwise(col("amount"))
    )
    
    # Add audit columns
    df = df.withColumn("processed_timestamp", current_timestamp())
    df = df.withColumn("processing_date", lit(datetime.now().strftime("%Y-%m-%d")))
    
    return df

def write_with_audit(df: DataFrame, output_path: str, mode: str = "overwrite") -> None:
    """
    Write DataFrame to output path with audit information.
    
    Args:
        df: DataFrame to write
        output_path: Path to write the DataFrame
        mode: Write mode (overwrite, append, etc.)
    """
    # Add audit columns if they don't exist
    if "processed_timestamp" not in df.columns:
        df = df.withColumn("processed_timestamp", current_timestamp())
    
    # Write the DataFrame
    logger.info(f"Writing {df.count()} rows to {output_path}")
    df.write.format("delta").mode(mode).save(output_path)
    logger.info(f"Successfully wrote data to {output_path}")