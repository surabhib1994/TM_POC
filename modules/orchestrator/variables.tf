# General Variables
variable "name" {
  description = "Name of the Airflow deployment"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "namespace" {
  description = "Kubernetes namespace for Airflow deployment"
  type        = string
  default     = "airflow"
}

# Resource Group Variables
variable "create_resource_group" {
  description = "Whether to create a new resource group or use an existing one"
  type        = bool
  default     = false
}

variable "resource_group_name" {
  description = "Name of the existing resource group (if create_resource_group is false)"
  type        = string
  default     = ""
}

# AKS Cluster Variables
variable "create_aks_cluster" {
  description = "Whether to create a new AKS cluster or use an existing one"
  type        = bool
  default     = false
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster"
  type        = string
  default     = "1.25.5"
}

variable "node_count" {
  description = "Initial number of nodes in the AKS cluster"
  type        = number
  default     = 3
}

variable "min_node_count" {
  description = "Minimum number of nodes in the AKS cluster"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes in the AKS cluster"
  type        = number
  default     = 5
}

variable "node_size" {
  description = "VM size for the AKS nodes"
  type        = string
  default     = "Standard_DS2_v2"
}

# Kubernetes Configuration (if using existing cluster)
variable "kubernetes_config" {
  description = "Kubernetes configuration for existing cluster"
  type        = object({
    host                   = string
    client_certificate     = string
    client_key             = string
    cluster_ca_certificate = string
  })
  default     = {
    host                   = ""
    client_certificate     = ""
    client_key             = ""
    cluster_ca_certificate = ""
  }
}

# Airflow Variables
variable "airflow_version" {
  description = "Version of Airflow to deploy"
  type        = string
  default     = "2.5.1"
}

variable "airflow_chart_version" {
  description = "Version of the Airflow Helm chart"
  type        = string
  default     = "1.7.0"
}

variable "airflow_config" {
  description = "Configuration for Airflow deployment"
  type        = map(string)
  default     = {}
}

variable "webserver_service_type" {
  description = "Kubernetes service type for Airflow webserver"
  type        = string
  default     = "LoadBalancer"
}

# Git Sync Variables
variable "git_sync_enabled" {
  description = "Whether to enable Git sync for DAGs"
  type        = bool
  default     = false
}

variable "git_sync_repo" {
  description = "Git repository URL for DAGs"
  type        = string
  default     = ""
}

variable "git_sync_branch" {
  description = "Git branch for DAGs"
  type        = string
  default     = "main"
}

variable "git_sync_rev" {
  description = "Git revision for DAGs"
  type        = string
  default     = "HEAD"
}

# DataBricks Integration Variables
variable "databricks_integration_enabled" {
  description = "Whether to enable DataBricks integration"
  type        = bool
  default     = false
}

variable "databricks_workspace_url" {
  description = "URL of the DataBricks workspace"
  type        = string
  default     = ""
}

variable "databricks_token" {
  description = "DataBricks access token"
  type        = string
  default     = ""
  sensitive   = true
}