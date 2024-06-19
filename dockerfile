######################################################
# Build Soulmask base
######################################################
FROM debian:bookworm-slim AS soulmask
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV HOME=/soulmaskserver
ENV PUID=10000
ENV PGID=10000
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

USER root

## Install system packages
RUN apt -y update
RUN apt -y upgrade
RUN apt -y --no-install-recommends install curl nano ca-certificates file lib32gcc-s1
RUN dpkg --add-architecture i386

##Create Directories
RUN mkdir -p ${HOME}/config/steamcmd
RUN mkdir -p /steamcmd

## Create soulmask user and group
RUN groupadd -g ${PGID} soulmask
RUN useradd -l -s /bin/bash -d ${HOME} -m -u ${PUID} -g ${PGID} soulmask
RUN passwd -d soulmask

## Install SteamCMD
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C /steamcmd/
RUN chmod ugo+x /steamcmd/steamcmd.sh
RUN chown -Rv soulmask:soulmask /steamcmd

## Update permissions
RUN chown -Rv ${PUID}:${PGID} ${HOME}/
COPY --chown=${PUID}:${PGID} --chmod=775 files/entrypoint.sh ${HOME}/

WORKDIR ${HOME}
VOLUME ${HOME}

# server ports
EXPOSE 8777/udp
EXPOSE 27015/udp
EXPOSE 18888/tcp

USER soulmask

ENTRYPOINT ["./entrypoint.sh"]