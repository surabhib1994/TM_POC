# Create a resource group for the Airflow deployment
resource "azurerm_resource_group" "airflow" {
  count    = var.create_resource_group ? 1 : 0
  name     = "${var.name}-rg"
  location = var.location
  tags     = var.tags
}

# Get existing resource group if it exists
data "azurerm_resource_group" "existing" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

locals {
  resource_group_name = var.create_resource_group ? azurerm_resource_group.airflow[0].name : var.resource_group_name
  resource_group_id   = var.create_resource_group ? azurerm_resource_group.airflow[0].id : data.azurerm_resource_group.existing[0].id
}

# Create AKS cluster for Airflow if needed
resource "azurerm_kubernetes_cluster" "airflow" {
  count               = var.create_aks_cluster ? 1 : 0
  name                = "${var.name}-aks"
  location            = var.location
  resource_group_name = local.resource_group_name
  dns_prefix          = "${var.name}-aks"
  kubernetes_version  = var.kubernetes_version
  
  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = var.node_size
    os_disk_size_gb     = 50
    enable_auto_scaling = true
    min_count           = var.min_node_count
    max_count           = var.max_node_count
  }
  
  identity {
    type = "SystemAssigned"
  }
  
  tags = var.tags
}

# Configure Kubernetes provider
provider "kubernetes" {
  host                   = var.create_aks_cluster ? azurerm_kubernetes_cluster.airflow[0].kube_config.0.host : var.kubernetes_config.host
  client_certificate     = var.create_aks_cluster ? base64decode(azurerm_kubernetes_cluster.airflow[0].kube_config.0.client_certificate) : var.kubernetes_config.client_certificate
  client_key             = var.create_aks_cluster ? base64decode(azurerm_kubernetes_cluster.airflow[0].kube_config.0.client_key) : var.kubernetes_config.client_key
  cluster_ca_certificate = var.create_aks_cluster ? base64decode(azurerm_kubernetes_cluster.airflow[0].kube_config.0.cluster_ca_certificate) : var.kubernetes_config.cluster_ca_certificate
}

# Configure Helm provider
provider "helm" {
  kubernetes {
    host                   = var.create_aks_cluster ? azurerm_kubernetes_cluster.airflow[0].kube_config.0.host : var.kubernetes_config.host
    client_certificate     = var.create_aks_cluster ? base64decode(azurerm_kubernetes_cluster.airflow[0].kube_config.0.client_certificate) : var.kubernetes_config.client_certificate
    client_key             = var.create_aks_cluster ? base64decode(azurerm_kubernetes_cluster.airflow[0].kube_config.0.client_key) : var.kubernetes_config.client_key
    cluster_ca_certificate = var.create_aks_cluster ? base64decode(azurerm_kubernetes_cluster.airflow[0].kube_config.0.cluster_ca_certificate) : var.kubernetes_config.cluster_ca_certificate
  }
}

# Create namespace for Airflow
resource "kubernetes_namespace" "airflow" {
  metadata {
    name = var.namespace
  }
}

# Create Azure Storage Account for Airflow logs and DAGs
resource "azurerm_storage_account" "airflow" {
  name                     = replace(lower("${var.name}storage"), "-", "")
  resource_group_name      = local.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

# Create container for Airflow DAGs
resource "azurerm_storage_container" "dags" {
  name                  = "dags"
  storage_account_name  = azurerm_storage_account.airflow.name
  container_access_type = "private"
}

# Create container for Airflow logs
resource "azurerm_storage_container" "logs" {
  name                  = "logs"
  storage_account_name  = azurerm_storage_account.airflow.name
  container_access_type = "private"
}

# Create Kubernetes secret for Azure Storage
resource "kubernetes_secret" "azure_storage" {
  metadata {
    name      = "azure-storage"
    namespace = kubernetes_namespace.airflow.metadata[0].name
  }

  data = {
    "azure-storage-account-name" = azurerm_storage_account.airflow.name
    "azure-storage-account-key"  = azurerm_storage_account.airflow.primary_access_key
  }
}

# Deploy Airflow using Helm
resource "helm_release" "airflow" {
  name       = var.name
  repository = "https://airflow.apache.org"
  chart      = "airflow"
  version    = var.airflow_chart_version
  namespace  = kubernetes_namespace.airflow.metadata[0].name
  
  # Wait for the deployment to complete
  wait = true
  
  # Set Airflow configuration values
  values = [
    yamlencode({
      airflow = {
        image = {
          repository = "apache/airflow"
          tag        = var.airflow_version
        }
        
        config = var.airflow_config
        
        executor = "KubernetesExecutor"
        
        # Configure persistence for DAGs and logs
        dags = {
          persistence = {
            enabled = true
            storageClass = "azure-file"
            size = "1Gi"
          }
          gitSync = {
            enabled = var.git_sync_enabled
            repo = var.git_sync_repo
            branch = var.git_sync_branch
            rev = var.git_sync_rev
            depth = 1
            maxFailures = 0
            subPath = "dags"
          }
        }
        
        logs = {
          persistence = {
            enabled = true
            storageClass = "azure-file"
            size = "5Gi"
          }
        }
        
        # Configure Airflow web server
        webserver = {
          service = {
            type = var.webserver_service_type
          }
          
          resources = {
            limits = {
              cpu = "1000m"
              memory = "1Gi"
            }
            requests = {
              cpu = "500m"
              memory = "500Mi"
            }
          }
        }
        
        # Configure Airflow scheduler
        scheduler = {
          resources = {
            limits = {
              cpu = "1000m"
              memory = "1Gi"
            }
            requests = {
              cpu = "500m"
              memory = "500Mi"
            }
          }
        }
        
        # Configure Airflow worker
        workers = {
          resources = {
            limits = {
              cpu = "1000m"
              memory = "2Gi"
            }
            requests = {
              cpu = "500m"
              memory = "1Gi"
            }
          }
        }
        
        # Configure Airflow database
        postgresql = {
          enabled = true
        }
        
        # Configure Airflow Redis
        redis = {
          enabled = true
        }
      }
    })
  ]
  
  # Set timeout for deployment
  timeout = 900
  
  depends_on = [
    kubernetes_namespace.airflow,
    kubernetes_secret.azure_storage
  ]
}

# Create Azure Storage File Share for Airflow
resource "azurerm_storage_share" "airflow" {
  name                 = "airflow"
  storage_account_name = azurerm_storage_account.airflow.name
  quota                = 50
}

# Create Kubernetes Storage Class for Azure Files
resource "kubernetes_storage_class" "azure_file" {
  metadata {
    name = "azure-file"
  }
  
  storage_provisioner = "kubernetes.io/azure-file"
  reclaim_policy      = "Retain"
  
  parameters = {
    skuName = "Standard_LRS"
  }
  
  mount_options = ["dir_mode=0777", "file_mode=0777", "uid=50000", "gid=50000"]
}