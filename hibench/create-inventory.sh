#!/bin/bash

PLAYBOOK_PATH="/com.docker.devenvironments.code/hibench"

# Load environment variables from the file
source deployment/tf_env_vars.sh

# Create the head_node entry in the Ansible inventory
echo -e "[head_node]\nhead0 ansible_host=${SSH_ENDPOINT} ansible_user=${SSH_USERNAME}" > ${PLAYBOOK_PATH}/hosts.ini

# SSH to the Head Node and get the list of Worker Nodes
ssh ${SSH_USERNAME}@${SSH_ENDPOINT} 'yarn node -list' | \
grep wn | \
awk -v SSH_USERNAME="${SSH_USERNAME}" -v SSH_ENDPOINT="${SSH_ENDPOINT}" \
'BEGIN {count=0} {split($1, a, ":"); print "worker" count " ansible_host="a[1]" ansible_user="SSH_USERNAME" ansible_ssh_common_args=\"-o ProxyCommand='\''ssh -W %h:%p -q "SSH_USERNAME"@"SSH_ENDPOINT"'\''\""; count++}' > workers.tmp


# todo add wokernodes to known hosts
# ssh-keyscan -t ecdsa   > tempkey && ssh-keygen -H -f tempkey && cat tempkey >> ~/.ssh/known_hosts && rm tempkey tempkey.old

# Append the worker_nodes entries to the Ansible inventory
echo "" >> ${PLAYBOOK_PATH}/hosts.ini
echo "[worker_nodes]" >> ${PLAYBOOK_PATH}/hosts.ini
cat workers.tmp >> ${PLAYBOOK_PATH}/hosts.ini
rm workers.tmp
