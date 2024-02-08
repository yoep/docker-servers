FROM steamcmd/steamcmd:ubuntu-22

ENV STEAMCMD_APP_ID=361580
ENV SERVER_DIR=/opt/wreckfest
ENV HOME=/home/steam

# Install dependencies
RUN apt-get update &&\
    apt-get install -y x11vnc wget gnupg software-properties-common cabextract &&\
    apt-get clean

# Add tini
ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

# Install wine
RUN DEBIAN_FRONTEND=noninteractive \
    dpkg --add-architecture i386 &&\
    wget -qO - https://dl.winehq.org/wine-builds/winehq.key | apt-key add - &&\
    add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ jammy main' &&\
    apt-get update &&\
    apt-get install --install-recommends -y winehq-staging wine32 wine64 xvfb winbind &&\
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

# Install wreckfest server
RUN steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "${SERVER_DIR}" +login anonymous +app_update ${STEAMCMD_APP_ID} validate +quit &&\
    mkdir -p ${HOME}/.steam/sdk64 &&\
    ln -s ${HOME}/.local/share/Steam/steamcmd/linux64/steamclient.so ${HOME}/.steam/sdk64/steamclient.so

# Add startup script
ADD start.sh ${SERVER_DIR}/start.sh

WORKDIR ${SERVER_DIR}
ENTRYPOINT ["bash", "-c"]
CMD ["./start.sh"]