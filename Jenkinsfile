pipeline {
    agent any
    tools {
        jdk 'JDK21'
        maven 'Maven3' // <-- this tells Jenkins to use the Maven you configured
    }
    
    environment {
        // 👇 Replace with the name of your SonarQube server configured in Jenkins
        SONARQUBE_ENV = 'Sonarqube'
        SONAR_TOKEN = credentials('sonarqubetoken')
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ajju03/java-jenkins-demo.git'
            }
        }

    stage('Build') {
        steps {
            bat 'mvn clean install -Dmaven.compiler.source=17 -Dmaven.compiler.target=17'
        }
        
    }


        stage('SonarQube Analysis') {
            steps {
                // Integrates with the SonarQube plugin configured in Jenkins
                withSonarQubeEnv('Sonarqube') {
                bat '''
                mvn sonar:sonar ^
                -Dsonar.projectKey=Week12-project ^
                -Dsonar.projectName=Week12-Project ^
                -Dsonar.host.url=http://13.202.94.241:9000 ^
                -Dsonar.sources=src/main/java
                -Dsonar.login=%SONAR_TOKEN%
                '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                echo 'Check Quality Gate here'
            }
        }
    }

    post {
        failure {
            echo '❌ Build or SonarQube analysis failed!'
        }
        success {
            echo '✅ Build and SonarQube analysis successful!'
        }
    }
}
