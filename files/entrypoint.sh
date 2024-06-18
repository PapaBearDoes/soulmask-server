#!/usr/bin/env bash

export LD_LIBRARY_PATH=/home/soulmask/server/linux64:/home/soulmask/server/linux32:/home/soulmask/server/steamcmd/linux64:/home/soulmask/server/steamcmd/linux32:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

echo ""
echo "#####################################"
date
echo "#####################################"

if [[ ! -z ${STEAM_VALIDATE} ]]; then
  if [[ ! "${STEAM_VALIDATE}" =~ true|false ]]; then
    echo '[ERROR] SOULMASK_STEAM_VALIDATE must be true or false'
    exit 1
  elif [[ "${STEAM_VALIDATE}" == true ]]; then
    STEAM_VALIDATE_VALUE="validate"
  else
    STEAM_VALIDATE_VALUE=""
  fi
fi

echo ""
echo "#####################################"
echo "Install/Update SoulmaskServer"
echo "#####################################"

cat <<EOF> ${SOULMASK_HOME}/server/soulmask.conf
@ShutdownOnFailedCommand 1
@NoPromptForPassword 1
@sSteamCmdForcePlatformType linux
force_install_dir ${SOULMASK_HOME}/server/
login anonymous
app_update ${STEAMAPPID} ${STEAM_VALIDATE_VALUE}
quit
EOF

cd ${SOULMASK_HOME}/server/
steamcmd/steamcmd.sh +runscript ${SOULMASK_HOME}/server/soulmask.conf

echo ""
echo "#####################################"
echo "starting server..."
echo "#####################################"
if [[ ! -z ${PVE} ]]; then
  if [[ ! "${PVE}" =~ true|false ]]; then
    echo '[ERROR] SOULMASK_PVE must be true or false'
    exit 1
  elif [[ "${PVE}" == true ]]; then
    PVE_VALUE="-pve"
  else
    PVE_VALUE=""
  fi
fi

echo ""
echo "#####################################"
echo "Servername = "${SERVERNAME}
echo "GamePort = "${PORT}
echo "QueryPort = "${QUERYPORT}
echo "EchoPort = "${ECHOPORT}
echo "MaxPlayers = "${MAXPLAYERS}
echo "Server Password = ********"
echo "Admin Password = ********"
echo ${PVE_VALUE}
echo "#####################################"
echo "Startup Script:"
echo "./StartServer.sh -SteamServerName="${SERVERNAME}" -Port="${PORT}" -QueryPort="${QUERYPORT}" -EchoPort="${ECHOPORT}" -MaxPlayers="${MAXPLAYERS}" -PSW=""********"" -adminpsw=""********"" "${PVE_VALUE}
echo "#####################################"
echo ""

./StartServer.sh -SteamServerName="${SERVERNAME}" -Port="${PORT}" -QueryPort="${QUERYPORT}" -EchoPort="${ECHOPORT}" -MaxPlayers="${MAXPLAYERS}" -PSW="${PSW}" -adminpsw="${ADMIN_PSW}" ${PVE_VALUE}