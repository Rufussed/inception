#!/bin/bash

# Exit immediately on error
set -e

# Check if MariaDB is already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "MariaDB data directory not found. Initializing database..."

  # Initialize the system tables
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql

  # Run bootstrap SQL
  mysqld --user=mysql --datadir=/var/lib/mysql --bootstrap <<EOF
-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- Remove anonymous users
DELETE FROM mysql.user WHERE User='';

-- Disallow remote root login
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- Drop test database
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

-- Create application database and user
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

-- Apply changes
FLUSH PRIVILEGES;
EOF

  echo "MariaDB initialization complete."
fi

# No need to start mysqld here — the base image does that
