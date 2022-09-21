FROM openjdk:11-slim

ENV JAVA_MEMORY_LIMIT=6144
ENV JAVA_MEMORY_REQUEST=4096

WORKDIR /oceanblock

# Download the installer
RUN apt-get update && \
    apt-get install -y wget && \
    wget -O installer https://api.modpacks.ch/public/modpack/91/2242/server/linux && \
    chmod +x installer && \
    rm -rf /var/lib/apt/lists/*

# Run the installer
RUN ./installer 91 --latest --noscript --nojava --integrityupdate true --auto

# Add the server script
ADD start-server.sh .
RUN chmod +x start-server.sh

ENTRYPOINT ./start-server.sh