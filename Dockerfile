# Stage 1: Build the application using a Maven image
# Using 'maven:3.9.6-eclipse-temurin-17' (A stable, modern tag)
FROM maven:3.9.6-eclipse-temurin-17 AS MAVEN_BUILD
COPY pom.xml .
COPY src ./src/
# Package the application into a JAR file
RUN mvn clean package -DskipTests

# Stage 2: Create the final production image
# Using 'eclipse-temurin:17-jdk-focal' (A small, stable production image)
FROM eclipse-temurin:17-jdk-focal
# Expose the port Spring Boot runs on by default
EXPOSE 8080
# Copy the built JAR from the MAVEN_BUILD stage
COPY --from=MAVEN_BUILD /target/cicd-demo-*.jar app.jar
# Command to run the application
ENTRYPOINT ["java","-jar","/app.jar"]