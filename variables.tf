# Azure Provider Variables
variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# DataBricks Workspace Variables
variable "databricks_workspace_name" {
  description = "Name of the DataBricks workspace"
  type        = string
}

variable "databricks_sku" {
  description = "The SKU of the DataBricks workspace (standard, premium, or trial)"
  type        = string
  default     = "standard"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# DataBricks Permissions Variables
variable "admin_users" {
  description = "List of users to be assigned admin role"
  type        = list(string)
  default     = []
}

variable "contributor_users" {
  description = "List of users to be assigned contributor role"
  type        = list(string)
  default     = []
}

variable "reader_users" {
  description = "List of users to be assigned reader role"
  type        = list(string)
  default     = []
}

# Orchestrator (Airflow) Variables
variable "orchestrator_name" {
  description = "Name of the Airflow deployment"
  type        = string
  default     = "data-orchestrator"
}

variable "orchestrator_namespace" {
  description = "Kubernetes namespace for Airflow deployment"
  type        = string
  default     = "airflow"
}

variable "kubernetes_config" {
  description = "Kubernetes configuration for Airflow deployment"
  type        = object({
    cluster_name = string
    context      = string
  })
}

variable "airflow_version" {
  description = "Version of Airflow to deploy"
  type        = string
  default     = "2.5.1"
}

variable "airflow_config" {
  description = "Configuration for Airflow deployment"
  type        = map(string)
  default     = {}
}