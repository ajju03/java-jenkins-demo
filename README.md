# 🚀 Java Jenkins CI/CD Pipeline with SonarQube and Docker

This repository demonstrates a complete **Continuous Integration and Continuous Deployment (CI/CD)** workflow using **Jenkins**, **SonarQube**, and **Docker** for a simple Java application.

The pipeline automates:
1. 🧩 **Code Checkout** from GitHub  
2. 🔧 **Build** with Maven  
3. 🧠 **Code Quality Analysis** using SonarQube  
4. 🐳 **Docker Image Build & Push** to DockerHub  
5. 🚀 **Local Deployment** of the containerized application  

---

## 🧱 Project Overview

This project shows how DevOps tools integrate together to automate a typical development workflow.

- **Source Code Management**: GitHub  
- **Continuous Integration**: Jenkins  
- **Code Quality**: SonarQube  
- **Containerization**: Docker  
- **Registry**: DockerHub  
- **Deployment**: Local Docker environment  

---

## ⚙️ Tools & Technologies Used

| Tool | Purpose |
|------|----------|
| **Jenkins** | Automate CI/CD pipeline |
| **Maven** | Build and package Java application |
| **SonarQube** | Static code analysis |
| **Docker** | Containerize and deploy the app |
| **DockerHub** | Host Docker images |
| **GitHub** | Source code repository |
| **AWS EC2** | Host SonarQube server |
| **JDK 17 / 21** | Java runtime and compiler |

---

## 🧩 Project Structure

```plaintext
java-jenkins-demo/
├── src/
│   └── main/
│       └── java/
│           └── App.java
├── target/
│   └── demo-1.0-SNAPSHOT.jar
├── pom.xml
├── Dockerfile
└── Jenkinsfile



---

## 💻 Application Code

### `App.java`
```java
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import com.sun.net.httpserver.HttpServer;

public class App {
    public static void main(String[] args) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress(8080), 0);
        server.createContext("/", exchange -> {
            String response = "Hello, Jenkins CI/CD World!";
            exchange.sendResponseHeaders(200, response.length());
            try (OutputStream os = exchange.getResponseBody()) {
                os.write(response.getBytes());
            }
        });
        server.start();
        System.out.println("🚀 Server running on port 8080...");
    }
}
```

🐳 Docker Configuration
Dockerfile
```
FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY target/demo-1.0-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

Build the image:
```
docker build -t ajayprasannaa/java-jenkins-demo:latest .
```

Run the container:
```
docker run -d -p 8081:8080 ajayprasannaa/java-jenkins-demo:latest
```

Access the app:
👉 http://localhost:8081

🧩 Jenkinsfile (Declarative Pipeline)
```
pipeline {
    agent any

    tools {
        jdk 'JDK21'
        maven 'Maven3'
    }

    environment {
        SONARQUBE_ENV = 'Sonarqube'
        SONAR_TOKEN = credentials('sonarqubetoken')
        DOCKER_IMAGE = 'ajayprasannaa/java-jenkins-demo:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                echo '📦 Checking out code from GitHub...'
                git 'https://github.com/ajju03/java-jenkins-demo.git'
            }
        }

        stage('Build') {
            steps {
                echo '🔧 Building Java project...'
                bat 'mvn clean install -Dmaven.compiler.source=17 -Dmaven.compiler.target=17'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo '🧩 Running SonarQube analysis...'
                withSonarQubeEnv('Sonarqube') {
                    bat '''
                        mvn sonar:sonar ^
                        -Dsonar.projectKey=Week12-project ^
                        -Dsonar.projectName=Week12-Project ^
                        -Dsonar.host.url=http://13.202.94.241:9000 ^
                        -Dsonar.sources=src/main/java ^
                        -Dsonar.token=%SONAR_TOKEN%
                    '''
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
                echo '⤴️ Pushing image to DockerHub...'
                withCredentials([usernamePassword(credentialsId: 'DOCKERHUB_CREDENTIALS', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat '''
                        docker login -u %DOCKER_USER% -p %DOCKER_PASS%
                        docker push %DOCKER_IMAGE%
                    '''
                }
            }
        }

        stage('Local Deploy') {
            steps {
                echo '🚀 Deploying container locally...'
                bat '''
                    docker stop java-demo || echo "No existing container to stop"
                    docker rm java-demo || echo "No existing container to remove"
                    docker run -d --name java-demo -p 8081:8080 %DOCKER_IMAGE%
                '''
            }
        }
    }

    post {
        success { echo '✅ Pipeline executed successfully!' }
        failure { echo '❌ Pipeline failed — check logs for the failed stage.' }
    }
}
```

## 🧪 How to Run the Project Locally

Clone this repository:
```
git clone https://github.com/ajju03/java-jenkins-demo.git
cd java-jenkins-demo
```

Build using Maven:
```
mvn clean package
```

Test locally:
```
java -jar target/demo-1.0-SNAPSHOT.jar
```

Build Docker image:
```
docker build -t ajayprasannaa/java-jenkins-demo:latest .
```

Run Docker container:
```
docker run -d -p 8081:8080 ajayprasannaa/java-jenkins-demo:latest
```

Access the app:
👉 http://localhost:8081


📦 DockerHub Repository

👉 DockerHub: ajayprasannaa/java-jenkins-demo

## 👨‍💻 Author

Ajay Prasanna
DevOps Learner | Automation Enthusiast
📧 ajayprasanna7@gmail.com

## 🏁 Conclusion

This project demonstrates the complete DevOps lifecycle — automating the process from code commit to deployment using modern CI/CD tools.
It shows practical understanding of build automation, code quality analysis, containerization, and pipeline orchestration.
