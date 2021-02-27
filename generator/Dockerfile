FROM openjdk:11.0.8-jre-slim

ARG JAR_FILE
COPY ${JAR_FILE} /tmp/app.jar

RUN useradd -ms /bin/bash tokenGenerator
USER tokenGenerator

ENTRYPOINT [ "java", "-jar", "/tmp/app.jar" ]