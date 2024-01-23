# Master Thesis Repository
This repository contains the source code and documentation for my master thesis. It leverages Docker to ensure a consistent and reproducible development environment.

## Prerequisites
Ensure you have [Docker Desktop 4.13.0](https://docs.docker.com/desktop/) or later installed on your system.

## Getting Started
### Setting Up the Development Environment

1. Create and Open Docker Development Environment

Click on this [link](https://open.docker.com/dashboard/dev-envs?url=https://github.com/guttenberger/Masterthesis), to create the dev environment and open the container shell with you ide

### Inside the IDE Terminal:

Authenticate with Azure using the command below:
```bash
    az login
```

Specify the Azure subscription to use by replacing [SUBSCRIPTION ID] with your actual subscription ID:
```bash
    az account set --subscription [SUBSCRIPTION ID]
```

Verify the currently selected Azure subscription:
```bash
    az account list --query "[?isDefault]"
```

Initialize Terraform with:
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
    make destroy
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