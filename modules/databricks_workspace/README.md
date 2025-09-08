# Azure DataBricks Workspace Terraform Module

This module provisions an Azure DataBricks workspace with optional networking components.

## Features

- Creates an Azure DataBricks workspace
- Optionally creates a resource group
- Optionally creates a virtual network with public and private subnets
- Configures network security groups
- Supports both standard and premium SKUs

## Usage

```hcl
module "databricks_workspace" {
  source = "./modules/databricks_workspace"

  name                = "my-databricks-workspace"
  resource_group_name = "my-resource-group"
  location            = "eastus"
  sku                 = "premium"
  
  # Optional: Create a new resource group
  create_resource_group = true
  
  # Optional: Network configuration
  create_network               = true
  vnet_address_space           = "10.0.0.0/16"
  public_subnet_address_prefix = "10.0.1.0/24"
  private_subnet_address_prefix = "10.0.2.0/24"
  no_public_ip                 = false
  
  tags = {
    Environment = "Development"
    Project     = "Data Platform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the DataBricks workspace | `string` | n/a | yes |
| location | Azure region where resources will be created | `string` | n/a | yes |
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |
| create_resource_group | Whether to create a new resource group or use an existing one | `bool` | `false` | no |
| create_network | Whether to create a new network or use an existing one | `bool` | `true` | no |
| vnet_address_space | Address space for the virtual network | `string` | `"10.0.0.0/16"` | no |
| public_subnet_address_prefix | Address prefix for the public subnet | `string` | `"10.0.1.0/24"` | no |
| private_subnet_address_prefix | Address prefix for the private subnet | `string` | `"10.0.2.0/24"` | no |
| no_public_ip | Specifies whether to deploy the workspace with no public IP | `bool` | `false` | no |
| sku | The SKU of the DataBricks workspace (standard, premium, or trial) | `string` | `"standard"` | no |

## Outputs

| Name | Description |
|------|-------------|
| workspace_id | The ID of the DataBricks workspace |
| workspace_url | The URL of the DataBricks workspace |
| workspace_name | The name of the DataBricks workspace |
| managed_resource_group_id | The ID of the managed resource group |
| virtual_network_id | The ID of the virtual network (if created) |
| public_subnet_id | The ID of the public subnet (if created) |
| private_subnet_id | The ID of the private subnet (if created) |
| network_security_group_id | The ID of the network security group (if created) |