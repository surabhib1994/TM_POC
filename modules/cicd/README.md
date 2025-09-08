# CI/CD Pipeline for Terraform Deployment

This module provides CI/CD pipeline configurations for automating the deployment of DataBricks and Airflow resources using Terraform. It includes pipeline definitions for both Azure DevOps and GitHub Actions.

## Features

- Automated validation and deployment of Terraform configurations
- Environment-specific deployments (dev, prod)
- Secure handling of credentials and state
- Pull request validation and feedback

## Azure DevOps Pipeline

The Azure DevOps pipeline (`azure-pipelines.yml`) provides a complete CI/CD workflow with the following stages:

1. **Validate**: Initializes Terraform, validates the configuration, and creates a plan
2. **Deploy**: Applies the Terraform plan to create or update resources

### Setup Instructions

1. Create an Azure DevOps project and repository
2. Push your Terraform code to the repository
3. Create a service connection to Azure in Project Settings > Service Connections
4. Create a pipeline using the existing YAML file:
   - Go to Pipelines > New Pipeline
   - Select your repository
   - Choose "Existing Azure Pipelines YAML file"
   - Select the path to `azure-pipelines.yml`
   - Save and run the pipeline

### Required Variables

Configure the following variables in your pipeline:

- `azureServiceConnection`: Name of the Azure service connection
- `terraformBackendResourceGroup`: Resource group for Terraform state storage
- `terraformBackendStorageAccount`: Storage account for Terraform state
- `terraformBackendContainer`: Storage container for Terraform state
- `terraformBackendKey`: Key for the Terraform state file

## GitHub Actions Workflow

The GitHub Actions workflow (`github-workflow.yml`) provides a similar CI/CD pipeline with:

1. **Validate**: Checks format, initializes Terraform, validates the configuration, and creates a plan
2. **Deploy**: Applies the Terraform plan to create or update resources

### Setup Instructions

1. Create a GitHub repository
2. Push your Terraform code to the repository
3. Set up the required secrets in your repository:
   - Go to Settings > Secrets and variables > Actions
   - Add the following secrets:
     - `AZURE_CLIENT_ID`: Azure service principal client ID
     - `AZURE_CLIENT_SECRET`: Azure service principal client secret
     - `AZURE_SUBSCRIPTION_ID`: Azure subscription ID
     - `AZURE_TENANT_ID`: Azure tenant ID
4. Place the workflow file in `.github/workflows/terraform.yml`

### Required Secrets

Configure the following secrets in your GitHub repository:

- `AZURE_CLIENT_ID`: Azure service principal client ID
- `AZURE_CLIENT_SECRET`: Azure service principal client secret
- `AZURE_SUBSCRIPTION_ID`: Azure subscription ID
- `AZURE_TENANT_ID`: Azure tenant ID

## Backend Configuration

Both pipelines require a Terraform backend for state storage. Create the following Azure resources:

1. Resource Group:
   ```bash
   az group create --name terraform-backend-rg --location eastus
   ```

2. Storage Account:
   ```bash
   az storage account create --name tfstate$RANDOM --resource-group terraform-backend-rg --sku Standard_LRS
   ```

3. Storage Container:
   ```bash
   az storage container create --name tfstate --account-name <storage-account-name>
   ```

## Environment Configuration

Create environment-specific Terraform configurations in the `environments` directory:

- `environments/dev/`: Development environment configuration
- `environments/prod/`: Production environment configuration

Each environment directory should contain:

- `main.tf`: Main configuration file that calls the modules
- `variables.tf`: Environment-specific variable definitions
- `terraform.tfvars`: Environment-specific variable values
- `backend.tf`: Backend configuration for state storage