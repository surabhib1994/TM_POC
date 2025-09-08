# Azure DataBricks and Airflow Terraform Project

This Terraform project automates the provisioning and configuration of a complete data platform on Azure, including:

- Azure DataBricks Workspace
- DataBricks Permissions and Access Control
- Airflow Orchestrator on AKS
- CI/CD Pipeline for Automated Deployment

## Project Structure

```
terraform/
├── environments/         # Environment-specific configurations
│   ├── dev/              # Development environment
│   └── prod/             # Production environment
├── modules/              # Reusable Terraform modules
│   ├── databricks_workspace/    # DataBricks workspace provisioning
│   ├── databricks_permissions/  # DataBricks permissions setup
│   ├── cicd/                    # CI/CD pipeline setup
│   └── orchestrator/            # Airflow orchestrator setup
└── README.md             # Project documentation
```

## Prerequisites

- Terraform >= 1.0.0
- Azure CLI installed and configured
- Azure subscription with appropriate permissions
- Azure DevOps or GitHub account for CI/CD

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd terraform
```

### 2. Configure Azure Authentication

```bash
az login
az account set --subscription "<subscription-id>"
```

### 3. Create a Backend for Terraform State

```bash
# Create resource group
az group create --name terraform-backend-rg --location eastus

# Create storage account
az storage account create --name tfstate$RANDOM --resource-group terraform-backend-rg --sku Standard_LRS

# Create storage container
az storage container create --name tfstate --account-name <storage-account-name>
```

### 4. Configure Environment Variables

Create a `terraform.tfvars` file in the environment directory (e.g., `environments/dev/terraform.tfvars`) with your specific configuration values.

### 5. Deploy the Infrastructure

```bash
# Navigate to the environment directory
cd environments/dev

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan -out=tfplan

# Apply the changes
terraform apply tfplan
```

## Modules

### DataBricks Workspace Module

This module provisions an Azure DataBricks workspace with the following features:

- Creates a DataBricks workspace in Azure
- Configures networking (VNet, subnets, NSGs)
- Supports both standard and premium SKUs
- Configurable resource group creation

Usage:

```hcl
module "databricks_workspace" {
  source = "../../modules/databricks_workspace"

  name                = "my-databricks-workspace"
  resource_group_name = "my-resource-group"
  location            = "eastus"
  sku                 = "premium"
}
```

### DataBricks Permissions Module

This module configures permissions and access control for the DataBricks workspace:

- Creates admin, contributor, and reader groups
- Assigns users to appropriate groups
- Sets workspace-level permissions
- Creates cluster policies and instance pools

Usage:

```hcl
module "databricks_permissions" {
  source = "../../modules/databricks_permissions"
  
  workspace_id        = module.databricks_workspace.workspace_id
  workspace_url       = module.databricks_workspace.workspace_url
  admin_users         = ["admin1@example.com"]
  contributor_users   = ["contributor1@example.com"]
  reader_users        = ["reader1@example.com"]
}
```

### Orchestrator (Airflow) Module

This module provisions and configures an Apache Airflow instance on AKS:

- Deploys Airflow on Azure Kubernetes Service
- Configures Azure Storage for DAGs and logs
- Supports Git sync for DAGs
- Optional DataBricks integration

Usage:

```hcl
module "orchestrator" {
  source = "../../modules/orchestrator"
  
  name                = "data-orchestrator"
  location            = "eastus"
  namespace           = "airflow"
  create_aks_cluster  = true
  kubernetes_version  = "1.25.5"
}
```

### CI/CD Pipeline

This module provides CI/CD pipeline configurations for both Azure DevOps and GitHub Actions:

- Automated validation and deployment
- Environment-specific deployments
- Secure handling of credentials and state

## Environment Configuration

The project includes environment-specific configurations in the `environments` directory:

- `dev/`: Development environment configuration
- `prod/`: Production environment configuration (to be created)

Each environment directory contains:

- `main.tf`: Main configuration file that calls the modules
- `variables.tf`: Environment-specific variable definitions
- `terraform.tfvars`: Environment-specific variable values
- `backend.tf`: Backend configuration for state storage
- `outputs.tf`: Output values from the deployment

## Best Practices

This project follows Terraform best practices:

1. **Modular Structure**: Reusable modules for each component
2. **Environment Separation**: Separate configurations for dev and prod
3. **State Management**: Remote state storage with locking
4. **CI/CD Integration**: Automated testing and deployment
5. **Security**: Secure handling of sensitive data
6. **Documentation**: Comprehensive documentation for each module

## Security Considerations

- Use Azure Key Vault for storing sensitive information
- Implement least privilege access control
- Enable network security features
- Regularly update Terraform providers and modules

## Troubleshooting

### Common Issues

1. **Authentication Errors**:
   - Ensure Azure CLI is authenticated
   - Check service principal permissions

2. **Deployment Failures**:
   - Check resource quotas in your subscription
   - Verify network configurations

3. **State Lock Issues**:
   - Release the state lock if a previous operation was interrupted

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.