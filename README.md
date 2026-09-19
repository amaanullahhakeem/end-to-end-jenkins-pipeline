# End-to-End DevOps CI/CD Pipeline with AWS EKS

## 📌 Project Overview

This project demonstrates an end-to-end DevOps CI/CD pipeline for deploying a **Spring Boot application on AWS EKS**.

The project automates:

* Source code checkout from GitHub
* Maven build and testing
* Code quality analysis using SonarQube
* Docker image creation
* Docker image push to Amazon ECR
* Kubernetes deployment using Argo CD
* Infrastructure provisioning using Terraform
* Kubernetes monitoring using Prometheus and Grafana

The infrastructure is designed across **2 Availability Zones**, with the EKS worker nodes and application workloads running in **private subnets**.

---

## 🏗️ Architecture

```text
                         GitHub Repository
                                |
                                |
                           Jenkins CI
                                |
              +-----------------+-----------------+
              |                                   |
        Maven Build & Test                  SonarQube
              |                                   |
              +-----------------+-----------------+
                                |
                         Docker Build
                                |
                                v
                         Amazon ECR
                                |
                                |
                    GitHub Kubernetes Manifests
                                |
                                v
                           Argo CD
                                |
                                v
                    +-----------------------+
                    |       AWS EKS          |
                    |                         |
                    |   Private Subnets      |
                    |                         |
                    |  +-----------------+   |
                    |  |   Worker Node 1 |   |
                    |  |      AZ-1       |   |
                    |  +-----------------+   |
                    |          |              |
                    |    Spring Boot Pod     |
                    |                         |
                    |  +-----------------+   |
                    |  |   Worker Node 2 |   |
                    |  |      AZ-2       |   |
                    |  +-----------------+   |
                    |          |              |
                    |    Spring Boot Pod     |
                    +-----------------------+
                                |
                                |
                     Prometheus + Grafana
                        Kubernetes Monitoring


Jenkins / SonarQube / Argo CD / Grafana
                |
          Port Forwarding
                |
        Local Developer Machine
```

### Infrastructure Layout

```text
                     AWS VPC
                        |
             +----------+----------+
             |                     |
           AZ-1                  AZ-2
             |                     |
      Private Subnet         Private Subnet
             |                     |
       EKS Worker Node       EKS Worker Node
             |                     |
       Spring Boot Pod       Spring Boot Pod
             |                     |
             +----------+----------+
                        |
                     AWS EKS
```

The EKS cluster currently runs across **2 Availability Zones** with **2 worker nodes**.

The worker nodes have only private IP addresses:

```text
Worker Node 1
10.0.11.64

Worker Node 2
10.0.12.243
```

Both nodes are running Amazon Linux 2023 and Kubernetes `1.36`.

---

# 🛠️ Technologies Used

| Technology                   | Purpose                              |
| ---------------------------- | ------------------------------------ |
| AWS                          | Cloud infrastructure                 |
| Terraform                    | Infrastructure as Code               |
| Amazon VPC                   | Network infrastructure               |
| Amazon EKS                   | Kubernetes cluster                   |
| Amazon ECR                   | Docker image registry                |
| Jenkins                      | CI pipeline                          |
| Maven                        | Build and test                       |
| SonarQube                    | Code quality analysis                |
| Docker                       | Containerization                     |
| Kubernetes                   | Application deployment               |
| Argo CD                      | Continuous Delivery / GitOps         |
| Prometheus                   | Metrics collection                   |
| Grafana                      | Monitoring dashboards                |
| AWS Load Balancer Controller | Kubernetes AWS load balancing        |
| GitHub                       | Source code and Kubernetes manifests |

---

# 📂 Project Structure

```text
end-to-end-jenkins-pipeline/
│
├── java-maven-sonar-argocd-helm-k8s/
│   │
│   ├── ArgoCD/
│   │   └── argocd.yml
│   │
│   ├── spring-boot-app/
│   │   ├── Dockerfile
│   │   ├── JenkinsFile
│   │   ├── pom.xml
│   │   ├── src/
│   │   └── README.md
│   │
│   └── spring-boot-app-manifests/
│       ├── deployment.yml
│       ├── service.yml
│       └── ingress.yml
│
├── terraform-project/
│   └── production-eks/
│       │
│       ├── environment/
│       │   └── devlopment/
│       │       ├── main.tf
│       │       ├── variable.tf
│       │       ├── output.tf
│       │       └── terraform.tfvars
│       │
│       └── modules/
│           ├── vpc/
│           ├── eks/
│           └── ecr/
│
├── vars/
│
└── README.md
```

