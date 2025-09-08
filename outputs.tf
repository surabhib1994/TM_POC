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

# Orchestrator (Airflow) Outputs
output "airflow_endpoint" {
  description = "The endpoint URL for Airflow UI"
  value       = module.orchestrator.airflow_endpoint
}

output "airflow_namespace" {
  description = "The Kubernetes namespace where Airflow is deployed"
  value       = module.orchestrator.namespace
}