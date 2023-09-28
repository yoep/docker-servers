FROM steamcmd/steamcmd:ubuntu-22

ENV INSTALL_LOCATION=/opt/space_engineers
ENV WINE_LOCATION=${INSTALL_LOCATION}/.wine64
ENV WORLD_NAME=CelestialFrontier

# Install dependencies
RUN apt-get update &&\
    apt-get install -y cabextract winbind wget xvfb libgl1-mesa-dri &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install the latest version of wine
RUN wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key &&\
    wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources &&\
    apt-get update &&\
    apt-get install --install-recommends -y winehq-stable wine-stable-i386 wine-stable-amd64 wine-stable &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install the latest version of winetricks
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks &&\
    chmod +x winetricks &&\
    mv -v winetricks /usr/bin/

# Add the steam user
RUN useradd -m steam

#USER steam
VOLUME ${HOME}/.steam

COPY start_server.sh ./
RUN mkdir -p ${HOME}/.steam/sdk64 &&\
    ln -s ${HOME}/.local/share/Steam/steamcmd/linux64/steamclient.so ${HOME}/.steam/sdk64/steamclient.so

# Install the wine prefix
RUN mkdir -p ${INSTALL_LOCATION} &&\
    chown root:root ${INSTALL_LOCATION} &&\
    WINEDEBUG=-all WINEPREFIX=${WINE_LOCATION} WINEARCH=win64 WINEDLLOVERRIDES="mscoree=d" wineboot --init /nogui &&\
    WINEDEBUG=-all WINEPREFIX=${WINE_LOCATION} WINEARCH=win64 winecfg /v win10 &&\
    mkdir -p ${WINE_LOCATION}/drive_c/users/$(whoami)/Application\ Data &&\
    ln -s ${INSTALL_LOCATION} ${WINE_LOCATION}/drive_c/users/$(whoami)/Desktop/spaceengineers &&\
    ln -s ${INSTALL_LOCATION}/config ${WINE_LOCATION}/drive_c/users/$(whoami)/Application\ Data/SpaceEngineersDedicated

# Install wine dependencies
COPY winetricks.sh ./
RUN chmod +x winetricks.sh && ./winetricks.sh

# Install the space engineers dedicated server
RUN dedicated_server_location="${WINE_LOCATION}/drive_c/users/$(whoami)/Desktop/spaceengineers" &&\
    steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "${dedicated_server_location}" +login anonymous +app_update 298740 -verify +quit || true

EXPOSE 8080
EXPOSE 8766
EXPOSE 27016

ENTRYPOINT ["${HOME}/start_server.sh"]