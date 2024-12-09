# Stage 1: Resolve and download dependencies
FROM eclipse-temurin:17-jdk-jammy as deps

WORKDIR /build

# Copy the mvnw wrapper and .mvn folder with executable permissions
COPY --chmod=0755 mvnw mvnw
COPY .mvn/ .mvn/

# Copy the entire project, including the modules (server, webapp)
COPY . .

# Download dependencies as a separate step to leverage Docker cache
RUN --mount=type=cache,target=/root/.m2 ./mvnw dependency:go-offline -DskipTests

################################################################################

# Stage 2: Build the application
FROM deps as package

WORKDIR /build

# Build the application
RUN --mount=type=cache,target=/root/.m2 ./mvnw package -DskipTests && \
    mv target/$(./mvnw help:evaluate -Dexpression=project.artifactId -q -DforceStdout)-$(./mvnw help:evaluate -Dexpression=project.version -q -DforceStdout).jar target/app.jar

################################################################################

# Stage 3: Runtime environment for the app
FROM eclipse-temurin:17-jre-jammy AS final

# Create a non-privileged user to run the app
ARG UID=10001
RUN adduser --disabled-password --gecos "" --home "/nonexistent" --shell "/sbin/nologin" --no-create-home --uid "${UID}" appuser
USER appuser

# Copy the executable JAR from the package stage
COPY --from=package /build/target/app.jar /app.jar

# Expose port for the application (optional)
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "/app.jar"]

