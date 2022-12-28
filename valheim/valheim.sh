#!/bin/bash
export templdpath=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
export SteamAppId=892970

if [ -z "${SERVER_NAME}" ]; then
  echo "Missing SERVER_NAME env var";
  exit 1;
fi
if [ -z "${SERVER_WORLD}" ]; then
  echo "Missing SERVER_WORLD env var";
  exit 1;
fi

"${SERVER_DIR}/valheim_server.x86_64" -name "${SERVER_NAME}" -savedir "/opt/valheim/data" -port 2456 -nographics -batchmode -world "${SERVER_WORLD}" -password "${SERVER_PASSWORD}" -public 1