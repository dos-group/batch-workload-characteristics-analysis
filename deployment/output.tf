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

  # prepare and create a docker context for the cluster
  provisioner "local-exec" {
    command = <<EOT
    chmod 600 ssh_key.pem
    ln -sf $(pwd)/ssh_key.pem ~/.ssh/id_rsa
    # add cluster to know_host
    ssh-keyscan -t ecdsa ${azurerm_hdinsight_hadoop_cluster.similarity_exp_hadoop_cluster.ssh_endpoint}  > tempkey && ssh-keygen -H -f tempkey && cat tempkey >> ~/.ssh/known_hosts && rm tempkey tempkey.old
    EOT
  }

  # create enviromental variables
  provisioner "local-exec" {
    command = <<EOT
    echo "" > tf_env_vars.sh

    # ssh variables
    echo "export SSH_USERNAME=${azurerm_hdinsight_hadoop_cluster.similarity_exp_hadoop_cluster.roles[0].head_node[0].username}" >> tf_env_vars.sh
    echo "export SSH_ENDPOINT=${azurerm_hdinsight_hadoop_cluster.similarity_exp_hadoop_cluster.ssh_endpoint}" >> tf_env_vars.sh

    # Storage variables
    echo "export STORAGE_ACCOUNT_NAME=${azurerm_storage_account.similarity_exp_storage.name}" >> tf_env_vars.sh
    echo "export STORAGE_ACCOUNT_KEY=${azurerm_storage_account.similarity_exp_storage.primary_access_key}" >> tf_env_vars.sh
    echo "export CONTAINER_NAME=${azurerm_storage_container.similarity_exp_container.name}" >> tf_env_vars.sh
    EOT
  }

  # prepare hibench
  provisioner "local-exec" {
    command = <<EOT
      export PROJECT_HOME=$(dirname "$PWD")

      # create ansible inventory file
      bash $PROJECT_HOME/hibench/create-inventory.sh
      # setup hibench
      ansible-playbook -i $PROJECT_HOME/hibench/hosts.ini ../hibench/setup-hibench.yml
    EOT
  }
}
