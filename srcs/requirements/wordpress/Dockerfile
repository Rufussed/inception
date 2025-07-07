# Use the official WordPress PHP-FPM base image
FROM wordpress:php7.4-fpm

# === Copy WordPress config and setup script ===

# This includes your wp-config.php template or other files
COPY conf /var/www/html/

# VirtualBox Workaround: shared folders are mounted with noexec
COPY tools/init.sh /tmp/init.sh

# Make the script executable
RUN chmod +x /tmp/init.sh

# Set entrypoint to custom init logic (creates wp-config, starts php-fpm)
ENTRYPOINT ["/tmp/init.sh"]
