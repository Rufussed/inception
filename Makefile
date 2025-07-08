ENV_FILE=srcs/.env
DATA_DIR=/home/$(USER)/data

# Main targets
all: setup build up

setup:
	@echo "📁 Creating data directories if not present..."
	@mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	@echo "🔐 Setting permissions for data directories..."
	@sudo chown -R 108:117 $(DATA_DIR)/mariadb
	@sudo chown -R 33:33 $(DATA_DIR)/wordpress

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
	@docker volume rm srcs_mariadb_data srcs_wordpress_files || true

clean-persistent-data: down
	@echo "🗑️ Removing persistent data directories AND volumes..."
	@sudo rm -rf $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	@docker volume rm srcs_mariadb_data srcs_wordpress_files || true
	@echo "✅ Data directories and volumes removed"

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

fix-permissions:
	@echo "🔧 Fixing script permissions:"
	@chmod +x srcs/requirements/wordpress/tools/init.sh
	@chmod +x srcs/requirements/mariadb/tools/init.sh
	@echo "✅ Script permissions fixed"

quick-fix:
	@echo "🚀 Quick fix: permissions + rebuild"
	@chmod +x srcs/requirements/wordpress/tools/init.sh
	@chmod +x srcs/requirements/mariadb/tools/init.sh
	@docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) down
	@docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) build --no-cache
	@docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) up -d

fix-wordpress-permissions:
	@echo "🔧 Fixing WordPress file permissions..."
	@sudo chown -R 33:33 $(DATA_DIR)/wordpress
	@sudo chmod -R 755 $(DATA_DIR)/wordpress
	@echo "✅ WordPress permissions fixed"
	@docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) restart wordpress nginx

check:
	@echo "🔍 Quick check:"
	@echo "Container status:"
	@docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) ps
	@echo "\nWordPress files:"
	@ls -la $(DATA_DIR)/wordpress/ 2>/dev/null || echo "No WordPress files found"
	@echo "\nRecent logs:"
	@docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) logs --tail=5

nuclear-reset:
	@echo "💥 NUCLEAR RESET - This will destroy everything!"
	@docker compose -f srcs/docker-compose.yml --env-file $(ENV_FILE) down -v
	@docker system prune -f
	@docker volume prune -f
	@sudo rm -rf $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	@echo "🔧 Rebuilding from scratch..."
	@make all

.PHONY: all setup ssl build up down restart clean clean-persistent-data fclean re logs status fix-permissions quick-fix fix-wordpress-permissions check nuclear-reset