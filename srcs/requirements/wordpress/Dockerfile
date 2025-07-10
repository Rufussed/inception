# Use Debian Bullseye as the base image
FROM debian:bullseye

# Install required packages and set up WordPress:
# - php-fpm: PHP FastCGI Process Manager
# - php-mysql: MySQL module for PHP
# - wget: For downloading WordPress
# - default-mysql-client: For database connections
# - curl: For downloading additional resources
RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    php-redis \
    wget \
    default-mysql-client \
    curl \
    # needed for extracting redis extension
    unzip \ 
    # Clean up apt cache to reduce image size
    && rm -rf /var/lib/apt/lists/* \
    # Create necessary directories
    && mkdir -p /var/www/html \
    && mkdir -p /run/php \
    # Download and install latest WordPress
    && cd /tmp \
    && wget https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz \
    && cp -r wordpress/* /var/www/html/ \
    # Set proper ownership for WordPress files
    && chown -R www-data:www-data /var/www/html \
    # Clean up temporary files
    && rm -rf /tmp/wordpress /tmp/latest.tar.gz

# Copy initialization script and make it executable
COPY --chmod=0755 tools/init.sh /usr/local/bin/

# Copy PHP-FPM configuration
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Expose port for PHP-FPM
EXPOSE 9000

# Start PHP-FPM using our initialization script
ENTRYPOINT ["/usr/local/bin/init.sh"]
