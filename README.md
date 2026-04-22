# End-to-End CI/CD Pipeline using Jenkins, Docker, SonarQube, and GitOps

This project demonstrates a complete end-to-end CI/CD pipeline built using modern DevOps tools.
It automates the process of building, analyzing, containerizing, and deploying a Spring Boot application.

![Screenshot 2023-03-28 at 9 38 09 PM](https://user-images.githubusercontent.com/43399466/228301952-abc02ca2-9942-4a67-8293-f76647b6f9d8.png)


# Tech Stack

- Jenkins – CI/CD pipeline automation
- Maven – Build and package the application
- SonarQube – Static code analysis
- Docker – Containerization
- GitHub – Source code management
- Kubernetes (via manifests) – Deployment
- ArgoCD (GitOps approach) – Continuous deployment.


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

<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/8ec7d791-ccb3-4caf-ab3d-1072eb9b73d8" />

