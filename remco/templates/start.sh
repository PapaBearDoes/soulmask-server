SERVERNAME='{{ getv("/soulmask/servername", "SoulmaskDedicatedServer") }}'
PORT='{{ getv("/soulmask/port", "8777") }}'
QUERYPORT='{{ getv("/soulmask/queryport", "27015") }}'
ECHOPORT='{{ getv("/soulmask/echoport", "18888") }}'
MAXPLAYERS='{{ getv("/soulmask/maxplayers", "50") }}'
PSW='{{ getv("/soulmask/password", "") }}'
ADMINPSW='{{ getv("/soulmask/admin/password", "Secret123") }}'
PVE='{% if getv("/soulmask/pve", "false")|lower == "true" %}-pve{% endif %}'

echo ""
echo "#####################################"
echo "Servername = "${SERVERNAME}
echo "GamePort = "${PORT}
echo "QueryPort = "${QUERYPORT}
echo "EchoPort = "${ECHOPORT}
echo "MaxPlayers ="${MAXPLAYERS}
echo "Server Password = ********"
echo "Admin Password = ********"
echo ${PVE}
echo "#####################################"
echo ""

./StartServer.sh -SteamServerName="${SERVERNAME}" -Port="${PORT}" -QueryPort="${QUERYPORT}" -EchoPort="${ECHOPORT}" -MaxPlayers="${MAXPLAYERS}" -PSW="${PSW}" -adminpsw="${ADMINPSW}" ${PVE}