# Use Maven with JDK 17 for building the project
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app

# Copy pom.xml and download dependencies first (caches dependencies)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code
COPY src ./src

# Build the project
RUN mvn clean install -DskipTests

# Use a smaller JDK runtime for production
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port you are using
EXPOSE 2000

# Run the application
CMD ["java", "-jar", "app.jar"]
