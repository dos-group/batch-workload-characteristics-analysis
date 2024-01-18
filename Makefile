include deployment/tf_env_vars.sh

DOCKER_REPO=guttenberger
DOCKER_IMAGE=$(DOCKER_REPO)/hibench-hadoop-3.1.0:latest
DOCKER_RUN_COMMON_OPTS=\
	-v /usr/hdp/current/hadoop-client/:/host \
	-v /etc/hadoop/:/etc/hadoop/ \
	-v /usr/hdp/4.1.17.13/hadoop/:/usr/hdp/4.1.17.13/hadoop/ \
	-v /usr/hdp/current/hadoop-mapreduce-client/hadoop-mapreduce-examples.jar:/host/examples/hadoop-mapreduce-examples.jar \
	-e "PATH=/host/bin:$$PATH" \
	-e "INPUT_HDFS=/example/data/10GB-sort-input" \
	-e "HADOOP_EXAMPLES_JAR=/host/examples/hadoop-mapreduce-examples.jar" \
	-ti $(DOCKER_IMAGE)

deploy:
	@cd deployment && terraform apply

destroy:
	@cd deployment && terraform destroy

destroy-force:
	az group delete --name SimilarityExperimentRG --yes --no-wait 
	rm deployment/terraform.tfstate*

ssh-connect:
	ssh-keygen -f "/root/.ssh/known_hosts" -R $$SSH_ENDPOINT
	ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $$SSH_USERNAME@$$SSH_ENDPOINT

upload:
	scp -r $(DIR) $$SSH_USERNAME@$$SSH_ENDPOINT:/home/$$SSH_USERNAME

docker-build:
	@cd hibench-docker && \
	docker context use default && \
	docker build -t $(DOCKER_IMAGE) -f HiBench-Hadoop-3.1.0.Dockerfile . && \
	docker push $(DOCKER_IMAGE)

run-mr:
	docker context use cluster && \
	docker run $(DOCKER_RUN_COMMON_OPTS) \
		/bin/bash -c '/root/HiBench/bin/workloads/micro/wordcount/prepare/prepare.sh' && \
	docker context use default

docker-it-local:
	docker context use cluster && \
	docker run \
		-v /usr/bin/:/host/bin \
		-v /etc/:/host/etc/ \
		-v /share/:/host/share/ \
		-e "PATH=/host/bin:$$PATH" \
		-ti $(DOCKER_IMAGE) \
		/bin/bash && \
	docker context use default

docker-it-remote:
	docker context use cluster && \
	docker run $(DOCKER_RUN_COMMON_OPTS) \
		/bin/bash && \
	docker context use default
