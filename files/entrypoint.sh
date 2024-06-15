#!/bin/bash

export REMCO_RESOURCE_DIR=${REMCO_HOME}/resources.d
export REMCO_TEMPLATE_DIR=${REMCO_HOME}/templates
export LD_LIBRARY_PATH=/home/soulmask/server/linux64:/home/soulmask/server/linux32:/home/soulmask/server/steamcmd/linux64:/home/soulmask/server/steamcmd/linux32:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
export HOME=${SOULMASK_HOME}

echo "#####################################"
date
echo ""

chown -Rv soulmask:soulmask ${SOULMASK_HOME}

if [[ ! -z $SOULMASK_STEAM_VALIDATE ]]; then
  if [[ ! "$SOULMASK_STEAM_VALIDATE" =~ true|false ]]; then
    echo '[ERROR] SOULMASK_STEAM_VALIDATE must be true or false'
    exit 1
  elif [[ "$SOULMASK_STEAM_VALIDATE" == true ]]; then
    SOULMASK_STEAM_VALIDATE_VALUE="validate"
  else
    SOULMASK_STEAM_VALIDATE_VALUE=""
  fi
fi

## Install SteamCMD
mkdir -p ${SOULMASK_HOME}/server/steamcmd
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C ${SOULMASK_HOME}/server/steamcmd/
chmod ugo+x ${SOULMASK_HOME}/server/steamcmd/steamcmd.sh

cat <<EOF> ${SOULMASK_HOME}/server/soulmask.conf
@ShutdownOnFailedCommand 1
@NoPromptForPassword 1
@sSteamCmdForcePlatformType linux
force_install_dir ${SOULMASK_HOME}/server/
login anonymous
app_update ${STEAMAPPID} ${SOULMASK_STEAM_VALIDATE_VALUE}
quit
EOF

cd ${SOULMASK_HOME}/server/
steamcmd/steamcmd.sh +runscript ${SOULMASK_HOME}/server/soulmask.conf

echo
echo "#####################################"
echo Generating configs...
echo
remco
yq -n "load(\"/config/GameXishu.json\") * load(\"/config/GameXishu.json.yaml\")" -o json | tee ${SOULMASK_HOME}/server/WS/Saved/GameplaySettings/GameXishu.json

echo
echo "#####################################"
echo starting server...
echo

./start.sh