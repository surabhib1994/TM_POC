# Airflow Orchestrator Terraform Module

This module provisions and configures an Apache Airflow deployment on Azure Kubernetes Service (AKS) for workflow orchestration.

## Features

- Deploys Apache Airflow on AKS using Helm
- Optionally creates a new AKS cluster or uses an existing one
- Configures Azure Storage for DAGs and logs persistence
- Supports Git sync for DAGs
- Configurable Airflow settings
- Optional DataBricks integration

## Usage

```hcl
module "orchestrator" {
  source = "./modules/orchestrator"
  
  # General configuration
  name      = "data-orchestrator"
  location  = "eastus"
  namespace = "airflow"
  
  # Resource group configuration
  create_resource_group = true
  resource_group_name   = "airflow-rg"
  
  # AKS configuration
  create_aks_cluster  = true
  kubernetes_version  = "1.25.5"
  node_count          = 3
  min_node_count      = 1
  max_node_count      = 5
  node_size           = "Standard_DS2_v2"
  
  # Airflow configuration
  airflow_version      = "2.5.1"
  airflow_chart_version = "1.7.0"
  webserver_service_type = "LoadBalancer"
  
  # Git sync configuration
  git_sync_enabled = true
  git_sync_repo    = "https://github.com/example/airflow-dags.git"
  git_sync_branch  = "main"
  
  # DataBricks integration
  databricks_integration_enabled = true
  databricks_workspace_url       = module.databricks_workspace.workspace_url
  databricks_token               = var.databricks_token
  
  # Tags
  tags = {
    Environment = "Development"
    Project     = "Data Platform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the Airflow deployment | `string` | n/a | yes |
| location | Azure region where resources will be created | `string` | `"eastus"` | no |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |
| namespace | Kubernetes namespace for Airflow deployment | `string` | `"airflow"` | no |
| create_resource_group | Whether to create a new resource group or use an existing one | `bool` | `false` | no |
| resource_group_name | Name of the existing resource group (if create_resource_group is false) | `string` | `""` | no |
| create_aks_cluster | Whether to create a new AKS cluster or use an existing one | `bool` | `false` | no |
| kubernetes_version | Kubernetes version for the AKS cluster | `string` | `"1.25.5"` | no |
| node_count | Initial number of nodes in the AKS cluster | `number` | `3` | no |
| min_node_count | Minimum number of nodes in the AKS cluster | `number` | `1` | no |
| max_node_count | Maximum number of nodes in the AKS cluster | `number` | `5` | no |
| node_size | VM size for the AKS nodes | `string` | `"Standard_DS2_v2"` | no |
| kubernetes_config | Kubernetes configuration for existing cluster | `object` | `{}` | no |
| airflow_version | Version of Airflow to deploy | `string` | `"2.5.1"` | no |
| airflow_chart_version | Version of the Airflow Helm chart | `string` | `"1.7.0"` | no |
| airflow_config | Configuration for Airflow deployment | `map(string)` | `{}` | no |
| webserver_service_type | Kubernetes service type for Airflow webserver | `string` | `"LoadBalancer"` | no |
| git_sync_enabled | Whether to enable Git sync for DAGs | `bool` | `false` | no |
| git_sync_repo | Git repository URL for DAGs | `string` | `""` | no |
| git_sync_branch | Git branch for DAGs | `string` | `"main"` | no |
| git_sync_rev | Git revision for DAGs | `string` | `"HEAD"` | no |
| databricks_integration_enabled | Whether to enable DataBricks integration | `bool` | `false` | no |
| databricks_workspace_url | URL of the DataBricks workspace | `string` | `""` | no |
| databricks_token | DataBricks access token | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| aks_cluster_id | The ID of the AKS cluster |
| aks_cluster_name | The name of the AKS cluster |
| aks_cluster_fqdn | The FQDN of the AKS cluster |
| airflow_endpoint | The endpoint URL for Airflow UI |
| namespace | The Kubernetes namespace where Airflow is deployed |
| storage_account_name | The name of the storage account for Airflow |
| storage_account_key | The access key for the storage account |
| dags_container_name | The name of the storage container for DAGs |
| logs_container_name | The name of the storage container for logs |

## Notes

- This module requires the Azure Kubernetes Service (AKS) to be available in your subscription
- If using an existing AKS cluster, ensure it has the necessary permissions to create resources
- The Airflow UI is exposed via a LoadBalancer service by default, which creates a public IP
- For production deployments, consider using an Ingress controller with TLS
- DataBricks integration requires a valid DataBricks workspace and access token