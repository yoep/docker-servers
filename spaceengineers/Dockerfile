FROM steamcmd/steamcmd:ubuntu-22

ENV INSTALL_LOCATION=/opt/space_engineers
ENV WINE_LOCATION=${INSTALL_LOCATION}/.wine64
ENV WORLD_NAME=CelestialFrontier

RUN apt-get update &&\
    apt-get install -y wine winetricks cabextract winbind wget xvfb

RUN useradd -m steam
RUN mkdir -p ${INSTALL_LOCATION} &&\
    chown $(whoami):root ${INSTALL_LOCATION}

#USER steam
VOLUME ${HOME}/.steam

COPY space_engineers.sh ./
RUN mkdir -p ${HOME}/.steam/sdk64 &&\
    ln -s ${HOME}/.local/share/Steam/steamcmd/linux64/steamclient.so ${HOME}/.steam/sdk64/steamclient.so &&\
    ./space_engineers.sh setup

# Install the space engineers dedicated server
RUN steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir ${WINE_LOCATION}/drive_c/users/$(whoami)/Desktop/spaceengineers +login anonymous +app_update 298740 -verify +quit

ENTRYPOINT ["bash", "-c"]
CMD ["xvfb-run ${HOME}/space_engineers.sh start"]