# Workspace Variables
variable "workspace_id" {
  description = "The ID of the DataBricks workspace"
  type        = string
}

variable "workspace_url" {
  description = "The URL of the DataBricks workspace"
  type        = string
}

# Group Names
variable "admin_group_name" {
  description = "Name of the admin group"
  type        = string
  default     = "admins"
}

variable "contributor_group_name" {
  description = "Name of the contributor group"
  type        = string
  default     = "contributors"
}

variable "reader_group_name" {
  description = "Name of the reader group"
  type        = string
  default     = "readers"
}

# User Lists
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

# Instance Pool Variables
variable "create_instance_pool" {
  description = "Whether to create an instance pool"
  type        = bool
  default     = true
}

variable "instance_pool_node_type" {
  description = "The node type for the instance pool"
  type        = string
  default     = "Standard_DS3_v2"
}

variable "instance_pool_id" {
  description = "The ID of an existing instance pool to use"
  type        = string
  default     = ""
}

variable "spark_version" {
  description = "The Spark version to preload on the instance pool"
  type        = string
  default     = "10.4.x-scala2.12"
}

# Secret Scope Variables
variable "create_secret_scope" {
  description = "Whether to create a secret scope"
  type        = bool
  default     = false
}

variable "secret_scope_name" {
  description = "Name of the secret scope"
  type        = string
  default     = "terraform-managed"
}

# Token Variables
variable "create_service_principal" {
  description = "Whether to create a service principal"
  type        = bool
  default     = false
}

variable "service_principal_name" {
  description = "Name of the service principal"
  type        = string
  default     = "terraform-sp"
}