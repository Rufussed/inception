# Copilot Instructions for Inception Project

## Project Overview
This is a 42 School Inception project implementing a multi-container Docker environment with:
- Nginx (HTTPS only, port 443)
- MariaDB database
- WordPress with PHP-FPM
- Custom Dockerfiles (no pre-built Docker Hub images allowed)

## Development Guidelines

### Docker Best Practices
- Use Debian Bullseye as base images when possible
- Do not use version as we are using a newer version of Docker Compose
- Follow multi-stage builds for optimization
- Never use `FROM nginx:latest` or similar - build from scratch
- Use proper health checks in containers
- Implement proper signal handling for graceful shutdowns
- Using newer docker compose, so bash "docker compose" should be used instead of "docker-compose"

### Security Requirements
- Only HTTPS connections (port 443)
- No hardcoded credentials in Dockerfiles
- Use environment variables from .env file
- Implement proper file permissions
- Use non-root users in containers when possible

### File Structure Rules
- All services must be in `srcs/requirements/`
- Each service needs its own Dockerfile
- Configuration files go in `conf/` subdirectories
- Initialization scripts go in `tools/` subdirectories
- Use volumes for persistent data: `~/data/wordpress` and `~/data/mariadb`

# Directory Structure
inception/
├── Makefile
├── srcs/
│   ├── .env
│   ├── docker-compose.yml
│   ├── requirements/
│   │   ├── mariadb/
│   │   │   ├── Dockerfile
│   │   │   └── tools/
│   │   │       └── setup.sh
│   │   ├── nginx/
│   │   │   ├── Dockerfile
│   │   │   └── conf/
│   │   │       └── nginx.conf
│   │   └── wordpress/
│   │       ├── Dockerfile
│   │       └── tools/
│   │           └── setup.sh
└── ... (data volumes will be created here by Docker)

### Networking
- Services communicate via Docker network
- WordPress connects to MariaDB via service name
- Nginx proxies to WordPress PHP-FPM

### Environment Variables
- All sensitive data in `srcs/.env`
- Use consistent naming conventions
- Domain name: `rlane.42.fr`
- Database name: `wordpress`

### Common Issues to Address
- Volume mounting permissions
- PHP-FPM socket configuration
- SSL certificate generation
- Database initialization timing
- WordPress installation automation

### Code Style
- Use shell scripts for service initialization
- Comment Dockerfiles thoroughly
- Use consistent indentation (2 spaces)
- Meaningful variable names in scripts

## Testing Approach
- Test each service individually first
- Verify HTTPS-only access
- Check database connectivity
- Validate WordPress functionality
- Test container restart behavior

## Reference Document
Always refer to and utilize the content from "inception.pdf" which contains project requirements, design specifications, and methodology guidelines. Apply the principles and information from this document in all conversations.

## Additional Notes
- Proceed with one testable step at a time.