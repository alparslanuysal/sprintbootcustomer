#Build stage
FROM maven:3-eclipse-temurin-11 as build

WORKDIR /workspace/app

COPY pom.xml .
COPY src src

RUN mvn clean install
RUN mkdir target/extracted
RUN java -Djarmode=layertools -jar target/*.jar extract --destination target/extracted

#Runtime stage
FROM eclipse-temurin:11-jdk-alpine

ARG EXTRACTED=/workspace/app/target/extracted

COPY --from=build ${EXTRACTED}/dependencies/ ./
COPY --from=build ${EXTRACTED}/spring-boot-loader/ ./
COPY --from=build ${EXTRACTED}/snapshot-dependencies/ ./
COPY --from=build ${EXTRACTED}/application/ ./

# Copy test reports from the build stage
COPY --from=build /workspace/test-reports /workspace/test-reports

# Define an entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Define a default command to run the entrypoint script
CMD ["/bin/sh", "/entrypoint.sh"]