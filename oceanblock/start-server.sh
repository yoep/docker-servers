#!/bin/bash

# Verify if the required env vars are present
if [[ -z "${JAVA_MEMORY_LIMIT}" ]]; then
  echo "Missing environment variable JAVA_MEMORY_LIMIT"
  exit 1;
fi
if [[ -z "${JAVA_MEMORY_REQUEST}" ]]; then
  echo "Missing environment variable JAVA_MEMORY_REQUEST"
  exit 1;
fi
if [[ ! -f "server.properties" ]]; then
  echo "Missing server.properties configuration"
  exit 1;
fi

echo "Auto agreement to the Mojang EULA available at https://account.mojang.com/documents/minecraft_eula"
echo "eula=true" > eula.txt
"java" -javaagent:log4jfix/Log4jPatcher-1.0.0.jar -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -Xmx6144M -Xms4096M -jar forge-1.16.5-36.2.39.jar nogui