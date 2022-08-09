FROM azul/zulu-openjdk-debian:8u332-8.62.0.19
ADD /target/*.jar /hello-world.jar
ADD /run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 8080
WORKDIR /

ENTRYPOINT [ "./run.sh" ]