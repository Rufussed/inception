# Use Debian Bullseye as the base image
FROM debian:bullseye

# Create directory for static files
RUN mkdir -p /var/www/static && \
    chown -R www-data:www-data /var/www/static && \
    chmod -R 755 /var/www/static

# Copy website files
COPY --chown=www-data:www-data www/ /var/www/static/

# Ensure proper permissions on startup
COPY --chown=root:root entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Keep container running and maintain permissions
ENTRYPOINT ["/entrypoint.sh"]
