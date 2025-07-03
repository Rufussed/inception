# Inception - Docker Multi-Container Environment

## 42 School Project Requirements
- Custom Dockerfiles only (no Docker Hub images)
- HTTPS-only web server (port 443)
- WordPress + PHP-FPM
- MariaDB database
- Nginx reverse proxy
- Alpine Linux base images preferred

## Architecture
```
Internet → Nginx (443/HTTPS) → WordPress (PHP-FPM) → MariaDB
```

## Environment Setup

### 42 School Development (No Sudo)
For development on 42 systems without sudo privileges:
```bash
# Add domain to hosts file
echo "127.0.0.1 rlane.42.fr" >> ~/.hosts

# Access via development port
# URL: https://rlane.42.fr:8443
```

### VM/Production Setup (With Sudo)
For final testing and evaluation with sudo privileges:
```bash
# Add domain to system hosts
echo "127.0.0.1 rlane.42.fr" | sudo tee -a /etc/hosts

# Standard HTTPS port 443
# URL: https://rlane.42.fr
```

## Quick Start

### On 42 School System
```bash
make setup-dev    # Create data directories and setup
make build        # Build all containers
make up-dev       # Start with development port mapping
make test-dev     # Test development setup
```

### On VM with Sudo
```bash
make setup        # Create data directories with proper permissions
make build        # Build all containers  
make up           # Start with standard port 443
make test         # Test production setup
```

## Development Notes
- Domain: rlane.42.fr
- Data persistence: ~/data/wordpress and ~/data/mariadb volumes
- All configuration via environment variables in srcs/.env
- Graceful container shutdown implemented
- SSL certificates auto-generated

## Project Structure
```
inception/
├── srcs/
│   ├── docker-compose.yml       # Production config (port 443)
│   ├── docker-compose.dev.yml   # Development config (port 8443)
│   ├── .env                     # Environment variables
│   └── requirements/
│       ├── nginx/               # Custom Nginx with SSL
│       ├── wordpress/           # WordPress + PHP-FPM
│       └── mariadb/            # MariaDB database
└── Makefile                    # Build and deployment commands
```