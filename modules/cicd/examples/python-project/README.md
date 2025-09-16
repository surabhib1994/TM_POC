# Databricks ETL Package

This package provides ETL utilities for processing data in Databricks.

## Features

- Data transformation utilities for Databricks
- PySpark-based data processing
- Command-line interface for running ETL jobs
- Comprehensive test suite

## Installation

```bash
# Install from source
pip install -e .

# Install with development dependencies
pip install -e ".[dev]"
```

## Usage

### Command Line

```bash
# Run the ETL job
databricks-etl --env dev --input-path /path/to/input --output-path /path/to/output
```

### Python API

```python
from databricks_etl.main import transform_data
from pyspark.sql import SparkSession

# Create a Spark session
spark = SparkSession.builder.appName("MyETLJob").getOrCreate()

# Transform data
transform_data(spark, "/path/to/input", "/path/to/output", "dev")
```

## Development

### Setup Development Environment

```bash
# Clone the repository
git clone https://github.com/yourusername/databricks-etl.git
cd databricks-etl

# Create a virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install development dependencies
pip install -e ".[dev]"
```

### Running Tests

```bash
# Run all tests
pytest

# Run tests with coverage
pytest --cov=src tests/

# Generate coverage report
pytest --cov=src tests/ --cov-report=html
```

### Code Quality

```bash
# Run linting
flake8 src/ tests/

# Format code
black src/ tests/
isort src/ tests/
```

## Deployment

This package is designed to be deployed to Databricks using the CI/CD pipelines provided in the parent repository.

### Databricks Job Configuration

The package can be deployed as a job in Databricks. See the example job configurations in the parent repository:

- `databricks-job-dev.json.example`
- `databricks-job-prod.json.example`

## License

MIT