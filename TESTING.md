# Testing the Terraform Configuration

This document provides instructions for testing the Terraform configuration before deploying it to Azure.

## Prerequisites

- Terraform >= 1.0.0
- Azure CLI installed and configured
- Bash shell (for running the test script)

## Automated Testing

We provide a test script that validates the Terraform configuration for both development and production environments:

```bash
# Make the script executable
chmod +x test_configuration.sh

# Run the test script
./test_configuration.sh
```

The script performs the following checks:

1. Initializes Terraform in each environment directory
2. Validates the Terraform configuration syntax
3. Runs a plan operation to check for potential issues

## Manual Testing

### 1. Validate Individual Modules

You can validate each module individually:

```bash
cd modules/databricks_workspace
terraform init
terraform validate
```

Repeat for each module:
- `modules/databricks_permissions`
- `modules/orchestrator`
- `modules/cicd`

### 2. Test Development Environment

```bash
cd environments/dev
terraform init -backend=false
terraform validate
terraform plan -var-file=terraform.tfvars
```

### 3. Test Production Environment

```bash
cd environments/prod
terraform init -backend=false
terraform validate
terraform plan -var-file=terraform.tfvars
```

## What to Look For

During testing, pay attention to the following:

1. **Syntax Errors**: Ensure there are no syntax errors in the Terraform configuration.
2. **Resource Creation**: Check that the plan shows the expected resources being created.
3. **Dependencies**: Verify that resources are created in the correct order.
4. **Variable Values**: Confirm that variables are correctly passed to modules.
5. **Output Values**: Ensure that outputs are correctly defined and accessible.

## Common Issues and Solutions

### Authentication Errors

If you encounter authentication errors:

```
Error: Error building AzureRM Client: obtain subscription() from Azure CLI: Error parsing json result from the Azure CLI: Error waiting for the Azure CLI: exit status 1
```

Solution:
```bash
az login
az account set --subscription "<subscription-id>"
```

### Provider Version Conflicts

If you see provider version conflicts:

```
Error: Failed to query available provider packages
```

Solution:
```bash
terraform init -upgrade
```

### Backend Configuration Errors

If you encounter backend configuration errors:

```
Error: Backend configuration changed
```

Solution:
```bash
terraform init -reconfigure
```

## Integration Testing

For full integration testing with Azure resources:

1. Create a separate test subscription or resource group
2. Modify the `terraform.tfvars` file to use test resource names
3. Run a complete deployment:

```bash
terraform init
terraform apply -var-file=terraform.tfvars
```

4. Verify that all resources are created correctly
5. Clean up the test resources:

```bash
terraform destroy -var-file=terraform.tfvars
```

## CI/CD Pipeline Testing

The CI/CD pipeline configurations can be tested using:

- Azure DevOps: Use the pipeline validation feature
- GitHub Actions: Use the workflow validation feature

## Security Testing

Consider running security scans on your Terraform code:

- [tfsec](https://github.com/aquasecurity/tfsec)
- [checkov](https://github.com/bridgecrewio/checkov)
- [terrascan](https://github.com/accurics/terrascan)

Example:
```bash
tfsec .