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
java -javaagent:log4jfix/Log4jPatcher-1.0.0.jar -XX:+UnlockExperimentalVMOptions -Xmx${JAVA_MEMORY_LIMIT}M -Xms${JAVA_MEMORY_REQUEST}M @user_jvm_args.txt @libraries/net/minecraftforge/forge/1.18.2-40.1.52/unix_args.txt nogui