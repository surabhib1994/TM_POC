terraform {
  required_version = ">= 1.0.0"

  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.6.0"
    }
    
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.30.0"
    }
    
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16.0"
    }
    
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.8.0"
    }
    
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.0"
    }
  }
}