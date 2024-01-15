include deployment/tf_env_vars.sh

DOCKER_REPO=guttenberger
COMMAND?='/root/HiBench/bin/workloads/micro/wordcount/prepare/prepare.sh'

deploy:
	@cd deployment && \
	terraform apply

destroy:
	@cd deployment && \
	terraform destroy

fdestroy:
	az group delete --name SimilarityExperimentRG --yes --no-wait 
	rm deployment/terraform.tfstate*

connect:
	ssh-keygen -f "/root/.ssh/known_hosts" -R $$SSH_ENDPOINT
	ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $$SSH_USERNAME@$$SSH_ENDPOINT
# ssh $$SSH_USERNAME@$$SSH_ENDPOINT

submit:
	docker context use cluster
	docker run \
		-v /usr/bin/:/host/bin \
		-v /etc/:/host/etc/ \
		-v /share/:/host/share/ \
		-e "PATH=/host/bin:$$PATH" \
		-ti $(DOCKER_REPO)/hibench-hadoop-3.1.0 \
		/bin/bash -c '/root/HiBench/bin/workloads/micro/wordcount/prepare/prepare.sh'
	docker context use default

run:
	docker run \
		$(DOCKER_REPO)/hibench-hadoop-3.1.0

build:
	@cd docker && \
	docker context use default
	docker build -t $(DOCKER_REPO)/hibench-hadoop-3.1.0 -f HiBench-Hadoop-3.1.0.Dockerfile .
	docker push $(DOCKER_REPO)/hibench-hadoop-3.1.0

test:
	docker run -ti $(DOCKER_REPO)/hibench-hadoop-3.1.0 /bin/bash -c $$COMMAND

test-remote:
	docker context use cluster
	docker run \
		-v /usr/bin/:/host/bin \
		-v /etc/:/host/etc/ \
		-v /share/:/host/share/ \
		-e "PATH=/host/bin:$$PATH" \
		-ti $(DOCKER_REPO)/hibench-hadoop-3.1.0 \
		/bin/bash -c $$COMMAND
	docker context use default

submit-jobs:
	ssh -i deployment/ssh_key.pem $$SSH_USERNAME@$$SSH_ENDPOINT "ls -l ~"

upload:
	scp -r $(DIR) $$SSH_USERNAME@$$SSH_ENDPOINT:/home/$$SSH_USERNAME
