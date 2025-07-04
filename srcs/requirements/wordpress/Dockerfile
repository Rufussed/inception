FROM debian:bullseye

# Set non-interactive mode to avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    php-fpm php-mysql php-cli php-curl php-gd php-mbstring php-xml php-zip wget unzip curl mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Ensure target directory exists
RUN mkdir -p /var/www/html

# Download and unpack WordPress
RUN curl -fSL https://wordpress.org/latest.tar.gz -o latest.tar.gz \
 && tar -xzf latest.tar.gz \
 && mv wordpress/* /var/www/html/ \
 && rm -rf latest.tar.gz wordpress

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

