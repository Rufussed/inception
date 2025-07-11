# Adminer Dockerfile (custom, Debian Bullseye)
FROM debian:bullseye

# Install PHP and required extensions
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    php php-mysqli php-mbstring php-xml curl ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -d /home/adminer -s /bin/bash adminer

# Download Adminer (latest stable)
RUN mkdir -p /var/www/html \
  && curl -fsSL https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php -o /var/www/html/index.php \
  && chown -R adminer:adminer /var/www/html

# Copy entrypoint
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown adminer:adminer /entrypoint.sh

USER adminer
WORKDIR /var/www/html

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
