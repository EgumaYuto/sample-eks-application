FROM openjdk:11.0-jre-slim-buster

COPY build/libs/demo-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]