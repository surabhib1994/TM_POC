# DataBricks Workspace Outputs
output "databricks_workspace_id" {
  description = "The ID of the DataBricks workspace"
  value       = module.databricks_workspace.workspace_id
}

output "databricks_workspace_url" {
  description = "The URL of the DataBricks workspace"
  value       = module.databricks_workspace.workspace_url
}

output "databricks_workspace_name" {
  description = "The name of the DataBricks workspace"
  value       = module.databricks_workspace.workspace_name
}

# DataBricks Permissions Outputs
output "admin_group_id" {
  description = "The ID of the admin group"
  value       = module.databricks_permissions.admin_group_id
}

output "contributor_group_id" {
  description = "The ID of the contributor group"
  value       = module.databricks_permissions.contributor_group_id
}

output "reader_group_id" {
  description = "The ID of the reader group"
  value       = module.databricks_permissions.reader_group_id
}

output "instance_pool_id" {
  description = "The ID of the instance pool"
  value       = module.databricks_permissions.instance_pool_id
}

# Orchestrator (Airflow) Outputs
output "airflow_endpoint" {
  description = "The endpoint URL for Airflow UI"
  value       = module.orchestrator.airflow_endpoint
}

output "airflow_namespace" {
  description = "The Kubernetes namespace where Airflow is deployed"
  value       = module.orchestrator.namespace
}

# Network Outputs
output "virtual_network_id" {
  description = "The ID of the virtual network"
  value       = module.databricks_workspace.virtual_network_id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = module.databricks_workspace.public_subnet_id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = module.databricks_workspace.private_subnet_id
}