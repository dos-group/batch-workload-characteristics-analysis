output "hdinsight_cluster_details" {
  value = {
    # Values for accessing admin portal
    ambari_endpoint  = "https://${azurerm_hdinsight_hadoop_cluster.similarity_exp_hadoop_cluster.name}.azurehdinsight.net"
    ambari_user     = azurerm_hdinsight_hadoop_cluster.similarity_exp_hadoop_cluster.gateway[0].username
    ambari_password = azurerm_hdinsight_hadoop_cluster.similarity_exp_hadoop_cluster.gateway[0].password
  }
  sensitive = true
}

resource "null_resource" "output_variables" {
  triggers = {
    always_run = "${timestamp()}"
  }

  # create a docker context for the cluster
  provisioner "local-exec" {
    command = <<EOT
    chmod 600 ssh_key.pem
    ln -sf ${path.module}/ssh_key.pem ~/.ssh/id_rsa
    if docker context inspect cluster >/dev/null 2>&1; then
      docker context rm cluster
    fi
    docker context create cluster --docker host=ssh://${azurerm_hdinsight_hadoop_cluster.similarity_exp_hadoop_cluster.roles[0].head_node[0].username}@${azurerm_hdinsight_hadoop_cluster.similarity_exp_hadoop_cluster.ssh_endpoint}
    EOT
  }

  # create enviromental variables
  provisioner "local-exec" {
    command = <<EOT
    echo "" > my_env_vars.sh

    # ssh variables
    echo "export SSH_USERNAME=${azurerm_hdinsight_hadoop_cluster.similarity_exp_hadoop_cluster.roles[0].head_node[0].username}" >> my_env_vars.sh
    echo "export SSH_ENDPOINT=${azurerm_hdinsight_hadoop_cluster.similarity_exp_hadoop_cluster.ssh_endpoint}" >> my_env_vars.sh

    # Storage variables
    echo "export STORAGE_ACCOUNT_NAME=${azurerm_storage_account.similarity_exp_storage.name}" >> my_env_vars.sh
    echo "export STORAGE_ACCOUNT_KEY=${azurerm_storage_account.similarity_exp_storage.primary_access_key}" >> my_env_vars.sh
    echo "export CONTAINER_NAME=${azurerm_storage_container.similarity_exp_container.name}" >> my_env_vars.sh
    EOT
  }
}
