FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN mvn -B -ntp clean package

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --system app \
    && useradd --system --gid app app
COPY --from=build --chown=app:app /build/target/task-manager-1.0.0.jar app.jar
USER app
EXPOSE 8080
HEALTHCHECK --interval=10s --timeout=3s --start-period=30s --retries=6 \
    CMD curl --fail --silent http://localhost:8080/ > /dev/null || exit 1
ENTRYPOINT ["java", "-jar", "app.jar"]
