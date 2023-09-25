#!/bin/bash
# **************************
# EDIT CONFIG SETTINGS BELOW
# **************************
# Installation config
install_location=${INSTALL_LOCATION}
world_name=${WORLD_NAME}
# Wine config
wine_location=${WINE_LOCATION}
# Screen config
screen_name=space_engineers

# ***************************
# DO NOT EDIT BELOW THIS LINE
# ***************************
procname=SpaceEngineersDedicated.exe
whoami=$(whoami)

create_install_dir() {
  if [[ ! -d "${install_location}" ]]; then
    echo "Creating installation directory ${install_location}..."
    sudo mkdir ${install_location}
    sudo chown -R ${whoami} ${install_location}
    echo "Done creating installation directory"
  fi
}

create_dir() {
  local dir=$1
  if [[ ! -d "${dir}" ]]; then
    echo "Creating directory ${dir}..."
    mkdir ${dir}
  fi
}

install_dependency() {
  WINEPREFIX=${wine_location} winetricks -q $0 &>/dev/null &
  show_spinner "Installing $1" $!
}

is_winetricks_version_ok() {
  winetricks_version=$(get_winetricks_version)
  echo "Found winetricks version ${winetricks_version}"

  if [[ ${winetricks_version} -ge 20190912 ]]; then
    return 0
  fi

  return 1
}

get_wine_version() {
  local wine_version=$(wine64 --version)
  echo "${wine_version//wine-/}"
}

get_winetricks_version() {
  local winetricks_version=$(winetricks --version)
  echo "${winetricks_version:0:8}"
}

show_spinner() {
  spin='-\|/'
  i=0
  while kill -0 $2 2>/dev/null; do
    i=$(((i + 1) % 4))
    printf "\r$1 ${spin:$i:1}"
    sleep .1
  done

  echo -en "\r$1 done"
  echo ""
}

case "$1" in
start)
  #start the DS
  log_location=${install_location}/config/logs/server-$(date +%s).log
  cd ${wine_location}/drive_c/users/${whoami}/Desktop/spaceengineers/DedicatedServer64
  echo "Starting SpaceEngineersDedicated..."
  echo "Check log ${log_location} for more info"
  # Show the log in the console + log it immediately to a file
  WINEPREFIX=${wine_location} wine64 SpaceEngineersDedicated.exe -noconsole -ignorelastsession -checkAlive | tee ${log_location}
  echo "Server has been stopped"
  ;;
setup) #run only once.
  if [[ -z "${world_name}" ]]; then
    echo "WORLD_NAME is required";
    exit 1;
  fi

  # Create installation directory
  create_install_dir

  #grab steamcmd and make some directories
  create_dir ${install_location}/config
  create_dir ${install_location}/client
  create_dir ${install_location}/config/backups
  create_dir ${install_location}/config/logs
  create_dir ${install_location}/config/Saves

  #configure our wine directory
  cd ${install_location}
  echo "Configuring WINE and installing dependencies..."
  WINEDEBUG=-all WINEPREFIX=${wine_location} WINEARCH=win64 winecfg &>/dev/null &
  show_spinner "Configuring WINE" $!
  #install dependencies
  install_dependency msxml4 "MSXML4"
  install_dependency vcrun2013 "Visual 2013 C++"
  install_dependency vcrun2017 "Visual 2017 C++"
  install_dependency corefonts "COREFONTS"
  install_dependency faudio "FAUDIO"
  # The IP binding seems to go wrong sometimes with the default installed winhttp lib from wine
  install_dependency winhttp "WINHTTP"
  ln -s ${install_location} ${wine_location}/drive_c/users/${whoami}/Desktop/spaceengineers
  ln -s ${install_location}/config ${wine_location}/drive_c/users/${whoami}/Application\ Data/SpaceEngineersDedicated
  echo "Initial setup complete"

  #install and update steamcmd
  echo "Installing and updating SteamCMD"
  #run twice because the first time we need to make steamcmd download its files before attempting a login
  steamcmd +exit
  steamcmd +@sSteamCmdForcePlatformType windows +login anonymous +exit
  echo ""
  echo "Setup complete. Please place your server's .cfg file in ${install_location}/config/SpaceEngineers-Dedicated.cfg.
  You'll need to edit it and change the <LoadWorld /> part to read: <LoadWorld>C:\users\\${whoami}\Application Data\SpaceEngineersDedicated\Saves\\${world_name}</LoadWorld>."
  ;;
backupworld) #put an entry in your crontab pointing to this script with the first argument being 'backupworld'.
  logstampworld=$(date +%s)
  cd ${install_location}/config
  cp -rf Saves/${world_name} backups/world-$logstampworld
  ;;
*)
  if ps ax | grep -v grep | grep $procname >/dev/null; then
    echo "$screen_name is running, not starting"
    exit
  else
    if [[ ! -f ${install_location} ]]; then
      echo "Space Engineers Dedicated Server is not installed"
      exit 1
    fi

    echo "$screen_name is not running, starting"
    screen -dmS ${screen_name} -t ${screen_name} $0 start
  fi
  ;;
esac