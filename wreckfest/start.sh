#!/bin/bash

export WINEARCH=win32
export WINEPREFIX=${HOME}/.wreckfest
export CONFIG_FILE=server_config.cfg
export CONFIG_FILE_LOCATION="${SERVER_DIR}/config/${CONFIG_FILE}"

if [[ ! -e ${CONFIG_FILE_LOCATION} ]]; then
  echo "Copying config file ${CONFIG_FILE} to ${CONFIG_FILE_LOCATION}";
  cp -v ${CONFIG_FILE} ${CONFIG_FILE_LOCATION};
  echo "Config file has been created, configure the configuration before starting the server again";
  exit 0;
else
  echo "Using existing config file";
fi

if [[ ! -r ${CONFIG_FILE_LOCATION} ]]; then
  echo "Insufficient permission for config file ${CONFIG_FILE_LOCATION}" >&2;
  exit 1;
fi

sleep 5
WINEDEBUG=+all wine Wreckfest.exe -s server_config=${CONFIG_FILE_LOCATION}