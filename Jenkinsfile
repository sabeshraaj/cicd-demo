// Define a declarative pipeline
pipeline {
    // Specifies where the pipeline will run (using any available Jenkins agent)
    agent any 

    // Environment variables for configuration metadata (NO SECRETS HERE)
    environment {
        // --- CHANGE THESE VALUES ---
        AWS_REGION = "ap-south-1" 
        // Example: 123456789012.dkr.ecr.us-east-1.amazonaws.com/cicd-demo
        ECR_REPO_URI = "275851867352.dkr.ecr.ap-south-1.amazonaws.com/cicd-demo" 
        // This MUST match the ID of the AWS Credentials stored securely in Jenkins
        AWS_JENKINS_CREDENTIALS_ID = "aws-ecr-jenkins-creds"
        // --- END CHANGES ---
    }

    // Define the stages of the pipeline
    stages {
        stage('Build with Maven') {
            steps {
                echo 'Building the application with Maven...'
                // Clean, compile, and package the application into a JAR
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                echo 'Building Docker image...'
                // Build the image using the Dockerfile located in the root directory
                sh "docker build -t cicd-demo:${env.BUILD_NUMBER} ." 
                
                // Securely use the stored AWS credentials for ECR login
                withAWS(region: AWS_REGION, credentials: AWS_JENKINS_CREDENTIALS_ID) {
                    echo 'Logging into AWS ECR and pushing image...'
                    
                    // Use AWS CLI to get a temporary login password and pipe it to docker login
                    sh """
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO_URI}
                    """
                }
                
                // Tag the local image with the full ECR URI and push it
                sh "docker tag cicd-demo:${env.BUILD_NUMBER} ${ECR_REPO_URI}:${env.BUILD_NUMBER}"
                sh "docker push ${ECR_REPO_URI}:${env.BUILD_NUMBER}"
                
                // Also tag and push as 'latest' for convenience, if desired
                sh "docker tag cicd-demo:${env.BUILD_NUMBER} ${ECR_REPO_URI}:latest"
                sh "docker push ${ECR_REPO_URI}:latest"
            }
        }

        stage('Deploy to AWS ECS') {
            steps {
                echo 'Updating ECS Service with new image...'
                
                // Securely execute the AWS CLI commands using the stored credentials
                withAWS(region: AWS_REGION, credentials: AWS_JENKINS_CREDENTIALS_ID) {
                    
                    // The simplest deployment method: forcing ECS to pull the latest image
                    // by forcing a new deployment. This assumes the Task Definition
                    // is configured to use the :latest tag or that your Task Definition
                    // update logic is external/handled differently.
                    // For this simple pipeline, we assume the ECS Service/Task Def uses :latest
                    sh """
                    aws ecs update-service \
                        --cluster cicd-demo-cluster \
                        --service cicd-demo-service \
                        --task-definition cicd-demo-task-def \
                        --force-new-deployment
                    """
                    
                    echo "Deployment finished. ECS service is rolling out image tag: ${env.BUILD_NUMBER}"
                }
            }
        }
    }
}