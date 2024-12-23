SHELL=/bin/sh
docker_files = $(shell find docker-compose.*.yaml | sed 's/^/-f /')
kafka_docker_files = $(shell find docker-compose.confluent-kafka*.yaml | sed 's/^/-f /')

setup-postgre:
	docker volume create local-postgre

setup-rabbitmq:
	docker volume create local-data-rabbitmq
	docker volume create local-log-rabbitmq

setup-network:
	docker network create development

setup: setup-postgre setup-rabbitmq setup-network

tearup:
	docker volume rm local-postgre local-confluent-kafka local-data-rabbitmq \
		local-log-rabbitmq
	docker network rm development

compose-up:
	docker compose $(docker_files) up -d

compose-down:
	docker compose $(docker_files) down

compose-down-v:
	docker compose $(docker_files) down -v

compose-ps:
	docker compose $(docker_files) ps

compose-start:
	docker compose $(docker_files) start

compose-stop:
	docker compose $(docker_files) stop

compose-restart:
	docker compose $(docker_files) restart

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

kc-down-v:
	docker compose -f docker-compose.confluent-kafka.yaml down -v

kc-start:
	docker compose -f docker-compose.confluent-kafka.yaml start

kc-stop:
	docker compose -f docker-compose.confluent-kafka.yaml stop

kc-restart:
	docker compose -f docker-compose.confluent-kafka.yaml restart

kc-create-topic:
	docker exec -it confluent-broker sh -c "kafka-topics --bootstrap-server confluent-broker:9092 --create --topic $(topic)"

kc-delete-topic:
	docker exec -it confluent-broker sh -c "kafka-topics --bootstrap-server confluent-broker:9092 --delete --topic $(topic)"

# Confluent Kafka Cluster
kcc-up:
	docker compose -f docker-compose.confluent-kafka-cluster.yaml up -d

kcc-down:
	docker compose -f docker-compose.confluent-kafka-cluster.yaml down

kcc-down-v:
	docker compose -f docker-compose.confluent-kafka-cluster.yaml down -v

kcc-start:
	docker compose -f docker-compose.confluent-kafka-cluster.yaml start

kcc-stop:
	docker compose -f docker-compose.confluent-kafka-cluster.yaml stop

kcc-restart:
	docker compose -f docker-compose.confluent-kafka-cluster.yaml restart

kcc-create-topic:
	docker exec -it confluent-kafka-1 sh -c "kafka-topics --bootstrap-server confluent-kafka-1:9092 --create --partitions 2 --replication-factor 2 --topic $(topic)"

# All Kafka
kafka-up:
	docker compose $(kafka_docker_files) up -d

kafka-down:
	docker compose $(kafka_docker_files) down

kafka-down-v:
	docker compose $(kafka_docker_files) down -v

kafka-start:
	docker compose $(kafka_docker_files) start

kafka-stop:
	docker compose $(kafka_docker_files) stop

kafka-restart:
	docker compose $(kafka_docker_files) restart

# Rabbit mq kafka
rq-up:
	docker compose -f docker-compose.rabbit-mq.yaml up -d

rq-down:
	docker compose -f docker-compose.rabbit-mq.yaml down

# Postgre
postgre-up:
	docker compose -f docker-compose.postgresql.yaml up -d

postgre-down:
	docker compose -f docker-compose.postgresql.yaml down

postgre-restart:
	docker compose -f docker-compose.postgresql.yaml restart
