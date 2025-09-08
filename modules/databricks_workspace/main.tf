# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "this" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Get existing resource group if it exists
data "azurerm_resource_group" "existing" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

locals {
  resource_group_id = var.create_resource_group ? azurerm_resource_group.this[0].id : data.azurerm_resource_group.existing[0].id
}

# Create a managed private network for the Databricks workspace
resource "azurerm_virtual_network" "this" {
  count               = var.create_network ? 1 : 0
  name                = "${var.name}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "public" {
  count                = var.create_network ? 1 : 0
  name                 = "${var.name}-public-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[0].name
  address_prefixes     = [var.public_subnet_address_prefix]
  
  delegation {
    name = "databricks-delegation"
    
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
    }
  }
}

resource "azurerm_subnet" "private" {
  count                = var.create_network ? 1 : 0
  name                 = "${var.name}-private-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[0].name
  address_prefixes     = [var.private_subnet_address_prefix]
  
  delegation {
    name = "databricks-delegation"
    
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
    }
  }
}

resource "azurerm_network_security_group" "this" {
  count               = var.create_network ? 1 : 0
  name                = "${var.name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "public" {
  count                     = var.create_network ? 1 : 0
  subnet_id                 = azurerm_subnet.public[0].id
  network_security_group_id = azurerm_network_security_group.this[0].id
}

resource "azurerm_subnet_network_security_group_association" "private" {
  count                     = var.create_network ? 1 : 0
  subnet_id                 = azurerm_subnet.private[0].id
  network_security_group_id = azurerm_network_security_group.this[0].id
}

# Create the Databricks workspace
resource "azurerm_databricks_workspace" "this" {
  name                        = var.name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  sku                         = var.sku
  tags                        = var.tags
  managed_resource_group_name = "${var.name}-managed-rg"
  
  dynamic "custom_parameters" {
    for_each = var.create_network ? [1] : []
    content {
      no_public_ip        = var.no_public_ip
      virtual_network_id  = azurerm_virtual_network.this[0].id
      public_subnet_name  = azurerm_subnet.public[0].name
      private_subnet_name = azurerm_subnet.private[0].name
    }
  }
}