SHELL=/bin/sh
DOCKER_FILES = $(shell find docker-compose.*.yaml | sed 's/^/-f /')
KAFKA_DOCKER_FILES = $(shell find docker-compose.confluent-kafka*.yaml | sed 's/^/-f /')

DOCKER = docker
COMPOSE_ARGS = --env-file ./config/.env
COMPOSE = $(DOCKER) compose $(COMPOSE_ARGS)
EXEC = $(DOCKER) exec

setup-postgre:
	$(DOCKER) volume create local-postgre

setup-rabbitmq:
	$(DOCKER) volume create local-data-rabbitmq
	$(DOCKER) volume create local-log-rabbitmq

setup-network:
	$(DOCKER) network create development

setup: setup-postgre setup-rabbitmq setup-network

ps:
	$(COMPOSE) $(DOCKER_FILES) ps

tearup:
	$(DOCKER) volume rm local-postgre local-confluent-kafka local-data-rabbitmq \
		local-log-rabbitmq
	$(DOCKER) network rm development

compose-up:
	$(COMPOSE) $(DOCKER_FILES) up -d

compose-down:
	$(COMPOSE) $(DOCKER_FILES) down

compose-down-v:
	$(COMPOSE) $(DOCKER_FILES) down -v

compose-ps:
	$(COMPOSE) $(DOCKER_FILES) ps

compose-start:
	$(COMPOSE) $(DOCKER_FILES) start

compose-stop:
	$(COMPOSE) $(DOCKER_FILES) stop

compose-restart:
	$(COMPOSE) $(DOCKER_FILES) restart

# kafka ui
kafka-ui-up:
	$(COMPOSE) -f docker-compose.kafka-ui.yaml up -d

kafka-ui-restart:
	$(COMPOSE) -f docker-compose.kafka-ui.yaml restart

kafka-ui-down:
	$(COMPOSE) -f docker-compose.kafka-ui.yaml down

# Confluent Kafka
kc-up:
	$(COMPOSE) -f docker-compose.confluent-kafka.yaml up -d

kc-down:
	$(COMPOSE) -f docker-compose.confluent-kafka.yaml down

kc-down-v:
	$(COMPOSE) -f docker-compose.confluent-kafka.yaml down -v

kc-start:
	$(COMPOSE) -f docker-compose.confluent-kafka.yaml start

kc-stop:
	$(COMPOSE) -f docker-compose.confluent-kafka.yaml stop

kc-restart:
	$(COMPOSE) -f docker-compose.confluent-kafka.yaml restart

kc-create-topic:
	$(EXEC) -it confluent-broker sh -c "kafka-topics --bootstrap-server confluent-broker:9092 --create --topic $(topic)"

kc-delete-topic:
	$(EXEC) -it confluent-broker sh -c "kafka-topics --bootstrap-server confluent-broker:9092 --delete --topic $(topic)"

# Confluent Kafka Cluster
kcc-up:
	$(COMPOSE) -f docker-compose.confluent-kafka-cluster.yaml up -d

kcc-down:
	$(COMPOSE) -f docker-compose.confluent-kafka-cluster.yaml down

kcc-down-v:
	$(COMPOSE) -f docker-compose.confluent-kafka-cluster.yaml down -v

kcc-start:
	$(COMPOSE) -f docker-compose.confluent-kafka-cluster.yaml start

kcc-stop:
	$(COMPOSE) -f docker-compose.confluent-kafka-cluster.yaml stop

kcc-restart:
	$(COMPOSE) -f docker-compose.confluent-kafka-cluster.yaml restart

kcc-create-topic:
	$(EXEC) -it confluent-kafka-1 sh -c "kafka-topics --bootstrap-server confluent-kafka-1:9092 --create --partitions 2 --replication-factor 2 --topic $(topic)"

# All Kafka
kafka-up:
	$(COMPOSE) $(KAFKA_DOCKER_FILES) up -d

kafka-down:
	$(COMPOSE) $(KAFKA_DOCKER_FILES) down

kafka-down-v:
	$(COMPOSE) $(KAFKA_DOCKER_FILES) down -v

kafka-start:
	$(COMPOSE) $(KAFKA_DOCKER_FILES) start

kafka-stop:
	$(COMPOSE) $(KAFKA_DOCKER_FILES) stop

kafka-restart:
	$(COMPOSE) $(KAFKA_DOCKER_FILES) restart

# Rabbit mq kafka
rq-up:
	$(COMPOSE) -f docker-compose.rabbit-mq.yaml up -d

rq-down:
	$(COMPOSE) -f docker-compose.rabbit-mq.yaml down

# Postgre
postgre-up:
	$(COMPOSE) -f docker-compose.postgresql.yaml up -d

postgre-down:
	$(COMPOSE) -f docker-compose.postgresql.yaml down

postgre-restart:
	$(COMPOSE) -f docker-compose.postgresql.yaml restart
