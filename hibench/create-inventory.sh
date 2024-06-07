#!/bin/bash

# Define the path where the Ansible playbook and other related files are stored.
PROJECT_HOME=$(dirname $PWD)
PLAYBOOK_PATH="$PROJECT_HOME/hibench"
GENERATED_ENV_VARS="$PROJECT_HOME/deployment/tf_env_vars.sh"
SSH_CONFIG_FILE="$HOME/.ssh/config"

# Load environment variables from a specific file.
source $GENERATED_ENV_VARS

# Create or update the head_node entry in the Ansible inventory.
echo -e "[head_node]\nhead0 ansible_host=${SSH_ENDPOINT} ansible_user=${SSH_USERNAME}" > ${PLAYBOOK_PATH}/hosts.ini

# Use SSH to connect to the Head Node and get the list of Worker Nodes, formatting the output as Ansible inventory lines.
ssh -o StrictHostKeyChecking=no ${SSH_USERNAME}@${SSH_ENDPOINT} 'yarn node -list' | \
grep wn | \
awk -v SSH_USERNAME="${SSH_USERNAME}" -v SSH_ENDPOINT="${SSH_ENDPOINT}" \
'BEGIN {count=0} {split($1, a, ":"); print "worker" count " ansible_host="a[1]" ansible_user="SSH_USERNAME" ansible_ssh_common_args=\"-o ProxyCommand='\''ssh -W %h:%p -q "SSH_USERNAME"@"SSH_ENDPOINT"'\''\""; if (count == 0) {print a[1] > "wn0_address.tmp"} count++}' > workers.tmp

# Extract the worker node hostnames to facilitate ssh-keyscan via the head node proxy.
awk '{print $2}' workers.tmp | cut -d'=' -f2 > worker_hostnames.tmp

# Add worker nodes to known_hosts to avoid SSH key verification prompts later.
while read -r hostname; do
    ssh -o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q ${SSH_USERNAME}@${SSH_ENDPOINT}" ${SSH_USERNAME}@${hostname} "exit" 2>&1 | grep -v "known hosts" | grep -v "Warning" > /dev/null
done < worker_hostnames.tmp

# Retrieve the address of the first worker node from the temporary file for later use.
WN0_ADDRESS=$(cat wn0_address.tmp)
rm wn0_address.tmp

# Append the worker node address to the environment variables file for further deployment use.
echo "export WN0_ADDRESS=${WN0_ADDRESS}" >> $GENERATED_ENV_VARS

# Clean up temporary files.
rm worker_hostnames.tmp

# Append the dynamically generated worker_nodes entries to the Ansible inventory.
echo "[worker_nodes]" >> ${PLAYBOOK_PATH}/hosts.ini
cat workers.tmp >> ${PLAYBOOK_PATH}/hosts.ini
rm workers.tmp

# Create the SSH config file if it doesn't exist
if [ ! -f $SSH_CONFIG_FILE ]; then
    mkdir -p $(dirname $SSH_CONFIG_FILE)
    touch $SSH_CONFIG_FILE
fi

# Remove existing configurations for worker nodes from the SSH config file
sed -i '/^Host wn*/,/^$/d' $SSH_CONFIG_FILE

# Update SSH config to use the head node as a proxy for worker nodes
echo -e "\n# Proxy configuration for worker nodes" >> $SSH_CONFIG_FILE
echo "Host wn*" >> $SSH_CONFIG_FILE
echo "    ProxyCommand ssh -W %h:%p ${SSH_USERNAME}@${SSH_ENDPOINT}" >> $SSH_CONFIG_FILE
echo "    StrictHostKeyChecking no" >> $SSH_CONFIG_FILE
echo "    User ${SSH_USERNAME}" >> $SSH_CONFIG_FILE
