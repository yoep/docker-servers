#!/bin/bash
# **************************
# EDIT CONFIG SETTINGS BELOW
# **************************
# Installation config
install_location=${INSTALL_LOCATION}
world_name=${WORLD_NAME}

log_location=${install_location}/config/logs/server-$(date +%s).log
cd ${WINE_LOCATION}/drive_c/users/${whoami}/Desktop/spaceengineers/DedicatedServer64
echo "Starting SpaceEngineersDedicated..."
echo "Check log ${log_location} for more info"
# Show the log in the console + log it immediately to a file
WINEPREFIX=${WINE_LOCATION} wine SpaceEngineersDedicated.exe -noconsole -ignorelastsession -checkAlive | tee ${log_location}
echo "Server has been stopped"