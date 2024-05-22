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
'BEGIN {count=0} {split($1, a, ":"); print "worker" count " ansible_host="a[1]" ansible_user="SSH_USERNAME" ansible_ssh_common_args=\"-o ProxyCommand='\''ssh -W %h:%p -q "SSH_USERNAME"@"SSH_ENDPOINT"'\''\""; if (count == 0) {print a[1] > "wn0_address.tmp"} count++}' > workers.tmp

# Extract the worker node hostnames
awk '{print $2}' workers.tmp | cut -d'=' -f2 > worker_hostnames.tmp

# Add worker nodes to known_hosts via head node proxy
while read -r hostname; do
    ssh ${SSH_USERNAME}@${SSH_ENDPOINT} "ssh-keyscan -t ecdsa ${hostname}" >> ~/.ssh/known_hosts
done < worker_hostnames.tmp

# Get the address of wn0 from the temporary file
WN0_ADDRESS=$(cat wn0_address.tmp)
rm wn0_address.tmp

# Add the wn0 address to the environment variables file
echo "export WN0_ADDRESS=${WN0_ADDRESS}" >> deployment/tf_env_vars.sh

# Clean up temporary file
rm worker_hostnames.tmp

# Append the worker_nodes entries to the Ansible inventory
echo "" >> ${PLAYBOOK_PATH}/hosts.ini
echo "[worker_nodes]" >> ${PLAYBOOK_PATH}/hosts.ini
cat workers.tmp >> ${PLAYBOOK_PATH}/hosts.ini
rm workers.tmp
