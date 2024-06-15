./StartServer.sh \
  -SteamServerName="{{ getv("/soulmask/servername", "SoulmaskDedicatedServer") }}" \
  -Port="{{ getv("/soulmask/port", "8777") }}" \
  -QueryPort="{{ getv("/soulmask/queryport", "27015") }}" \
  -EchoPort="{{ getv("/soulmask/echoport", "18888") }}" \
  -MaxPlayers="{{ getv("/soulmask/maxplayers", "50") }}" \
  -PSW="{{ getv("/soulmask/password", "") }}" \
  -adminpsw="{{ getv("/soulmask/admin/password", "Secret123") }}"
  {% if getv("/soulmask/pve", "false")|lower == "true" %}
    -pve \
  {% endif %}