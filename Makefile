SHELL=/bin/sh
docker_files = $(shell find docker-compose.*.yaml | sed 's/^/-f /')

setup-postgre:
	docker volume create local-postgre

setup-rabbitmq:
	docker volume create local-data-rabbitmq
	docker volume create local-log-rabbitmq

setup-network:
	docker network create development

setup: setup-postgre setup-kafka-volume setup-rabbitmq setup-network

tearup:
	docker volume rm local-postgre local-confluent-kafka local-data-rabbitmq \
		local-log-rabbitmq
	docker network rm development

compose-up:
	docker compose $(docker_files) up -d

compose-down:
	docker compose $(docker_files) down

compose-ps:
	docker compose $(docker_files) ps

# kafka ui
kafka-ui-up:
	docker compose -f docker-compose.kafka-ui.yaml up -d

kafka-ui-restart:
	docker compose -f docker-compose.kafka-ui.yaml restart

kafka-ui-down:
	docker compose -f docker-compose.kafka-ui.yaml down

# Confluent Kafka
kc-up:
	docker compose -f docker-compose.confluent-kafka.yaml up -d

kc-down:
	docker compose -f docker-compose.confluent-kafka.yaml down

kc-start:
	docker compose -f docker-compose.confluent-kafka.yaml start

kc-stop:
	docker compose -f docker-compose.confluent-kafka.yaml stop

kc-create-topic:
	docker exec -it confluent-broker sh -c "kafka-topics --bootstrap-server confluent-broker:9092 --create --topic $(topic)"

kc-delete-topic:
	docker exec -it confluent-broker sh -c "kafka-topics --bootstrap-server confluent-broker:9092 --delete --topic $(topic)"

# Confluent Kafka Cluster
kcc-up:
	docker compose -f docker-compose.confluent-kafka-cluster.yaml up -d

kcc-down:
	docker compose -f docker-compose.confluent-kafka-cluster.yaml down

kcc-start:
	docker compose -f docker-compose.confluent-kafka-cluster.yaml start

kcc-stop:
	docker compose -f docker-compose.confluent-kafka-cluster.yaml stop

kcc-create-topic:
	docker exec -it confluent-broker sh -c "kafka-topics --bootstrap-server confluent-broker-1:9092 --create --partitions 2 --replication-factor 2 --topic $(topic)"

# Rabbit mq kafka
rq-up:
	docker compose -f docker-compose.rabbit-mq.yaml up -d

rq-down:
	docker compose -f docker-compose.rabbit-mq.yaml down
