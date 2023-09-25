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
    apt-get install --install-recommends -y winehq-stable &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install the latest version of winetricks
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks &&\
    chmod +x winetricks &&\
    mv -v winetricks /usr/bin/

# Add the steam user
RUN useradd -m steam &&\
    mkdir -p ${INSTALL_LOCATION} &&\
    chown root:root ${INSTALL_LOCATION}

#USER steam
VOLUME ${HOME}/.steam

COPY space_engineers.sh ./
RUN mkdir -p ${HOME}/.steam/sdk64 &&\
    ln -s ${HOME}/.local/share/Steam/steamcmd/linux64/steamclient.so ${HOME}/.steam/sdk64/steamclient.so &&\
    ./space_engineers.sh setup

# Install wine dependencies
RUN Xvfb :1 -screen 0 1024x768x24 & DISPLAY=:1 WINEPREFIX="${WINE_LOCATION}" winetricks -q dotnet48 vcrun2013 vcrun2019

# Install Wine Mono
RUN wget https://dl.winehq.org/wine/wine-mono/7.4.0/wine-mono-7.4.0-x86.msi &&\
    WINEPREFIX="${WINE_LOCATION}" wine64 msiexec /i wine-mono-7.4.0-x86.msi &&\
    rm wine-mono-7.4.0-x86.msi

# Install the space engineers dedicated server
RUN dedicated_server_location="${WINE_LOCATION}/drive_c/users/$(whoami)/Desktop/spaceengineers" &&\
    steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "${dedicated_server_location}" +login anonymous +app_update 298740 -verify +quit || true

EXPOSE 8080
EXPOSE 8766
EXPOSE 27016

ENTRYPOINT ["bash", "-c"]
CMD ["xvfb-run ${HOME}/space_engineers.sh start"]