# .env file must define HTTPS_PORT and other variables
ENV_FILE=.env

# Main targets
all: ssl build up

ssl:
	@echo "🔐 Generating SSL certificate..."
	@bash ./generate-ssl.sh

build:
	@echo "🔧 Building containers..."
	docker compose --env-file $(ENV_FILE) build

up:
	@echo "🚀 Starting services..."
	docker compose --env-file $(ENV_FILE) up -d

down:
	@echo "🛑 Stopping services..."
	docker compose --env-file $(ENV_FILE) down

clean: down
	@echo "🧹 Removing volumes..."
	docker volume rm inception_mariadb_data inception_wordpress_data || true

fclean: clean
	@echo "🔥 Removing all Docker images..."
	docker image prune -a -f

re: fclean all

.PHONY: all ssl build up down clean fclean re