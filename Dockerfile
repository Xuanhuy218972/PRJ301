# Multi-stage build for Java web application
FROM maven:3.9-eclipse-temurin-17-alpine AS builder

WORKDIR /app

# Copy pom.xml first to cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage with Tomcat
FROM tomcat:10-jdk17

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file from builder stage
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Copy .env file (optional - better to use environment variables in docker-compose)
# COPY .env /usr/local/tomcat/.env

EXPOSE 8080

CMD ["catalina.sh", "run"]
