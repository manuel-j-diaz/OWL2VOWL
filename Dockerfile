FROM maven:3.8.8-eclipse-temurin-8 AS build

WORKDIR /var/lib/owl2vowl
ADD pom.xml .
RUN mvn dependency:go-offline -B -P war-release 2>/dev/null || true

ADD src src
RUN mvn package -DskipTests -B -P war-release


FROM amazoncorretto:8-alpine

WORKDIR /owl2vowl
COPY --from=build /var/lib/owl2vowl/target/owl2vowl.war .
CMD ["java", "-jar", "owl2vowl.war"]

EXPOSE 8080