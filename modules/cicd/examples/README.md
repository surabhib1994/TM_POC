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

The pipelines are configured to:

1. Run linting and tests on the Python code
2. Build Python packages
3. Deploy the code to Databricks DBFS in the appropriate environment (DEV/QA/PROD)

### Environment-Specific Deployments

The pipelines support deployment to three environments:

- **DEV**: For development and testing
- **QA**: For quality assurance and pre-production validation
- **PROD**: For production deployment

Each environment has its own deployment path in Databricks DBFS:

```
/dbfs/FileStore/python_deployments/<environment>/deployment-<build_id>/
```

### Orchestration Integration

After deployment, the Python code can be executed by an external orchestration system like Airflow. The deployment path is output at the end of each deployment job and can be used by the orchestration system to locate and run the deployed code.

### Performance Optimizations

The pipelines use slimmed-down Docker images (`python:3.9-slim`) to improve performance by reducing image pull times and resource usage. This results in faster pipeline execution and more efficient resource utilization.