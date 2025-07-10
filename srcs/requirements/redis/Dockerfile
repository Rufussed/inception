# Use Debian Bullseye as base image
FROM debian:bullseye

# Install Redis and required dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    redis-server \
    && rm -rf /var/lib/apt/lists/*

# Create redis user and group
RUN adduser --system --group --no-create-home redis

# Create necessary directories and set permissions
RUN mkdir -p /var/lib/redis && \
    mkdir -p /etc/redis && \
    chown -R redis:redis /var/lib/redis /etc/redis && \
    chmod 777 /var/lib/redis  # Ensure Redis can write to its data directory

# Copy Redis configuration
COPY conf/redis.conf /etc/redis/redis.conf
RUN chown redis:redis /etc/redis/redis.conf && \
    chmod 644 /etc/redis/redis.conf

# Expose Redis port
EXPOSE 6379

# Switch to redis user for security
USER redis

# Start Redis server in foreground (not daemonized) 
# Redis is designed to run in the foreground in Docker containers
CMD ["redis-server", "/etc/redis/redis.conf", "--supervised no"]
