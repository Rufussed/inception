FROM debian:bullseye

# Install dependencies
RUN apt-get update && apt-get install -y \
    php-fpm php-mysql php-cli php-curl php-gd php-mbstring php-xml php-zip wget unzip curl mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Download and extract WordPress
RUN curl -O https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz \
    && mv wordpress /var/www/html \
    && rm latest.tar.gz

# Copy custom init script
COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Set working directory
WORKDIR /var/www/html

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose php-fpm port
EXPOSE 9000

# Entrypoint
ENTRYPOINT ["/usr/local/bin/init.sh"]
