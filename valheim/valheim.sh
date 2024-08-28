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

echo "--- Switching working dir to ${SERVER_DIR} ---"
cd "${SERVER_DIR}"
"./start_server_bepinex.sh"