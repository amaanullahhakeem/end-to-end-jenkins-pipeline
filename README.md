# End-to-End CI/CD Pipeline using Jenkins, Docker, SonarQube, GitOps, Monitoring & Observibility.

This project demonstrates a complete end-to-end CI/CD pipeline built using modern DevOps tools.
It automates the process of building, analyzing, containerizing, and deploying a Spring Boot application.

![Screenshot 2023-03-28 at 9 38 09 PM](https://user-images.githubusercontent.com/43399466/228301952-abc02ca2-9942-4a67-8293-f76647b6f9d8.png)

# Project Dec.
“I built an end-to-end CI/CD pipeline to automate the complete software delivery lifecycle, including application build, code quality analysis, containerization, deployment, and monitoring of a Spring Boot application.

The process starts when code is pushed to GitHub, which triggers a Jenkins pipeline. Jenkins automatically pulls the source code and uses Maven to compile, test, and package the application.

Next, SonarQube performs static code analysis to identify code quality issues, vulnerabilities, and maintainability problems before moving further in the deployment process. After successful validation, Docker is used to containerize the application, and the Docker image is pushed to Docker Hub with a version tag based on the Jenkins build number.

For deployment, I implemented ArgoCD using a GitOps approach. ArgoCD continuously monitors the Kubernetes manifests stored in Git and automatically synchronizes any changes with the Kubernetes cluster. The application is deployed on Amazon EKS using Kubernetes Deployment and Service resources.

To enhance reliability and operational visibility, I integrated Prometheus and Grafana for monitoring and observability. Prometheus collects metrics from the Kubernetes cluster and application components, while Grafana provides interactive dashboards to visualize application performance, resource utilization, pod health, and cluster metrics.

This pipeline automates the complete workflow from code commit to production deployment, reduces manual intervention, improves deployment consistency, and helped reduce deployment time by around 60% while providing real-time monitoring and visibility into the application and infrastructure.”

# Tech Stack

- Jenkins – CI/CD pipeline automation
- Maven – Build and package the application
- SonarQube – Static code analysis
- Docker – Containerization
- GitHub – Source code management
- Kubernetes (via manifests) – Deployment
- ArgoCD (GitOps approach) – Continuous deployment
- Prometheus & Grafana - For monitoring and observability.


# Pipeline Workflow

The Jenkins pipeline performs the following steps:

1. Code Checkout
   Pulls the latest code from GitHub repository
2. Build & Test
   Uses Maven to compile the code and generate a JAR file

Command used:" mvn clean package"

3. Static Code Analysis

   Performs code quality checks using SonarQube
   Helps identify bugs, vulnerabilities, and code smells

4. Docker Build & Push
   Builds a Docker image using the generated JAR
   Tags the image with Jenkins build number
   Pushes the image to DockerHub

# Example:

docker build -t <docker-username>/app:<build-number> .
docker push <docker-username>/app:<build-number>

5. Update Kubernetes Manifest (GitOps)
   Automatically updates the image tag in deployment.yml
   Commits and pushes changes back to GitHub

   This enables GitOps-based deployment using ArgoCD.
   
6. Prometheus & Grafana.
   For Observibility & Monitoring.
   <img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/b37ce3ce-be54-4f38-b733-1aa72b1ec62d" />

   
# Pipeline Result

✔ Build Successful
✔ Code Analysis Completed
✔ Docker Image Pushed
✔ Deployment File Updated Automatically

#  Key Highlights
- Fully automated CI/CD pipeline
- Uses build number-based versioning for Docker images
- Implements GitOps approach for deployment
- Clean integration between Jenkins, Docker, and SonarQube
- Production-style pipeline structure
# Pipeline Execution

<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/df71e8ab-041d-4167-831e-fc897f101aea" />


