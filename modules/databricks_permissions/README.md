# Azure DataBricks Permissions Terraform Module

This module configures permissions and access control for an Azure DataBricks workspace.

## Features

- Creates admin, contributor, and reader groups
- Assigns users to appropriate groups
- Sets workspace-level permissions for each group
- Creates a cluster policy with fair use settings
- Optionally creates an instance pool with appropriate permissions

## Usage

```hcl
module "databricks_permissions" {
  source = "./modules/databricks_permissions"
  
  # Required variables
  workspace_id  = module.databricks_workspace.workspace_id
  workspace_url = module.databricks_workspace.workspace_url
  
  # User assignments
  admin_users = [
    "admin1@example.com",
    "admin2@example.com"
  ]
  
  contributor_users = [
    "contributor1@example.com",
    "contributor2@example.com"
  ]
  
  reader_users = [
    "reader1@example.com",
    "reader2@example.com"
  ]
  
  # Optional: Instance pool configuration
  create_instance_pool    = true
  instance_pool_node_type = "Standard_DS3_v2"
  spark_version           = "10.4.x-scala2.12"
  
  # Ensure this module runs after the workspace is created
  depends_on = [module.databricks_workspace]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| workspace_id | The ID of the DataBricks workspace | `string` | n/a | yes |
| workspace_url | The URL of the DataBricks workspace | `string` | n/a | yes |
| admin_group_name | Name of the admin group | `string` | `"admins"` | no |
| contributor_group_name | Name of the contributor group | `string` | `"contributors"` | no |
| reader_group_name | Name of the reader group | `string` | `"readers"` | no |
| admin_users | List of users to be assigned admin role | `list(string)` | `[]` | no |
| contributor_users | List of users to be assigned contributor role | `list(string)` | `[]` | no |
| reader_users | List of users to be assigned reader role | `list(string)` | `[]` | no |
| create_instance_pool | Whether to create an instance pool | `bool` | `true` | no |
| instance_pool_node_type | The node type for the instance pool | `string` | `"Standard_DS3_v2"` | no |
| instance_pool_id | The ID of an existing instance pool to use | `string` | `""` | no |
| spark_version | The Spark version to preload on the instance pool | `string` | `"10.4.x-scala2.12"` | no |
| create_secret_scope | Whether to create a secret scope | `bool` | `false` | no |
| secret_scope_name | Name of the secret scope | `string` | `"terraform-managed"` | no |
| create_service_principal | Whether to create a service principal | `bool` | `false` | no |
| service_principal_name | Name of the service principal | `string` | `"terraform-sp"` | no |

## Outputs

| Name | Description |
|------|-------------|
| admin_group_id | The ID of the admin group |
| contributor_group_id | The ID of the contributor group |
| reader_group_id | The ID of the reader group |
| cluster_policy_id | The ID of the cluster policy |
| instance_pool_id | The ID of the instance pool |
| instance_pool_name | The name of the instance pool |

## Notes

- This module requires the DataBricks workspace to be created first
- Users must exist in the Azure AD tenant or DataBricks workspace before they can be assigned to groups
- The DataBricks provider must be configured with appropriate credentials