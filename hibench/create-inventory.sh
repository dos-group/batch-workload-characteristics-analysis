#!/bin/bash

PLAYBOOK_PATH="/com.docker.devenvironments.code/hibench"

# Load environment variables from the file
source deployment/tf_env_vars.sh

echo -e "[head_node]\nhead0 ansible_host=${SSH_ENDPOINT} ansible_user=${SSH_USERNAME}" > ${PLAYBOOK_PATH}/hosts.ini

# SSH to the Head Node and get the list of Worker Nodes
ssh ${SSH_USERNAME}@${SSH_ENDPOINT} 'yarn node -list' | \
grep wn | \
awk -v SSH_USERNAME="${SSH_USERNAME}" -v SSH_ENDPOINT="${SSH_ENDPOINT}" \
'BEGIN {count=0} {print "worker" count " ansible_host="$1" ansible_user="SSH_USERNAME" ansible_ssh_common_args=\"-o ProxyCommand=\"ssh -W %h:%p -q "SSH_USERNAME"@"SSH_ENDPOINT"\"\""; count++}' > workers.tmp

# Create Ansible inventory file for Worker Nodes
echo "" >> ${PLAYBOOK_PATH}/hosts.ini
echo "[worker_nodes]" >> ${PLAYBOOK_PATH}/hosts.ini
cat workers.tmp >> ${PLAYBOOK_PATH}/hosts.ini
rm workers.tmp
