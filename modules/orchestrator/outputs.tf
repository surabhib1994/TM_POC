# AKS Cluster Outputs
output "aks_cluster_id" {
  description = "The ID of the AKS cluster"
  value       = var.create_aks_cluster ? azurerm_kubernetes_cluster.airflow[0].id : null
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = var.create_aks_cluster ? azurerm_kubernetes_cluster.airflow[0].name : null
}

output "aks_cluster_fqdn" {
  description = "The FQDN of the AKS cluster"
  value       = var.create_aks_cluster ? azurerm_kubernetes_cluster.airflow[0].fqdn : null
}

# Airflow Outputs
output "airflow_endpoint" {
  description = "The endpoint URL for Airflow UI"
  value       = var.webserver_service_type == "LoadBalancer" ? "http://${data.kubernetes_service.airflow_webserver.status.0.load_balancer.0.ingress.0.ip}:8080" : null
}

output "namespace" {
  description = "The Kubernetes namespace where Airflow is deployed"
  value       = kubernetes_namespace.airflow.metadata[0].name
}

output "storage_account_name" {
  description = "The name of the storage account for Airflow"
  value       = azurerm_storage_account.airflow.name
}

output "storage_account_key" {
  description = "The access key for the storage account"
  value       = azurerm_storage_account.airflow.primary_access_key
  sensitive   = true
}

output "dags_container_name" {
  description = "The name of the storage container for DAGs"
  value       = azurerm_storage_container.dags.name
}

output "logs_container_name" {
  description = "The name of the storage container for logs"
  value       = azurerm_storage_container.logs.name
}

# Data source to get the Airflow webserver service
data "kubernetes_service" "airflow_webserver" {
  metadata {
    name      = "${var.name}-webserver"
    namespace = kubernetes_namespace.airflow.metadata[0].name
  }
  
  depends_on = [
    helm_release.airflow
  ]
}