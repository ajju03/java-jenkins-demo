pipeline {
    agent any

    tools {
        jdk 'JDK21'
        maven 'Maven3'
    }

    environment {
        // Jenkins SonarQube server config name
        SONARQUBE_ENV = 'Sonarqube'

        // SonarQube token stored in Jenkins credentials
        SONAR_TOKEN = credentials('sonarqubetoken')

        // DockerHub image name (replace with your DockerHub username)
        DOCKER_IMAGE = 'ajju03/java-jenkins-demo:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                echo '📦 Checking out code from GitHub...'
                git branch: 'main', url: 'https://github.com/ajju03/java-jenkins-demo.git'
            }
        }

        stage('Build') {
            steps {
                echo '🔨 Building Java project...'
                bat 'mvn clean install -Dmaven.compiler.source=17 -Dmaven.compiler.target=17'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo '🔍 Running SonarQube analysis...'
                withSonarQubeEnv('Sonarqube') {
                    bat """
                        mvn sonar:sonar ^
                        -Dsonar.projectKey=Week12-project ^
                        -Dsonar.projectName=Week12-Project ^
                        -Dsonar.host.url=http://13.202.94.241:9000 ^
                        -Dsonar.sources=src/main/java ^
                        -Dsonar.token=%SONAR_TOKEN%
                    """
                }
            }
        }

        stage('Docker Build') {
            steps {
                echo '🐳 Building Docker image...'
                bat 'docker build -t %DOCKER_IMAGE% .'
            }
        }

        stage('Docker Push') {
            steps {
                echo '⬆️ Pushing image to DockerHub...'
                withCredentials([usernamePassword(credentialsId: 'DOCKERHUB_CREDENTIALS', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat """
                        docker login -u %DOCKER_USER% -p %DOCKER_PASS%
                        docker push %DOCKER_IMAGE%
                    """
                }
            }
        }

        stage('Local Deploy') {
            steps {
                echo '🚀 Deploying container locally...'
                bat """
                    docker stop java-demo || echo "No existing container to stop"
                    docker rm java-demo || echo "No existing container to remove"
                    docker run -d --name java-demo -p 8080:8080 %DOCKER_IMAGE%
                """
            }
        }

        stage('Quality Gate') {
            steps {
                echo '🧱 Checking Quality Gate (placeholder stage)'
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully — Build, SonarQube, Docker, and Deploy all OK!'
        }
        failure {
            echo '❌ Pipeline failed — check logs for the failed stage.'
        }
    }
}
