FROM maven:3.6.3-jdk-8 as build

RUN apt-get update && apt-get upgrade -y && apt-get install -y wget

WORKDIR /graphhopper

COPY . .

RUN mvn clean install

FROM openjdk:11.0-jre

RUN apt-get update && apt-get upgrade -y

ENV JAVA_OPTS="-server -Xmx8g -Xms8g -XX:+UseG1GC -Ddw.server.application_connectors[0].bind_host=0.0.0.0 -Ddw.server.application_connectors[0].port=8989"

RUN mkdir -p /data

WORKDIR /graphhopper

COPY --from=build /graphhopper/web/target/*.jar ./web/target/
# pom.xml is used to get the jar file version. see https://github.com/graphhopper/graphhopper/pull/1990#discussion_r409438806
COPY ./config.yml ./

COPY ./graphhopper.sh ./

VOLUME [ "/data" ]

EXPOSE 8989

HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:8989/health || exit 1

ENTRYPOINT [ "./graphhopper.sh", "-c"  "config.yml"]
