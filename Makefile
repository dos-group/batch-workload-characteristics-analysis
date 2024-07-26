include deployment/tf_env_vars.sh

init:
	@cd deployment && terraform init

deploy:
	@cd deployment && terraform apply

destroy:
	@cd deployment && terraform destroy

output:
	@cd deployment && terraform output hdinsight_cluster_details

destroy-force:
	for id in $$(az resource list --resource-group AlexGuttenberger_Thesis --query "[].id" -o tsv); \
	do \
		az resource delete --ids $$id --no-wait; \
	done
	rm -f deployment/terraform.tfstate*

# Resize the cluster

4:
	az hdinsight resize --resource-group AlexGuttenberger_Thesis  --name hadoopcluster12312BerlinABC --workernode-count 4
	@cd hibench && bash create-inventory.sh

8:
	az hdinsight resize --resource-group AlexGuttenberger_Thesis  --name hadoopcluster12312BerlinABC --workernode-count 8
	@cd hibench && bash create-inventory.sh

12:
	az hdinsight resize --resource-group AlexGuttenberger_Thesis  --name hadoopcluster12312BerlinABC --workernode-count 12
	@cd hibench && bash create-inventory.sh

# ANSIBLE COMMANDS

submit:
	ansible-playbook hibench/main.yml

setup:
	ansible-playbook -i hibench/hosts.ini hibench/setup-hibench.yml

ping:
	ansible all -i hibench/hosts.ini -m ping

# SSH COMMANDS

ssh:
	ssh $$SSH_USERNAME@$$SSH_ENDPOINT

ssh-wn0:
	ssh $$SSH_USERNAME@$$WN0_ADDRESS 

upload:
	scp -r $(DIR) $$SSH_USERNAME@$$SSH_ENDPOINT:/home/$$SSH_USERNAME
