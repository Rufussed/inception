# Use official MariaDB image (includes Debian + MariaDB server)
FROM mariadb:10.5

# Copy custom configuration into the container
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# === Init Script Integration ===
# Instead of replacing the entrypoint, we use the official hook:
# Any .sh or .sql file in /docker-entrypoint-initdb.d/ is executed on first run
COPY tools/init.sh /docker-entrypoint-initdb.d/init.sh

# Ensure the script is executable
RUN chmod +x /docker-entrypoint-initdb.d/init.sh

# Not needed but as the image is based on the official MariaDB image, for clarity
# we set the entrypoint to the default MariaDB entrypoint script
# This allows the container to start MariaDB with the provided configuration
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld"]