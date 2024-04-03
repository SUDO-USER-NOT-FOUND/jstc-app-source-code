pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }
    
    environment {
        SONAR_PROJECT_KEY = "${env.SONAR_PROJECT_KEY}"
        SONAR_AUTH_TOKEN = "${env.SONAR_AUTH_TOKEN}"
        SONAR_HOST_URL = "${env.SONAR_HOST_URL}"
    }
    
    stages {
        stage('Check Dockerfile') {
            steps {
                script {
                    scannerHome = tool 'SonarQube';
                }
                withSonarQubeEnv('SonarQube') {
                    echo "Running SonarQube analysis..."
                    sh "${scannerHome}/bin/sonar-scanner " +
                       "-Dsonar.host.url=${SONAR_HOST_URL} " +
                       "-Dsonar.projectKey=${SONAR_PROJECT_KEY} " +
                       "-Dsonar.login=${SONAR_AUTH_TOKEN}"
                }
                script {
                    // Check if Dockerfile exists in the repository
                    def dockerfileExists = sh(script: "git ls-files | grep -q 'Dockerfile'", returnStatus: true) == 0

                    if (dockerfileExists) {
                        // Task 1: Build the Docker image if Dockerfile exists
                        echo "Dockerfile exists in the repository. Building the Docker image..."
                        sh 'docker build -t built-image:latest .'
                        
                        // Task 2: Scan the built Docker image using Trivy
                        echo "Scanning Docker image using Trivy..."
                        sh 'docker pull aquasec/trivy'
                        sh 'docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image built-image:latest'
                    } else {
                        // Task 3: Run SonarQube analysis
                    }
                }
            }
        }
    }
}
