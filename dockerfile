######################################################
# Build Soulmask base
######################################################
FROM debian:bookworm-slim AS soulmask-base
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV SOULMASK_HOME=/home/soulmask
ENV SOULMASK_UID=10000
ENV SOULMASK_GID=10000

USER root

## Install system packages
RUN dpkg --add-architecture i386
RUN apt -y update
RUN apt -y upgrade
RUN apt -y --no-install-recommends install curl nano ca-certificates file lib32gcc-s1 software-properties-common

## Create soulmask user and group
RUN groupadd -g $SOULMASK_GID soulmask
RUN useradd -l -s /bin/bash -d $SOULMASK_HOME -m -u $SOULMASK_UID -g $SOULMASK_GID soulmask
RUN passwd -d soulmask

## Install SteamCMD
RUN mkdir -p ${SOULMASK_HOME}/server/steamcmd
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C ${SOULMASK_HOME}/server/steamcmd/
RUN chmod ugo+x ${SOULMASK_HOME}/server/steamcmd/steamcmd.sh

## Update permissions
COPY --chown=soulmask:soulmask files/entrypoint.sh ${SOULMASK_HOME}/
RUN chmod ugo+x ${SOULMASK_HOME}/entrypoint.sh
RUN chown -Rv soulmask:soulmask ${SOULMASK_HOME}/
######################################################
# End Soulmask Base
######################################################

######################################################
# Build Soulmask image
######################################################
FROM soulmask-base as soulmask

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV SOULMASK_HOME=/home/soulmask
ENV STEAM_VALIDATE="false"
ENV STEAMAPPID=3017300
ENV SERVERNAME="SoulmaskDedicatedServer"
ENV PORT="8777"
ENV QUERYPORT="27015"
ENV ECHOPORT="18888"
ENV MAXPLAYERS="50"
ENV PSW=""
ENV ADMIN_PSW=""
ENV PVE="true"

WORKDIR ${SOULMASK_HOME}
VOLUME "${SOULMASK_HOME}/server"

# server ports
EXPOSE 8777/udp
EXPOSE 27015/udp
EXPOSE 18888/tcp

#RUN mkdir -p /config

USER soulmask

ENTRYPOINT ["./entrypoint.sh"]