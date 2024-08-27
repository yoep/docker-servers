FROM openjdk:22-slim

ENV JAVA_MEMORY_LIMIT=6144
ENV JAVA_MEMORY_REQUEST=4096
ENV SERVER_FILE_URI="https://mediafilez.forgecdn.net/files/5666/880/Server-Files-0.40.zip"

WORKDIR /atm10

# Download the server files & extract
RUN apt-get update &&\
    apt-get install -y wget unzip &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    wget -O atm10.zip "${SERVER_FILE_URI}" &&\
    chmod +x startserver.sh &&\
    unzip atm10.zip &&\
    rm -f atm10.zip

# Write the EULA
RUN echo "true" > eula.txt

ENTRYPOINT ./startserver.sh