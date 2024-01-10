resource "azurerm_resource_group" "similarity_exp_rg" {
  name     = "SimilarityExperimentRG" # Name of the resource group
  location = "germanywestcentral" # Geographic location for the resources
}

## Workaround for timeout bug when creating storage account
resource "random_string" "storage-suffix" {
  length  = 8
  special = false
}

# Storage Account for Similarity Experiment
resource "azurerm_storage_account" "similarity_exp_storage" {
  name                = "simexpstor${lower(random_string.storage-suffix.result)}" # workaround timeout bug
  resource_group_name      = azurerm_resource_group.similarity_exp_rg.name
  location                 = azurerm_resource_group.similarity_exp_rg.location
  account_tier             = "Standard" # Defines the tier
  account_replication_type = "LRS"
}

# Storage Container within the Storage Account
resource "azurerm_storage_container" "similarity_exp_container" {
  name                  = "simexpcontainer" # Container name
  storage_account_name  = azurerm_storage_account.similarity_exp_storage.name
  container_access_type = "private" # Access type set to private
}

## Password for admin dashboard
resource "random_string" "ambari-password" {
  length  = 12
  special = true
}


# HDInsight Hadoop Cluster Configuration for Similarity Experiment
resource "azurerm_hdinsight_hadoop_cluster" "similarity_exp_hadoop_cluster" {
  name                = "hadoopcluster12312Berlin"
  resource_group_name = azurerm_resource_group.similarity_exp_rg.name
  location            = azurerm_resource_group.similarity_exp_rg.location
  ## Region abhängig
  # cluster_version     = "5.0" # HDI cluster version -> 3.3.4
  cluster_version     = "4.0" # HDI cluster version -> 3.1.0
  # cluster_version     = "3.6"
  tier                = "Standard"
  depends_on = [local_file.ssh_key_pub]

  component_version {
    hadoop = "3.1"
  }

  # Gateway configuration for the cluster
  gateway {
    username = "simexpusergw"
    password = "${random_string.ambari-password.result}" # Replace with a secure password
  }

  # Storage account configuration for the Hadoop cluster
  storage_account {
    storage_container_id = azurerm_storage_container.similarity_exp_container.id
    storage_account_key  = azurerm_storage_account.similarity_exp_storage.primary_access_key
    is_default           = true
  }

  # Configuration for the roles in the Hadoop cluster
  roles {
    # Head node configuration
    head_node {
      vm_size  = "Standard_A4_V2" # VM size for the head node
      username = "simexpuservm"
      ssh_keys = [file("${path.module}/${local_file.ssh_key_pub.filename}")]
    }

    # Worker node configuration
    worker_node {
      vm_size               = "Standard_A2m_V2" # VM size for worker nodes
      username              = "simexpuservm"
      ssh_keys = [file("${path.module}/${local_file.ssh_key_pub.filename}")]
      target_instance_count = 1 # Number of worker nodes
    }

    zookeeper_node {
      vm_size  = "Standard_A1_V2"
      username = "simexpuservm"
      ssh_keys = [file("${path.module}/${local_file.ssh_key_pub.filename}")]
    }
  }
}
