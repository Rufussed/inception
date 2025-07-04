FROM debian:bullseye

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install MariaDB and clean up APT cache
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      mariadb-server \
      bash \
 && rm -rf /var/lib/apt/lists/*

# Ensure the mysql user owns the data directory
RUN chown -R mysql:mysql /var/lib/mysql

# Copy custom configuration and init script
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init.sh /usr/local/bin/init.sh

# Make the init script executable
RUN chmod +x /usr/local/bin/init.sh

# Expose the default MariaDB port
EXPOSE 3306

# Run as the mysql user
USER mysql

# Set the init script as the container entrypoint
ENTRYPOINT ["/usr/local/bin/init.sh"]
