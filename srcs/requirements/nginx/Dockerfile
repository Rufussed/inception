FROM debian:bullseye

# Install NGINX and OpenSSL
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Copy SSL certs and key
COPY conf/ssl/rlane.42.fr.crt /etc/ssl/certs/rlane.42.fr.crt
COPY conf/ssl/rlane.42.fr.key /etc/ssl/private/rlane.42.fr.key

# Copy custom NGINX config
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Ensure logs and runtime dirs exist
RUN mkdir -p /var/run/nginx /var/log/nginx && \
    chown -R www-data:www-data /var/run/nginx /var/log/nginx

# Expose HTTPS port
EXPOSE 443

# Start NGINX in foreground
CMD ["nginx", "-g", "daemon off;"]
