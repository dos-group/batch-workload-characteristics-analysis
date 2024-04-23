FROM docker/dev-environments-default:stable-1

#==============================
# Install Azure CLI
#==============================
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

#==============================
# Install Terraform
#==============================
RUN apt-get update && apt-get install -y gnupg software-properties-common curl
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get update && apt-get install terraform

#==============================
# Install Make
#==============================
RUN apt-get update && apt-get install -y make 

#==============================
# Install Python and dependencies
#==============================
RUN apt-get update && apt-get install -y python pip graphviz
# RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1
RUN pip install ipykernel jupyter matplotlib networkx scipy numpy seaborn