include deployment/tf_env_vars.sh

init:
	@cd deployment && terraform init

deploy:
	@cd deployment && terraform apply

destroy:
	@cd deployment && terraform destroy

output-details:
	@cd deployment && terraform output hdinsight_cluster_details

destroy-force:
	for id in $$(az resource list --resource-group AlexGuttenberger_Thesis --query "[].id" -o tsv); \
	do \
		az resource delete --ids $$id --no-wait; \
	done
	rm -f deployment/terraform.tfstate*

# ANSIBLE COMMANDS

submit:
	ansible-playbook -i hibench/hosts.ini hibench/run-hibench.yml -vvvv

setup:
	ansible-playbook -i hibench/hosts.ini hibench/setup-hibench.yml

ping:
	ansible all -i hibench/hosts.ini -m ping

# SSH COMMANDS

ssh:
	ssh $$SSH_USERNAME@$$SSH_ENDPOINT

ssh-wn:
	ssh -o ProxyCommand="ssh -W %h:%p $$SSH_USERNAME@$$SSH_ENDPOINT" $$SSH_USERNAME@wn0-hadoop.as3hslim2y2evcnseqdhpyy2ib.frax.internal.cloudapp.net

upload:
	scp -r $(DIR) $$SSH_USERNAME@$$SSH_ENDPOINT:/home/$$SSH_USERNAME
