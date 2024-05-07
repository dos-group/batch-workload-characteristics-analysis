include deployment/tf_env_vars.sh

init:
	@cd deployment && terraform init

deploy:
	@cd deployment && terraform apply

submit:
	ansible-playbook -i "${SSH_ENDPOINT}," -u ${SSH_USERNAME} hibench/run-hibench.yml

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

# SSH COMMANDS

ssh:
	ssh $$SSH_USERNAME@$$SSH_ENDPOINT

upload:
	scp -r $(DIR) $$SSH_USERNAME@$$SSH_ENDPOINT:/home/$$SSH_USERNAME
