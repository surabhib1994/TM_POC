# Azure Provider Variables
variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "databricks-dev-rg"
}

# DataBricks Workspace Variables
variable "databricks_workspace_name" {
  description = "Name of the DataBricks workspace"
  type        = string
  default     = "databricks-dev-workspace"
}

variable "databricks_sku" {
  description = "The SKU of the DataBricks workspace (standard, premium, or trial)"
  type        = string
  default     = "standard"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    Environment = "Development"
    Project     = "Data Platform"
    Owner       = "Data Engineering Team"
  }
}

# Network Variables
variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_address_prefix" {
  description = "Address prefix for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_address_prefix" {
  description = "Address prefix for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "no_public_ip" {
  description = "Specifies whether to deploy the workspace with no public IP"
  type        = bool
  default     = false
}

# DataBricks Permissions Variables
variable "admin_users" {
  description = "List of users to be assigned admin role"
  type        = list(string)
  default     = [
    "admin1@example.com",
    "admin2@example.com"
  ]
}

variable "contributor_users" {
  description = "List of users to be assigned contributor role"
  type        = list(string)
  default     = [
    "contributor1@example.com",
    "contributor2@example.com"
  ]
}

variable "reader_users" {
  description = "List of users to be assigned reader role"
  type        = list(string)
  default     = [
    "reader1@example.com",
    "reader2@example.com"
  ]
}

# Instance Pool Variables
variable "instance_pool_node_type" {
  description = "The node type for the instance pool"
  type        = string
  default     = "Standard_DS3_v2"
}

variable "spark_version" {
  description = "The Spark version to preload on the instance pool"
  type        = string
  default     = "10.4.x-scala2.12"
}

# Orchestrator (Airflow) Variables
variable "orchestrator_name" {
  description = "Name of the Airflow deployment"
  type        = string
  default     = "data-orchestrator-dev"
}

variable "orchestrator_namespace" {
  description = "Kubernetes namespace for Airflow deployment"
  type        = string
  default     = "airflow-dev"
}

variable "kubernetes_config" {
  description = "Kubernetes configuration for Airflow deployment"
  type        = object({
    cluster_name = string
    context      = string
  })
  default     = {
    cluster_name = "aks-dev-cluster"
    context      = "aks-dev-context"
  }
}

variable "airflow_version" {
  description = "Version of Airflow to deploy"
  type        = string
  default     = "2.5.1"
}

variable "airflow_config" {
  description = "Configuration for Airflow deployment"
  type        = map(string)
  default     = {
    "AIRFLOW__CORE__EXECUTOR"                = "KubernetesExecutor"
    "AIRFLOW__CORE__LOAD_EXAMPLES"           = "false"
    "AIRFLOW__WEBSERVER__EXPOSE_CONFIG"      = "true"
    "AIRFLOW__KUBERNETES__NAMESPACE"         = "airflow-dev"
    "AIRFLOW__KUBERNETES__WORKER_CONTAINER_REPOSITORY" = "apache/airflow"
    "AIRFLOW__KUBERNETES__WORKER_CONTAINER_TAG"        = "2.5.1"
  }
}