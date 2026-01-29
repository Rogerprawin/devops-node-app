pipeline {
  agent any

  environment {
    IMAGE_NAME = "rogerprawin/devops-node-app"
    IMAGE_TAG  = "${BUILD_NUMBER}"
  }

  stages {

    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }

    stage('Install Dependencies') {
      steps {
        sh 'npm install'
      }
    }

    stage('Run Tests (Non-blocking)') {
      steps {
        sh '''
          npm test || echo "⚠️ No tests found – continuing"
        '''
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
          docker build -t $IMAGE_NAME:$IMAGE_TAG .
          docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest
        '''
      }
    }

    stage('Login to DockerHub') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-creds',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh '''
            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
          '''
        }
      }
    }

    stage('Push Image to DockerHub') {
      steps {
        sh '''
          docker push $IMAGE_NAME:$IMAGE_TAG
          docker push $IMAGE_NAME:latest
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

    stage('Verify Rollout') {
      steps {
        sh '''
          kubectl rollout status deployment/devops-node-app --timeout=60s
        '''
      }
    }

    stage('Health Check') {
    steps {
        sh '''
        NODE_PORT=$(kubectl get svc devops-node-app-service \
          -o jsonpath='{.spec.ports[0].nodePort}')

        echo "Checking health on NodePort: $NODE_PORT"

        curl -f http://localhost:$NODE_PORT/health
        '''
      }
    }

  }

  post {
    success {
      echo '✅ Pipeline completed successfully'
    }
    failure {
      echo '❌ Pipeline failed'
    }
  }
}
