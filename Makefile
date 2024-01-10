include deployment/my_env_vars.sh

fclean:
	az group delete --name SimilarityExperimentRG --yes --no-wait 
	git clean -df deployment

connect:
	ssh -i deployment/ssh_key.pem $$SSH_USERNAME@$$SSH_ENDPOINT
# ssh -i deployment/ssh_key.pem simexpuservm@hadoopcluster12312Berlin-ssh.azurehdinsight.net
