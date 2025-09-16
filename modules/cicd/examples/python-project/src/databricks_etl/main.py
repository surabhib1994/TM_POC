"""
Main module for Databricks ETL processing.
"""

import argparse
import logging
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, lit, current_timestamp

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def create_spark_session():
    """Create and return a Spark session."""
    return SparkSession.builder.appName("DatabricksETL").getOrCreate()

def transform_data(spark, input_path, output_path, env):
    """
    Transform data from input path and write to output path.
    
    Args:
        spark: SparkSession
        input_path: Path to input data
        output_path: Path to write output data
        env: Environment (dev/prod)
    """
    logger.info(f"Starting data transformation in {env} environment")
    logger.info(f"Reading data from {input_path}")
    
    try:
        # Read input data
        df = spark.read.format("delta").load(input_path)
        
        # Perform transformations
        df = df.withColumn("processed_timestamp", current_timestamp())
        df = df.withColumn("environment", lit(env))
        
        # Apply additional transformations based on business logic
        df = df.withColumn("amount_with_tax", col("amount") * 1.1)
        
        # Write output data
        logger.info(f"Writing transformed data to {output_path}")
        df.write.format("delta").mode("overwrite").save(output_path)
        
        logger.info("Data transformation completed successfully")
        return True
    except Exception as e:
        logger.error(f"Error during data transformation: {str(e)}")
        raise

def main():
    """Main entry point for the ETL job."""
    parser = argparse.ArgumentParser(description="Databricks ETL Job")
    parser.add_argument("--env", required=True, choices=["dev", "prod"], help="Environment (dev/prod)")
    parser.add_argument("--input-path", required=True, help="Path to input data")
    parser.add_argument("--output-path", required=True, help="Path to write output data")
    
    args = parser.parse_args()
    
    logger.info(f"Starting ETL job with arguments: {args}")
    
    spark = create_spark_session()
    success = transform_data(spark, args.input_path, args.output_path, args.env)
    
    if success:
        logger.info("ETL job completed successfully")
    else:
        logger.error("ETL job failed")
        exit(1)

if __name__ == "__main__":
    main()