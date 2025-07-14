ENV_FILE=srcs/.env

# Main targets
all: build up

build:
	@echo "🔧 Building containers..."
	@docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) build

up:
	@echo "🚀 Starting services..."
	@docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) up -d

down:
	@echo "🛑 Stopping services..."
	@docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) down

restart: down
	@echo "🔄 Restarting services with a fresh build..."
	@docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) up -d --build

clean: down
	@echo "🧹 Removing volumes..."
	@docker volume rm srcs_mariadb_data srcs_wordpress_files srcs_static_files || true
	@echo "✅ Volumes removed"

fclean: clean
	@echo "🔥 Removing all Docker images..."
	docker image prune -a -f

re: fclean all

logs:
	@echo "📋 Container logs:"
	@docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) logs

status:
	@echo "📊 Container status:"
	@docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) ps

nuclear-reset:
	@echo "💥 NUCLEAR RESET - This will destroy everything!"
	@docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) down -v
	@docker system prune -f
	@docker volume prune -f
	@echo "🔧 Rebuilding from scratch..."
	@make all

.PHONY: all setup ssl build up down restart clean clean-persistent-data fclean re logs status nuclear-reset