---

# ☁️ Infrastructure with Terraform

Terraform is used to provision the AWS infrastructure.

The project contains separate Terraform modules for:

### VPC

Creates the networking infrastructure required by EKS.

### EKS

Creates:

* EKS cluster
* Worker nodes
* IAM roles and policies
* EKS Pod Identity
* AWS Load Balancer Controller configuration

### ECR

Creates the Amazon ECR repository used to store the Docker images.

---

# ☸️ Amazon EKS

The Kubernetes cluster is:

```text
Cluster Name: production-eks-dev
Region: ap-south-1
Kubernetes Version: 1.36
```

The cluster currently has two worker nodes:

```text
Node 1:
10.0.11.64

Node 2:
10.0.12.243
```

The nodes are distributed across **2 Availability Zones**.

The worker nodes do not have public IP addresses and run inside the private network.

---

# 🚀 Application Deployment

The Spring Boot application runs in the `production` namespace.

```text
Namespace: production
Replicas: 2
Container Port: 8080
Service Type: ClusterIP
```

Current application deployment:

```text
spring-boot-app
        |
        +--- Pod 1 → Worker Node 1
        |
        +--- Pod 2 → Worker Node 2
```

This provides basic workload distribution across the two worker nodes.

The application image is stored in Amazon ECR:

```text
743887468885.dkr.ecr.ap-south-1.amazonaws.com/
production-eks-dev/spring-boot-app
```

---

# 🔄 CI Pipeline - Jenkins

Jenkins is responsible for Continuous Integration.

The Jenkins pipeline performs the following steps:

```text
GitHub
   |
   v
Checkout Source Code
   |
   v
Maven Build & Test
   |
   v
SonarQube Analysis
   |
   v
Docker Image Build
   |
   v
AWS ECR Login
   |
   v
Push Image to Amazon ECR
   |
   v
Update Kubernetes Manifest
   |
   v
Push Manifest Changes to GitHub
```

The Jenkins pipeline is defined in:

```text
java-maven-sonar-argocd-helm-k8s/
└── spring-boot-app/
    └── JenkinsFile
```

---

# 🔍 SonarQube

SonarQube is used for static code analysis.

The pipeline performs:

```text
Maven Build
     |
     v
SonarQube Analysis
     |
     v
Code Quality Report
```

It helps identify code quality issues before the application is deployed.

### SonarQube Access

SonarQube is not exposed publicly.

It is accessed using **port forwarding**.

Example:

```bash
kubectl port-forward <sonarqube-pod> 9000:9000
```

---

# 🐳 Docker & Amazon ECR

The Spring Boot application is packaged into a Docker image.

Example flow:

```text
Spring Boot Application
          |
          v
      Docker Build
          |
          v
     Docker Image
          |
          v
       Amazon ECR
```

ECR is used as the private container registry.

Example repository:

```text
production-eks-dev/spring-boot-app
```

---

# 🔁 Continuous Delivery with Argo CD

Argo CD is used for GitOps-based Continuous Delivery.

The Kubernetes manifests are stored in GitHub.

```text
GitHub
   |
   | Kubernetes manifests
   v
 Argo CD
   |
   | Sync
   v
 AWS EKS
   |
   v
Spring Boot Application
```

Argo CD is configured with:

* Automated sync
* Automatic pruning
* Self-healing

Application manifest:

```text
java-maven-sonar-argocd-helm-k8s/
└── ArgoCD/
    └── argocd.yml
```

The application manifests are located at:

```text
java-maven-sonar-argocd-helm-k8s/
└── spring-boot-app-manifests/
    ├── deployment.yml
    ├── service.yml
    └── ingress.yml
```

### Argo CD Access

Argo CD is running inside the Kubernetes cluster and is accessed using **port forwarding**.

Example:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

---

# 📊 Kubernetes Monitoring

Monitoring is implemented using:

* Prometheus
* Grafana
* Alertmanager
* kube-state-metrics
* Node Exporter

Monitoring components are deployed in:

```text
monitoring
```

namespace.

Current monitoring components include:

```text
Prometheus
Grafana
Alertmanager
Node Exporter
kube-state-metrics
Prometheus Operator
```

The monitoring stack collects Kubernetes and infrastructure-level metrics such as:

