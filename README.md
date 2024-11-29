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

Related to container
```sh
make compose-up

make compose-down
```

Kafka
```sh
# Up container kafka only
make kafka-up
make kafka-down

# Related to topics
make kafka-create-topic topic=<topic_name>
make kafka-delete-topic topic=<topic_name>
```
