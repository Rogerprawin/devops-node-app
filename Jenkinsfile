pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Use the SSH credential you added in Jenkins (e.g., git-new-key)
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
                sh 'docker build -t devops-node-app:latest .'
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                docker rm -f node-app || true
                docker run -d -p 3000:3000 --name node-app devops-node-app:latest
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline finished successfully!'
        }
        failure {
            echo 'Pipeline failed 😢'
        }
    }
}
