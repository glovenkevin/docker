# Docker

This is a simple repository related to docker configuration to support my local development.

## Configure this project
Volume
```sh
docker volume create local-postgre
```

Network
```sh
docker network create development
```

## How to run this project

Start the container
```sh
make compose-up
```

Drop the container
```sh
make compose-down
```