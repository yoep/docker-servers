FROM steamcmd/steamcmd:ubuntu-24

ENV STEAMCMD_APP_ID=728470
ENV HOME=/home/steam
ENV SERVER_DIR=/opt/astroneer

# Install dependencies
RUN apt-get update &&\
    apt-get install -y wget software-properties-common cabextract pulseaudio alsa-utils flatpak &&\
    apt-get clean

# Install wine
RUN DEBIAN_FRONTEND=noninteractive \
    dpkg --add-architecture i386 &&\
    wget -O - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key - &&\
    wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/noble/winehq-noble.sources &&\
    apt-get update &&\
    apt-get install --install-recommends -y winehq-staging wine32 wine64 winbind &&\
    apt-get clean

# Install winetricks
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks &&\
    chmod +x winetricks &&\
    mv winetricks /usr/bin/

# Add steam user
RUN useradd -m steam

RUN mkdir -p ${SERVER_DIR} &&\
    chown steam:root ${SERVER_DIR}

USER steam

# Install proton
RUN flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &&\
    flatpak install -y com.valvesoftware.Steam.CompatibilityTool.Proton-GE

# Install the dedicated server
RUN steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "${SERVER_DIR}" +login anonymous +app_update ${STEAMCMD_APP_ID} validate +quit &&\
    mkdir -p ${HOME}/.steam/sdk64 &&\
    ln -s ${HOME}/.local/share/Steam/steamcmd/linux64/steamclient.so ${HOME}/.steam/sdk64/steamclient.so

ENV WINEPREFIX=${HOME}/.astroneer

# Setup wine
RUN wineboot --init &&\
    winetricks sound=pulse

ENTRYPOINT ["/var/lib/flatpak/runtime/com.valvesoftware.Steam.CompatibilityTool.Proton-GE/x86_64/stable/active/files/proton", "run", "/opt/astroneer/AstroServer.exe"]