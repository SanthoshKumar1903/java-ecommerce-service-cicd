
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml ./

RUN ./mvnw dependency:go-offline -B

COPY src ./src

RUN ./mvnw package -DskipTests

FROM eclipse-temurin:21-jre-alpine

ENV JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=80.0"

RUN addgroup -S springboot && adduser -S springboot -G springboot
USER springboot

EXPOSE 8080

COPY --from=builder /app/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]