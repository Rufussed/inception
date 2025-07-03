FROM debian:bullseye

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install MariaDB and clean up APT cache
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      apt-transport-https ca-certificates gnupg dirmngr \
      mariadb-server mariadb-client \
 && rm -rf /var/lib/apt/lists/*

# Copy custom configuration and init script
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init.sh /usr/local/bin/init.sh

# Make the init script executable
RUN chmod +x /usr/local/bin/init.sh

# Expose the default MariaDB port
EXPOSE 3306

# Set the init script as the container entrypoint
ENTRYPOINT ["/usr/local/bin/init.sh"]

# Run the MariaDB daemon in foreground by default
CMD ["mysqld"]
