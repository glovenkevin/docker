docker_files = $(shell find docker-compose.*.yaml | sed 's/^/-f /')

setup:
	docker volume create local-postgre
	docker network create development

compose-up:
	docker compose $(docker_files) up -d

compose-down:
	docker compose $(docker_files) down

kafka-up:
	docker compose -f docker-compose.kafka.yaml up -d

kafka-down:
	docker compose -f docker-compose.kafka.yaml down

compose-ps:
	docker compose $(docker_files) ps