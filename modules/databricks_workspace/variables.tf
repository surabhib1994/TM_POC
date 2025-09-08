# General Variables
variable "name" {
  description = "Name of the DataBricks workspace"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Resource Group Variables
variable "create_resource_group" {
  description = "Whether to create a new resource group or use an existing one"
  type        = bool
  default     = false
}

# Network Variables
variable "create_network" {
  description = "Whether to create a new network or use an existing one"
  type        = bool
  default     = true
}

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

# DataBricks Workspace Variables
variable "sku" {
  description = "The SKU of the DataBricks workspace (standard, premium, or trial)"
  type        = string
  default     = "standard"
  
  validation {
    condition     = contains(["standard", "premium", "trial"], var.sku)
    error_message = "The SKU must be one of: standard, premium, or trial."
  }
}