* Node CPU usage
* Node memory usage
* Pod CPU usage
* Pod memory usage
* Pod status
* Pod restarts
* Deployment availability
* Kubernetes resource usage

### Grafana Access

Grafana is running inside the private EKS environment and is accessed using **port forwarding**.

Example:

```bash
kubectl port-forward svc/kube-prometheus-stack-grafana \
  -n monitoring 3000:80
```

Grafana dashboards are used to monitor the Kubernetes cluster and workloads.

---

# 🔐 Access Model

The project intentionally keeps the Kubernetes workloads and internal services private.

| Component          | Access                  |
| ------------------ | ----------------------- |
| EKS Worker Nodes   | Private IP              |
| Spring Boot Pods   | Private                 |
| Kubernetes Service | ClusterIP               |
| Argo CD            | Port Forwarding         |
| Grafana            | Port Forwarding         |
| Prometheus         | Port Forwarding         |
| SonarQube          | Port Forwarding         |
| Jenkins            | Port Forwarding         |
| ECR                | AWS Private Registry    |
| GitHub             | External Git repository |

This avoids exposing internal DevOps tools directly to the public internet.

---

# 🔄 Complete CI/CD Flow

```text
Developer
    |
    v
GitHub
    |
    v
Jenkins
    |
    +----> Maven Build & Test
    |
    +----> SonarQube Analysis
    |
    +----> Docker Build
    |
    +----> Push Image to ECR
    |
    +----> Update Kubernetes Manifest
    |
    v
GitHub
    |
    v
Argo CD
    |
    v
AWS EKS
    |
    +-------------------+
    |                   |
    v                   v
Spring Boot App      Monitoring
    |              Prometheus
    |              Grafana
    |
    v
Kubernetes Service
```

---

# 📸 Project Screenshots

## SonarQube

SonarQube dashboard screenshot here:

<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/c03d5077-f894-47b7-b6b3-b63ab681198b" />


![SonarQube Dashboard](images/sonarqube.png)


## Jenkins Pipeline

Jenkins pipeline screenshot here:
<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/a0f0f1e2-daaf-4958-adeb-d1b4a9d515d0" />


![Jenkins Pipeline](images/jenkins-pipeline.png)

---

## Grafana Kubernetes Monitoring

Grafana Kubernetes compute/resource dashboard here:

<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/124e544c-ff25-4785-97a4-37ada9f684d5" />


![Grafana Kubernetes Dashboard](images/grafana-dashboard.png)

---

## ArgoCD Application
<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/ee9cdeac-5904-470b-bbee-06486a4b9159" />

# 🎯 Key DevOps Practices Demonstrated

This project demonstrates practical DevOps concepts:

* Infrastructure as Code using Terraform
* Modular Terraform structure
* AWS VPC and EKS
* Multi-AZ Kubernetes infrastructure
* Private Kubernetes worker nodes
* CI using Jenkins
* Automated Maven build and testing
* Static code analysis using SonarQube
* Docker containerization
* Private container registry using ECR
* GitOps using Argo CD
* Kubernetes deployment
* Automated synchronization and self-healing
* Kubernetes monitoring using Prometheus and Grafana
* Port-forward based access to internal DevOps tools

---

# ▶️ How to Access the Tools

Since the DevOps tools are not publicly exposed, port forwarding can be used for temporary access.

### Argo CD

```bash
kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8082:80
```

### Grafana

```bash
kubectl port-forward --address 0.0.0.0 svc/kube-prometheus-stack-grafana \
  -n monitoring 3000:80
```

### Prometheus

```bash
kubectl port-forward svc/kube-prometheus-stack-prometheus \
  -n monitoring 9090:9090
```

The exact SonarQube and Jenkins commands depend on where those services are running.

---

# 📌 Project Outcome

The final setup provides a complete DevOps workflow:

```text
Code
 ↓
GitHub
 ↓
Jenkins
 ↓
Build & Test
 ↓
SonarQube
 ↓
Docker
 ↓
Amazon ECR
 ↓
GitHub Manifest Update
 ↓
Argo CD
 ↓
AWS EKS
 ↓
Spring Boot Application
 ↓
Prometheus + Grafana
```

The infrastructure is provisioned using Terraform, the application is deployed on a private EKS environment across two Availability Zones, and Kubernetes resources are monitored using Prometheus and Grafana.

---

# 👨‍💻 Author
**Aman Ullah**
**DevOps Project**

GitHub Repository:

`https://github.com/amaanullahhakeem/end-to-end-jenkins-pipeline.git`

