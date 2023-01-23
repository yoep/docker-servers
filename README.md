# Docker servers

Various docker game servers which are not present within the [OpenSourceLAN/gameservers-docker](https://github.com/OpenSourceLAN/gameservers-docker) repo.

## Usage

The `docker-compose.yaml` file contains all servers which can be started.
To run a specific server, use the following command:

```shell
docker compose up [SERVICE] --detach
```

### Local server config

If you want to add server options to the docker compose without modifying the git tracked file,
add a new file called `docker-server.yaml` and launch it as follows:

```shell
docker compose -f docker-compose.yaml -f docker-server.yaml up [SERVICE] --detach
```

Some servers however require initial command arguments on the first start.
This can be resolved by using `run` instead of `up` as follows:

```shell
docker compose -f docker-compose.yaml -f docker-server.yaml run [SERVICE] --detach
```

### Update a server/docker image

If an update is available, you need to stop the docker container and run 
the following command.

```shell
docker compose build [SERVICE] --no-cache --pull
```

or rebuild and startup in the same command:

```shell
docker compose up [SERVICE] --detach --build
```

## Data

Most of the server data will be mounted to the service directory which is started
for easy access.

This can always be changed in within the `docker-compose.yaml` file.

## Logs

If you want to access the logs of the server, use the following command:

```shell
docker compose logs -f [SERVICE]
```