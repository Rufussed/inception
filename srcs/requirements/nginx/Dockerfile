FROM debian:bullseye

# Install NGINX and OpenSSL, then clean up APT cache to keep the image small
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Copy cert and key into the container at /etc/nginx/ssl
COPY conf/ssl /etc/nginx/ssl


# Copy the custom NGINX configuration file
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Ensure the NGINX run directory exists.
# The nginx package on Debian creates the log directory and sets permissions.
RUN mkdir -p /var/run/nginx

# Expose port 443 for HTTPS traffic
EXPOSE 443

# Start NGINX in the foreground.
# Nginx will start as root to bind to port 443, then drop privileges
# for its worker processes to the 'www-data' user as defined in nginx.conf.
CMD ["nginx", "-g", "daemon off;"]
