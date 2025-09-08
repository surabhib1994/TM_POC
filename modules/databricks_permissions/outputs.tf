# Group Outputs
output "admin_group_id" {
  description = "The ID of the admin group"
  value       = databricks_group.admins.id
}

output "contributor_group_id" {
  description = "The ID of the contributor group"
  value       = databricks_group.contributors.id
}

output "reader_group_id" {
  description = "The ID of the reader group"
  value       = databricks_group.readers.id
}

# Cluster Policy Outputs
output "cluster_policy_id" {
  description = "The ID of the cluster policy"
  value       = databricks_cluster_policy.fair_use.id
}

# Instance Pool Outputs
output "instance_pool_id" {
  description = "The ID of the instance pool"
  value       = var.create_instance_pool ? databricks_instance_pool.shared[0].id : var.instance_pool_id
}

output "instance_pool_name" {
  description = "The name of the instance pool"
  value       = var.create_instance_pool ? databricks_instance_pool.shared[0].instance_pool_name : null
}