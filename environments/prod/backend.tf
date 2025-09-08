terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-backend-rg"
    storage_account_name = "tfstatestore"
    container_name       = "tfstate"
    key                  = "databricks-prod.tfstate"
  }
}