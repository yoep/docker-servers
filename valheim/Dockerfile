FROM steamcmd/steamcmd:ubuntu-22 as mods

ENV SERVER_DIR=/opt/valheim

# Install dependencies
RUN apt-get update &&\
    apt-get install -y unzip &&\
    apt-get clean &&\
    mkdir -p ${SERVER_DIR}

# Install mod support
ADD denikson-BepInExPack_Valheim-5.4.2202.zip /tmp/BepInExPack.zip
RUN unzip /tmp/BepInExPack.zip -d /tmp &&\
    mv -v /tmp/BepInExPack_Valheim/* ${SERVER_DIR}/ &&\
    chmod +x ${SERVER_DIR}/start_server_bepinex.sh &&\
    ls -l ${SERVER_DIR}

FROM steamcmd/steamcmd:ubuntu-22

ENV STEAMCMD_APP_ID=896660
ENV SERVER_DIR=/opt/valheim
ENV HOME=/home/steam

# Install dependencies
RUN apt-get update &&\
    apt-get install -y curl wget tar &&\
    apt-get clean

# Add steam user & prepare server directory
RUN useradd -m steam
RUN mkdir -p ${SERVER_DIR}

# Install valheim server
RUN steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir "${SERVER_DIR}" +login anonymous +app_update ${STEAMCMD_APP_ID} validate +quit &&\
    chmod +x ${SERVER_DIR}/valheim_server.x86_64 &&\
    mkdir -p ${HOME}/.steam/sdk64 &&\
    ln -s ${HOME}/.local/share/Steam/steamcmd/linux64/steamclient.so ${HOME}/.steam/sdk64/steamclient.so
ADD valheim.sh ${SERVER_DIR}/valheim.sh

# Install mods
COPY --from=mods ${SERVER_DIR}/ ${SERVER_DIR}/
RUN chown -R steam:root ${SERVER_DIR} &&\
    chmod +x ${SERVER_DIR}/valheim_server.x86_64 &&\
    ls -la ${SERVER_DIR}

# Overwrite the startup script
RUN sed -i "$ d" ${SERVER_DIR}/start_server_bepinex.sh &&\
    echo "exec ./valheim_server.x86_64 -name \"\${SERVER_NAME}\" -savedir \"/opt/valheim/data\" -port 2456 -nographics -batchmode -world \"\${SERVER_WORLD}\" -password \"\${SERVER_PASSWORD}\" -public 1" >> ${SERVER_DIR}/start_server_bepinex.sh

USER steam
ENTRYPOINT ${SERVER_DIR}/valheim.sh
