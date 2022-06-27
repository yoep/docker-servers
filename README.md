# Docker servers

Various docker game servers which are not present within the [OpenSourceLAN/gameservers-docker](https://github.com/OpenSourceLAN/gameservers-docker) repo.

## Usage

The `docker-compose.yaml` file contains all servers which can be started.
To run a specific server, use the following command:

```yaml
docker compose up [SERVICE] --detach
```

### Update a server/docker image

If an update is available, you need to stop the docker container and run 
the following command.

```yaml
docker compose build [SERVICE] --no-cache --pull
```

or rebuild and startup in the same command:

```yaml
docker compose up [SERVICE] --detach --build
```

## Data

Most of the server data directories will be mounted to the service directory
for easy access.