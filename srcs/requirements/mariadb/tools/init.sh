#!/bin/sh

# Ensure directories exist with correct permissions
mkdir -p /var/run/mysqld /var/lib/mysql
chown -R mysql:mysql /var/run/mysqld /var/lib/mysql
chmod 777 /var/run/mysqld

# Configure MariaDB to listen on all interfaces
sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i 's/#port/port/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Initialize if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --skip-test-db
fi

# Start MariaDB temporarily for setup
mysqld --user=mysql &
pid="$!"

# Wait for MariaDB to be ready
for i in $(seq 1 30); do
    if mysqladmin ping >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

# Always ensure database and users exist
mysql -e "CREATE DATABASE IF NOT EXISTS ${DB_DATABASE};"
mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON ${DB_DATABASE}.* TO '${DB_USER}'@'%';"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"

# Stop temporary server
mysqladmin -u root -p${DB_ROOT_PASSWORD} shutdown
wait "$pid"

# Start MariaDB
exec mysqld --user=mysql
