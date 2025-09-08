# Provider configuration
provider "azurerm" {
  features {}
}

provider "azuread" {
}

provider "databricks" {
  azure_workspace_resource_id = module.databricks_workspace.workspace_id
}

# DataBricks workspace module
module "databricks_workspace" {
  source = "./modules/databricks_workspace"

  # Input variables
  name                = var.databricks_workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.databricks_sku
  tags                = var.tags
}

# DataBricks permissions module
module "databricks_permissions" {
  source = "./modules/databricks_permissions"
  
  # Input variables
  workspace_id        = module.databricks_workspace.workspace_id
  workspace_url       = module.databricks_workspace.workspace_url
  admin_users         = var.admin_users
  contributor_users   = var.contributor_users
  reader_users        = var.reader_users
  
  # Ensure this module runs after the workspace is created
  depends_on = [module.databricks_workspace]
}

# Orchestrator (Airflow) module
module "orchestrator" {
  source = "./modules/orchestrator"
  
  # Input variables
  name                = var.orchestrator_name
  namespace           = var.orchestrator_namespace
  kubernetes_config   = var.kubernetes_config
  airflow_version     = var.airflow_version
  airflow_config      = var.airflow_config
  
  # Ensure this module runs after the workspace is created
  depends_on = [module.databricks_workspace]
}