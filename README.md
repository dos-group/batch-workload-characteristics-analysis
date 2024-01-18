# Master Thesis Repository
This repository contains the source code and documentation for my master thesis. It leverages Docker to ensure a consistent and reproducible development environment.

## Prerequisites
Ensure you have Docker Desktop 4.13.0 or later installed on your system.

## Getting Started
### Setting Up the Development Environment
1. Create and Open Docker Development Environment
1.1. create the development environment with:
```bash
    docker dev create https://github.com/guttenberger/Masterthesis.git
```
1.2. To find the name of your development environment, execute:
```bash
    docker dev list
```
1.3 open the enviroment with
```bash
    docker dev open DEV_ENVIRONMENT_NAME
```

2. Azure Authentication
2.1 login into azure with
```bash
    az login
```
2.2. set subscription with:
```bash
    az account set --subscription [SUBSCRIPTION ID]
```
2.3. confirm you selected subscription with:
```bash
    az account list --query "[?isDefault]"
```

3. Initialize Terraform with:

```bash
    make init
```

## Deploying the Cluster
To deploy the cluster, execute the following command:
```bash
    make deploy
```
To destroy the cluster and clean up resources, use:
```bash
    make deploy
```

## Makefile Commands
- `deploy`: Deploy the infrastructure using Terraform.
- `destroy`: Destroy the Terraform-managed infrastructure.
- `destroy-force`: Force delete the Azure resource group and clean up Terraform state files.
- `ssh-connect`: Establish an SSH connection to the endpoint.
- `upload`: Upload data to the remote server via SCP.
- `docker-build`: Build the Docker image and push it to the repository.
- `submit-mr`: Run a MapReduce job using Docker in the cluster.
- `docker-it`: Open an interactive terminal in the cluster.
- `docker-it-local`: Open an interactive terminal in a local Docker container.