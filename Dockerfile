# Use the official Eclipse Temurin (OpenJDK 17) image
FROM eclipse-temurin:17-jdk

# Set working directory inside the container
WORKDIR /app

# Copy jar file
COPY target/demo-1.0-SNAPSHOT.jar app.jar

# Expose the port the app runs on
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]