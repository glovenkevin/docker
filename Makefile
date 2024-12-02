SHELL=/bin/sh
docker_files = $(shell find docker-compose.*.yaml | sed 's/^/-f /')

setup:
	docker volume create local-postgre
	docker network create development

compose-up:
	docker compose $(docker_files) up -d

compose-down:
	docker compose $(docker_files) down

compose-ps:
	docker compose $(docker_files) ps

# kafka ui
kafka-ui-up:
	docker compose -f docker-compose.kafka-ui.yaml up -d

kafka-ui-down:
	docker compose -f docker-compose.kafka-ui.yaml down

# Confluent Kafka
kc-up:
	docker compose -f docker-compose.confluent-kafka.yaml up -d

kc-down:
	docker compose -f docker-compose.confluent-kafka.yaml down

kc-create-topic:
	docker exec -it confluent-broker sh -c "kafka-topics --bootstrap-server confluent-broker:9092 --create --topic $(topic)"

kc-delete-topic:
	docker exec -it confluent-broker sh -c "kafka-topics --bootstrap-server confluent-broker:9092 --delete --topic $(topic)"
