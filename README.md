![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/papabeardoes/soulmask-server)
![GitHub License](https://img.shields.io/github/license/papabeardoes/soulmaskserver)

# Soulmask Server
PapaBear's Soulmask Server Docker Container

This uses steamCMD to automatically update your server software.

This Dockerfile will download the Soulmask dedicated server app and set it up, along with its dependencies.

I recommend letting Docker control the Volume settings, as all of the game modification commands can be done in-game using the admin console commands.

# Run the server
<a name="DockerRun"></a>
## Docker
Use this `docker run` command to launch a container with server startup options.
Replace `<ENVIRONMENT_VARIABLE>=<VALUE>` with the appropriate values (see section [Server properties and environment variables](#PropertiesVariables)).

```
docker run -it --rm -d \
 --name soulmaskserver \
 -u 10000 \
 -e PGID=10000 \
 -e PUID=10000 \
 -e SERVERNAME="SoulmaskServer" \
 -e STEAM_VALIDATE="false" \
 -e PVE="true" \
 -e ADMIN_PSW="4dm1nP4ssw0rd" \
 -e PSW="s3rv3rP4ssw0rd" \
 -e MAXPLAYERS="25" \
 -v soulmask_vol:/soulmaskserver/config \
 -p 8777/udp \
 -p 27015/udp \
 -p 18888/tcp \
 ghcr.io/papabeardoes/soulmaskserver
```

### Additional Docker commands
<a name="DockerRunCommands"></a>
**docker logs**
`docker logs -f soulmaskserver`

**exec into the container's bash console**
`docker exec -it soulmaskserver bash`

## Docker Compose
<a name="DockerCompose"></a>
You can use the file docker-compose.yml [provided here](https://github.com/PapaBearDoes/soulmaskserver/blob/main/dockerCompose/docker-compose.yml), or simply create a file named docker-compose.yml in the directory where you wish to start the server with the below information in the file:

```
name: soulmaskserver

services:
  soulmaskserver:
    image: ghcr.io/papabeardoes/soulmaskserver:latest
    container_name: soulmaskserver
    restart: unless-stopped
    environment:
      PUID: 10000
      PGID: 10000
      SERVERNAME: ServerName
      STEAM_VALIDATE: false
      PASSWORD: ${PASSWORD}
      ADMIN_PASSWORD: ${ADMIN_PASSWORD}
      MAXPLAYERS: 25
      PVE: true
    user: 10000:10000
    volumes:
      - soulmask_vol:/home/soulmask/server
    networks:
      - soulmask_net
    ports:
      - 8777:8777/udp
      - 27015:27015/udp
      - 18888:18888/udp

volumes:
  soulmask_vol:
    name: soulmaskserver

networks:
  soulmask_net:
    driver: bridge
    attachable: true
```

It is highly recommended that you create an ".env" environment file in the same directory (which will be read into the docker-compose file as variables), put your passwords for the server in that file, and then chmod the file to 644.

```
PASSWORD=s3rv3rP4ssw0rd
ADMIN_PASSWORD=4dm1nP4ssw0rd
```

### Docker Compose Commands
<a name="DockerComposeCommands"></a>
First enter into the directory where your docker-compose.yml file is located, then run the command.

**Start the server using docker-compose (attached (Watch the logs))**
```
docker compose up
```

**Start the server using docker-compose (detached (No output, runs in the background))**
```
docker compose up -d
```

**Pull a new image if one is available**
```
docker compose pull
```

**Kill the server**
```
docker compose down
```

**Update the server software within the container (restart the container detached)**
```
docker compose down && docker compose up -d
```

**Update the container, and the server software in one command**
```
docker compose down && docker compose pull && docker compose up -d
```

# Configuration
<a name="PropertiesVariables"></a>
### Server properties and environment variables
| Setting | Default | Notes |
| :-----: | :-----: | :---: |
| PUID | 10000 | The numeric userid to use in the container (leave alone unless you know what you're doing). |
| PGID | 10000 | The numeric groupid to use in the container (leave alone unless you know what you're doing). |
| SERVERNAME |  | The name of the server as shown in the server list in-game |
| STEAM_VALIDATE | false | See explanation below |
| PASSWORD |  | The Password needed to play on your server, this would be given to your players |
| ADMIN_PASSWORD | | The Server Admin Password, this is only given to trusted admins, and is used to modify game behavior |
| MAXPLAYERS | 50 | The maximum number of players you'll allow on your server |
| PVE | false | Is the server PvE or PvP? True = PvE only |

## Faster startup, no steamCMD validation
<a name="SteamValidation"></a>
SteamCMD validation is disabled by default, it causes the server to take a longer time than is truly needed to boot. Soulmask already takes FOREVER to boot, so this is disabled by default.

To enable SteamCMD file validation, in case you need to re-validate your container data. This can be enabled on demand by changing the environment variable `STEAM_VALIDATE` to `true`.