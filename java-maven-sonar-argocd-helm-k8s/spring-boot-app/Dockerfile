FROM adoptopenjdk/openjdk17:alpine-jre

ARG artifact=target/spring-boot-web.jar

WORKDIR /opt/app

COPY ${artifact} app.jar

# Remove ENTRYPOINT ❌
# ENTRYPOINT ["java","-jar","app.jar"]

CMD ["tail", "-f", "/dev/null"]
