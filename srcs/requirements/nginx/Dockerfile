FROM debian:bullseye

# Install NGINX, OpenSSL, mkcert dependencies, and wget in one layer
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install mkcert for SSL certificate generation
RUN wget -O /usr/local/bin/mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64 && \
    chmod +x /usr/local/bin/mkcert

# Copy cert and key into the container at /etc/nginx/ssl
COPY conf/ssl /etc/nginx/ssl


# Copy the custom NGINX configuration file
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Copy SSL generation script for convenience
COPY tools/setup-ssl.sh /usr/local/bin/setup-ssl.sh
RUN chmod +x /usr/local/bin/setup-ssl.sh

# Run SSL generation script during build to ensure certs exist
RUN /usr/local/bin/setup-ssl.sh

# Ensure the NGINX run directory exists.
# The nginx package on Debian creates the log directory and sets permissions.
RUN mkdir -p /var/run/nginx

# Expose port 443 for HTTPS traffic
EXPOSE 443

# Start NGINX in the foreground.
# Nginx will start as root to bind to port 443, then drop privileges
# for its worker processes to the 'www-data' user as defined in nginx.conf.
CMD ["nginx", "-g", "daemon off;"]
