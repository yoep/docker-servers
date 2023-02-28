FROM steamcmd/steamcmd:ubuntu-22

ENV STEAMCMD_APP_ID=1690800
ENV SERVER_DIR=/opt/satisfactory
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

VOLUME ${HOME}/.steam
VOLUME ${HOME}/.config/Epic/FactoryGame

# Install the dedicated server
RUN steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir "${SERVER_DIR}" +login anonymous +app_update ${STEAMCMD_APP_ID} validate -beta public +quit &&\
  mkdir -p ${HOME}/.steam/sdk64 &&\
  ln -s ${HOME}/.local/share/Steam/steamcmd/linux64/steamclient.so ${HOME}/.steam/sdk64/steamclient.so

ENTRYPOINT ${SERVER_DIR}/FactoryServer.sh
CMD ["-unattended"]