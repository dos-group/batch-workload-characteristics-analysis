# Evaluation of Batch Workload Characterization Techniques for Performance Modeling of Distributed Data Processing Systems
This repository contains all materials and code related to my master's thesis, which focuses on workload similarity evaluation from big data processing platforms such as Apache Hadoop or Apache Spark. It uses Docker, Ansible and Terraform to ensure a consistent and reproducible development environment.

## Key Components
- **Ansible Scripts**: Script for the HiBench deployment, configuration and workload submits. These scripts can be found in the `hibench` folder.
- **Deployment**: Contains Terraform scripts for setting up the HDInsight Azure computing cluster. These resources are located in the `deployment` folder.
- **HiBench Config**: A benchmarking suite for big data applications, including configuration files and scripts to run various benchmarks. These configurations are available in the `hibench/conf` folder.
- **Systematic Literature Review Results & Layer Analysis**: Layerdata, Jupyter notebooks and scripts for analyzing the layers used in performance models. These analyses are contained in the `layer-analysis` folder.
- **Similarity Metrics**: Scripts and notebooks for calculating similarity metrics between workloads. These resources are found in the `hibench/results` folder.
- **Experiments Results**: Scripts and data for analyzing benchmark results. The relevant files are located in the `hibench/results` folder.

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
- `init`: Initialize the Terraform configuration.
- `deploy`: Deploy the infrastructure using Terraform.
- `destroy`: Destroy the Terraform-managed infrastructure.
- `output`: Retrieve the details of the HDInsight cluster from Terraform output.
- `destroy-force`: Force delete the Azure resource group and clean up Terraform state files.
- `4`: Resize the HDInsight cluster to 4 worker nodes.
- `8`: Resize the HDInsight cluster to 8 worker nodes.
- `12`: Resize the HDInsight cluster to 12 worker nodes.
- `submit`: Run a MapReduce job using Docker in the cluster.
- `setup`: Setup HiBench environment using Ansible.
- `ping`: Ping all nodes in the HiBench inventory.
- `ssh`: Establish an SSH connection to the endpoint.
- `ssh-wn0`: Establish an SSH connection to the worker node 0.
- `upload`: Upload data to the remote server via SCP.

## Acknowledgments
Special thanks to my supervisor and all those who supported me throughout my Master's journey.