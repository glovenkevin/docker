SHELL=/bin/sh
docker_files = $(shell find docker-compose.*.yaml | sed 's/^/-f /')

setup:
	docker volume create local-postgre
	docker network create development

compose-up:
	docker compose $(docker_files) up -d

compose-down:
	docker compose $(docker_files) down

# kafka
kafka-up:
	docker compose -f docker-compose.kafka.yaml up -d

kafka-down:
	docker compose -f docker-compose.kafka.yaml down

kafka-create-topic:
	docker exec -it confluent-broker sh -c "kafka-topics --bootstrap-server confluent-broker:9092 --create --topic $(topic)"

kafka-delete-topic:
	docker exec -it confluent-broker sh -c "kafka-topics --bootstrap-server confluent-broker:9092 --delete --topic $(topic)"

compose-ps:
	docker compose $(docker_files) ps