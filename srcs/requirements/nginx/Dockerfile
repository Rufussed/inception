FROM debian:bullseye

# Install NGINX, OpenSSL, and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy SSL certs generated on the host
COPY conf/ssl /etc/nginx/ssl

# Copy the custom NGINX configuration file
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Ensure the NGINX run directory exists
RUN mkdir -p /var/run/nginx

# Expose port 443 for HTTPS traffic
EXPOSE 443

# Start NGINX in the foreground
ENTRYPOINT ["nginx", "-g", "daemon off;"]