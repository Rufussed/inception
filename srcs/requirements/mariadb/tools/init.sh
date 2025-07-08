#!/bin/sh

if [ ! -f "/run/mysqld/mysqld.pid" ]; then
    # Configure MariaDB to listen on all interfaces
    sed -i 's/= 127.0.0.1/= 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
    sed -i 's/^#port/port/' /etc/mysql/mariadb.conf.d/50-server.cnf
    
    # Create database and users if they don't exist
    if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
        echo "Initializing MariaDB database..."
        
        # Start MariaDB service
        service mariadb start
        
        # Create database and users
        mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
        mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
        mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
        mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
        mysql -e "FLUSH PRIVILEGES;"
        mysql -u root --skip-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
        
        # Shutdown temporary instance
        mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
    else
        echo "Database already exists, skipping initialization"
    fi
fi

# Start MariaDB in safe mode
exec mysqld_safe
