# Stage 1: Build the application using a Maven image
FROM maven:3.8.7-jdk-17 AS MAVEN_BUILD
COPY pom.xml .
COPY src ./src/
# Package the application into a JAR file
RUN mvn clean package -DskipTests

# Stage 2: Create the final production image
# Use a smaller base image for production to reduce image size
FROM openjdk:17-jdk-slim
# Expose the port Spring Boot runs on by default
EXPOSE 8080
# Copy the built JAR from the MAVEN_BUILD stage
COPY --from=MAVEN_BUILD /target/cicd-demo-*.jar app.jar
# Command to run the application
ENTRYPOINT ["java","-jar","/app.jar"]