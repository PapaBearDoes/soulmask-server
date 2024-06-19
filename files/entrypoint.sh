#!/usr/bin/env bash

export LD_LIBRARY_PATH=/soulmaskserver/config/linux64:/soulmaskserver/config/linux32:/soulmaskserver/config/steamcmd/linux64:/soulmaskserver/config/steamcmd/linux32:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

echo ""
echo "#####################################"
date
echo "#####################################"

echo ""
echo "#####################################"
echo "Install/Update SoulmaskServer"
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

/usr/games/steamcmd \
+@ShutdownOnFailedCommand 1 \
+@NoPromptForPassword 1 \
+@sSteamCmdForcePlatformType linux \
+force_install_dir ${HOME}/config \
+login anonymous \
+app_update ${STEAMAPPID} ${STEAM_VALIDATE_VALUE} \
+quit

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

cd ${HOME}/config/

./StartServer.sh -SteamServerName="${SERVERNAME}" -Port="${PORT}" -QueryPort="${QUERYPORT}" -EchoPort="${ECHOPORT}" -MaxPlayers="${MAXPLAYERS}" -PSW="${PSW}" -adminpsw="${ADMIN_PSW}" ${PVE_VALUE}