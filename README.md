# cicd-demo

A simple Spring Boot web application to demonstrate CI/CD automation using Jenkins, Docker, and AWS ECS.

## Overview

- **REST API**: Exposes a single endpoint (`/`) that returns a greeting message with the current version.
- **Spring Boot**: Built with Spring Boot 3.5.7 and Java 17.
- **Dockerized**: Includes a `Dockerfile` for containerization.
- **Jenkins Pipeline**: Automated build, Docker image creation, push to AWS ECR, and deployment to AWS ECS via the included `Jenkinsfile`.
- **Maven Wrapper**: Use `./mvnw` for consistent Maven builds.

## Project Structure

- `src/main/java/com/example/cicd_demo/CicdDemoApplication.java`: Main application entry point.
- `src/main/java/com/example/cicd_demo/DemoController.java`: REST controller for the `/` endpoint.
- `pom.xml`: Maven build configuration.
- `Dockerfile`: Multi-stage build for containerizing the application.
- `Jenkinsfile`: Jenkins pipeline for CI/CD.
- `application.properties`: Basic Spring Boot configuration.

## How to Run Locally

```bash
./mvnw spring-boot:run
```

Visit [http://localhost:8080/](http://localhost:8080/) to see the greeting message.

## Build Docker Image

```bash
docker build -t cicd-demo .
```

## CI/CD Pipeline

The `Jenkinsfile` automates:
- Maven build
- Docker image build and push to AWS ECR
- ECS deployment update

## Requirements

- Java 17+
- Maven
- Docker
- Jenkins (for CI/CD)
- AWS CLI (for deployment)

## License

This project is for demonstration purposes.
