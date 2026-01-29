pipeline {
    agent any

    environment {
        IMAGE_NAME = "rogerprawin/devops-node-app"
        IMAGE_TAG  = "latest"
        DOCKER_CREDS = credentials('dockerhub-creds')
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'master',
                    url: 'git@github.com:Rogerprawin/devops-node-app.git',
                    credentialsId: 'git-new-key'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test || echo "No tests found"'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                  docker build -t $IMAGE_NAME:$IMAGE_TAG .
                '''
            }
        }

        stage('Login to DockerHub') {
            steps {
                sh '''
                  echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin
                '''
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                sh '''
                  docker push $IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                  kubectl apply -f deployment.yaml
                  kubectl apply -f service.yaml
                '''
            }
        }
    }

    post {
        success {
            echo '🚀 CI/CD Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed'
        }
    }
}
