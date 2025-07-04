# .env file must define HTTPS_PORT and other variables
ENV_FILE=srcs/.env

# Main targets
all: ssl build up

ssl:
	@echo "🔐 Generating SSL certificate..."
	@bash srcs/requirements/nginx/tools/generate-ssl.sh

build:
	@echo "🔧 Building containers..."
	docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) build

up:
	@echo "🚀 Starting services..."
	docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) up -d

down:
	@echo "🛑 Stopping services..."
	docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) down

restart:
	@echo "🔄 Restarting services with a fresh build..."
	docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) up -d --build

clean: down
	@echo "🧹 Removing volumes..."
	docker volume rm inception_mariadb_data inception_wordpress_data || true

fclean: clean
	@echo "🔥 Removing all Docker images..."
	docker image prune -a -f

re: fclean all

.PHONY: all ssl build up down restart clean fclean re