######################################################
# Build remco from specific commit
######################################################
FROM golang AS remco

# remco (lightweight configuration management tool) https://github.com/HeavyHorst/remco
RUN go install github.com/HeavyHorst/remco/cmd/remco@latest
######################################################
# End remco from specific commit
######################################################

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
RUN apt -y install curl nano vim ca-certificates file lib32gcc-s1 software-properties-common yq
RUN apt-add-repository non-free
RUN apt -y update
RUN apt -y upgrade

## Create soulmask user and group
RUN groupadd -g $SOULMASK_GID soulmask
RUN useradd -l -s /bin/bash -d $SOULMASK_HOME -m -u $SOULMASK_UID -g $SOULMASK_GID soulmask
RUN passwd -d soulmask

## Install remco
COPY --from=remco /go/bin/remco /usr/local/bin/remco
COPY --chown=soulmask:root remco /etc/remco

RUN chmod -R 0775 /etc/remco
RUN curl -Lo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
RUN chmod guo+x /usr/local/bin/yq

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
ENV SOULMASK_STEAM_VALIDATE="false"
ENV REMCO_HOME=/etc/remco
ENV STEAMAPPID=3017300

WORKDIR ${SOULMASK_HOME}
VOLUME "${SOULMASK_HOME}/server"

# server ports
EXPOSE 8777/udp
EXPOSE 27015/udp
EXPOSE 18888/tcp

RUN mkdir -p /config

COPY --chown=soulmask:soulmask files/GameXishu.json /config/
RUN touch /config/GameXishu.json.yaml

USER soulmask

ENTRYPOINT ["./entrypoint.sh"]