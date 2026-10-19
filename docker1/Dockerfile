FROM maven:3.9.9-eclipse-temurin-21 AS builder

WORKDIR /build
COPY pom.xml .
RUN mvn -B dependency:go-offline
COPY src ./src
RUN mvn -B package -DskipTests

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app
ENV SERVER_PORT=8080

RUN addgroup -S app && adduser -S app -G app
COPY --from=builder /build/target/app.jar app.jar

USER app
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
    CMD wget -q -O - http://127.0.0.1:8080/health || exit 1
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
