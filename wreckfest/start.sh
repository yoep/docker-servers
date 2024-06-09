#!/bin/bash

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

winetricks -q win10
winetricks winhttp

sleep 5
WINEDEBUG=+warn,+fixme,+err wine Wreckfest.exe -s server_config=${CONFIG_FILE_LOCATION}