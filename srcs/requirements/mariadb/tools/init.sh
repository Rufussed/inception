#!/bin/sh

# Initialize the database if not already done
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Initializing MariaDB..."
  mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# Start MariaDB in foreground
exec mysqld