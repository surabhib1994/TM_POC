# Configure the Databricks provider
provider "databricks" {
  alias = "workspace"
  host  = var.workspace_url
}

# Create admin group if it doesn't exist
resource "databricks_group" "admins" {
  provider     = databricks.workspace
  display_name = var.admin_group_name
}

# Create contributor group if it doesn't exist
resource "databricks_group" "contributors" {
  provider     = databricks.workspace
  display_name = var.contributor_group_name
}

# Create reader group if it doesn't exist
resource "databricks_group" "readers" {
  provider     = databricks.workspace
  display_name = var.reader_group_name
}

# Add users to admin group
resource "databricks_group_member" "admin_users" {
  provider  = databricks.workspace
  for_each  = toset(var.admin_users)
  group_id  = databricks_group.admins.id
  member_id = each.value
}

# Add users to contributor group
resource "databricks_group_member" "contributor_users" {
  provider  = databricks.workspace
  for_each  = toset(var.contributor_users)
  group_id  = databricks_group.contributors.id
  member_id = each.value
}

# Add users to reader group
resource "databricks_group_member" "reader_users" {
  provider  = databricks.workspace
  for_each  = toset(var.reader_users)
  group_id  = databricks_group.readers.id
  member_id = each.value
}

# Set workspace-level permissions for admin group
resource "databricks_permissions" "workspace_admins" {
  provider = databricks.workspace
  workspace_id = var.workspace_id
  
  access_control {
    group_name       = databricks_group.admins.display_name
    permission_level = "ADMIN"
  }
}

# Set workspace-level permissions for contributor group
resource "databricks_permissions" "workspace_contributors" {
  provider = databricks.workspace
  workspace_id = var.workspace_id
  
  access_control {
    group_name       = databricks_group.contributors.display_name
    permission_level = "CAN_MANAGE"
  }
}

# Set workspace-level permissions for reader group
resource "databricks_permissions" "workspace_readers" {
  provider = databricks.workspace
  workspace_id = var.workspace_id
  
  access_control {
    group_name       = databricks_group.readers.display_name
    permission_level = "CAN_READ"
  }
}

# Create cluster policy for different user groups
resource "databricks_cluster_policy" "fair_use" {
  provider = databricks.workspace
  name = "Fair Use Policy"
  
  definition = jsonencode({
    "dbus_per_hour": {
      "type": "range",
      "maxValue": 10
    },
    "autotermination_minutes": {
      "type": "fixed",
      "value": 120
    },
    "instance_pool_id": {
      "type": "unlimited",
      "defaultValue": var.instance_pool_id
    }
  })
}

# Assign cluster policy permissions
resource "databricks_permissions" "cluster_policy_permissions" {
  provider = databricks.workspace
  cluster_policy_id = databricks_cluster_policy.fair_use.id
  
  access_control {
    group_name       = databricks_group.admins.display_name
    permission_level = "CAN_USE"
  }
  
  access_control {
    group_name       = databricks_group.contributors.display_name
    permission_level = "CAN_USE"
  }
}

# Create instance pool if enabled
resource "databricks_instance_pool" "shared" {
  count    = var.create_instance_pool ? 1 : 0
  provider = databricks.workspace
  
  instance_pool_name = "Shared Pool"
  min_idle_instances = 0
  max_capacity       = 10
  
  node_type_id = var.instance_pool_node_type
  
  idle_instance_autotermination_minutes = 10
  
  preloaded_spark_versions = [var.spark_version]
}

# Assign instance pool permissions
resource "databricks_permissions" "instance_pool_permissions" {
  count    = var.create_instance_pool ? 1 : 0
  provider = databricks.workspace
  
  instance_pool_id = databricks_instance_pool.shared[0].id
  
  access_control {
    group_name       = databricks_group.admins.display_name
    permission_level = "CAN_MANAGE"
  }
  
  access_control {
    group_name       = databricks_group.contributors.display_name
    permission_level = "CAN_ATTACH_TO"
  }
}