FROM debian:bullseye

# Install MariaDB
RUN apt-get update && apt-get install -y mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Copy configuration file and init script
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init.sh /usr/local/bin/init.sh

# Make init script executable
RUN chmod +x /usr/local/bin/init.sh

# Set working directory for safety
WORKDIR /var/lib/mysql

# Expose MariaDB default port
EXPOSE 3306

# Entrypoint to handle DB init and run mysqld
ENTRYPOINT ["/usr/local/bin/init.sh"]
