# CI/CD Pipeline Examples

This directory contains examples demonstrating how to use the CI/CD pipelines provided in this module.

## Python Project Example

The `python-project` directory contains a sample Python project structured for deployment to Databricks using the Python CI/CD pipelines.

### Project Structure

```
python-project/
├── README.md                 # Project documentation
├── requirements.txt          # Core dependencies
├── requirements-dev.txt      # Development dependencies
├── setup.py                  # Package configuration
├── src/                      # Source code
│   └── databricks_etl/       # Python package
│       ├── __init__.py       # Package initialization
│       ├── main.py           # Main entry point
│       └── utils.py          # Utility functions
└── tests/                    # Test code
    └── test_utils.py         # Tests for utility functions
```

### How to Use

1. Use this project as a template for your own Python code
2. Modify the source code to implement your specific ETL logic
3. Update the package information in `setup.py`
4. Configure the CI/CD pipelines to deploy your code to Databricks

### Integration with CI/CD Pipelines

This example is designed to work with the Python CI/CD pipelines provided in this module:

- `python-workflow.yml`: GitHub Actions workflow for Python deployment
- `python-azure-pipelines.yml`: Azure DevOps pipeline for Python deployment

### Databricks Job Configuration

The parent directory contains example Databricks job configurations:

- `databricks-job-dev.json.example`: Example job configuration for development environment
- `databricks-job-prod.json.example`: Example job configuration for production environment

These job configurations can be used to run the deployed Python code in Databricks.