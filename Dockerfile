FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /build

COPY .mvn .mvn
COPY mvnw ./
COPY pom.xml ./
RUN ./mvnw dependency:go-offline -B -P war-release 2>/dev/null || true

COPY src ./src
RUN ./mvnw package -DskipTests -B -P war-release

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

COPY --from=builder /build/target/owl2vowl.war owl2vowl.war

EXPOSE 8080
CMD ["java", "-jar", "owl2vowl.war"]
