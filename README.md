# self-managed-gitlab

This documentation will help you understand the architecture, setup, and usage of the complete pipeline made to create, scan and deploy a microservices-based application.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Getting Started](#getting-started)
   - [Prerequisites](#prerequisites)
   - [Installation](#installation)
3. [Project Organization](#project-organization)

## 1. Project Overview <a name="project-overview"></a>

Code-keeper sets up a self-managed Gitlab instance, its runners and repositories for the projects (Infrastructure-configuration, Api-gateway-app, Inventory and Billing). After everything's done, you can use the instance to upload the microservices to repo which will automatically create the corresponding dockerhub image and trigger deployment to AWS cloud. 

## 2. Getting Started <a name="getting-started"></a>

### Prerequisites <a name="prerequisites"></a>

Make sure you have the following installed on your machine:

- Ansible
- Vagrant
- Any supported hypervisor (VirtualBox, Hyper-V, etc.)

### Installation <a name="installation"></a>

1. Clone the repository:

   ```bash
   git clone https://github.com/Zewasik/code-keeper.git
   ```

2. Navigate to the project directory:

   ```bash
   cd code-keeper
   ```

3. Run code-keeper.sh script to initialize Ansible vault variables and create the infrastructure: 

   - Initialize variables
   ```bash
   bash code-keeper.sh init
   ```

   - Create the infrastructure
   ```bash
   bash code-keeper.sh create
   ```

## 3. Project Organization <a name="project-organization"></a>

### Overall File Structure

```console
.
├── code-keeper.sh
├── group_vars
│   └── git_group
│       └── vars
│           ├── docker.yml
│           └── user-info.yml
├── inventory.ini
├── playbooks
│   ├── ...
├── README.md
└── Vagrantfile
```
