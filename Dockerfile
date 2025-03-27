# Use Maven with JDK 17 for building the project
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app

# Copy the Maven project files
COPY pom.xml .
COPY src ./src

# Build the project
RUN mvn clean install

# Use a smaller JDK runtime for production
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy built JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port 2000
EXPOSE 2000

# Run the application using Java directly (not Maven)
CMD ["java", "-jar", "app.jar"]
