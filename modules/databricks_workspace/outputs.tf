# DataBricks Workspace Outputs
output "workspace_id" {
  description = "The ID of the DataBricks workspace"
  value       = azurerm_databricks_workspace.this.id
}

output "workspace_url" {
  description = "The URL of the DataBricks workspace"
  value       = azurerm_databricks_workspace.this.workspace_url
}

output "workspace_name" {
  description = "The name of the DataBricks workspace"
  value       = azurerm_databricks_workspace.this.name
}

output "managed_resource_group_id" {
  description = "The ID of the managed resource group"
  value       = azurerm_databricks_workspace.this.managed_resource_group_id
}

# Network Outputs (if created)
output "virtual_network_id" {
  description = "The ID of the virtual network"
  value       = var.create_network ? azurerm_virtual_network.this[0].id : null
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = var.create_network ? azurerm_subnet.public[0].id : null
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = var.create_network ? azurerm_subnet.private[0].id : null
}

output "network_security_group_id" {
  description = "The ID of the network security group"
  value       = var.create_network ? azurerm_network_security_group.this[0].id : null
}