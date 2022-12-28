FROM steamcmd/steamcmd:ubuntu-22

ENV STEAMCMD_APP_ID=896660
ENV SERVER_DIR=/opt/valheim
ENV HOME=/home/steam

# Install dependencies
RUN apt-get update &&\
    apt-get install -y curl wget tar &&\
    apt-get clean

# Add steam user
RUN useradd -m steam

RUN mkdir -p ${SERVER_DIR} &&\
    chown steam:root ${SERVER_DIR}

USER steam
# Install valheim server
RUN steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir "${SERVER_DIR}" +login anonymous +app_update ${STEAMCMD_APP_ID} validate +quit &&\
    chmod +x ${SERVER_DIR}/valheim_server.x86_64 &&\
    mkdir -p ${HOME}/.steam/sdk64 &&\
    ln -s ${HOME}/.local/share/Steam/steamcmd/linux64/steamclient.so ${HOME}/.steam/sdk64/steamclient.so

ADD valheim.sh ${SERVER_DIR}/valheim.sh

ENTRYPOINT ${SERVER_DIR}/valheim.sh
