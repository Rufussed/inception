#!/bin/sh

# Ensure directories exist with correct permissions
mkdir -p /var/run/mysqld /var/lib/mysql
chown -R mysql:mysql /var/run/mysqld /var/lib/mysql
chmod 777 /var/run/mysqld

# Initialize if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --skip-test-db
fi

# Start MariaDB temporarily for setup
mysqld --user=mysql &
pid="$!"

# Wait for MariaDB to be ready
until mysqladmin ping >/dev/null 2>&1; do
    echo "Waiting for MariaDB to start..."
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
