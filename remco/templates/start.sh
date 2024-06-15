./StartServer.sh \
  -SteamServerName="{{ getv("/soulmask/servername", "Soulmask Dedicated Server") }}" \
  -Port="{{ getv("/soulmask/port", "8777") }}" \
  -QueryPort="{{ getv("/soulmask/queryport", "27015") }}" \
  -EchoPort="{{ getv("/soulmask/echoyport", "18888") }}" \
{% if getv("/soulmask/pve", "false")|lower == "true" %}
  -pve \
{% endif %}
  -MaxPlayers="{{ getv("/soulmask/maxplayers", "50") }}" \
  -PSW="{{ getv("/soulmask/password", "") }}" \
  -adminpsw="{{ getv("/soulmask/admin/password", "Secret123") }}"