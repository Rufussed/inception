#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Check if the database has already been initialized by looking for the 'mysql' system db.
# This is more reliable than checking for the specific database folder.
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "MariaDB data directory not found. Initializing database..."

  # 1. Initialize the database directory and system tables.
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql

  # 2. Use bootstrap mode to run initial SQL commands securely and quickly.
  # This avoids starting a full server just for setup.
  mysqld --user=mysql --datadir=/var/lib/mysql --bootstrap <<EOF
-- Set the root password first.
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- Remove anonymous users for better security.
DELETE FROM mysql.user WHERE User='';

-- Disallow remote root login.
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- Remove the test database.
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

-- Create the application database and user as per the .env file.
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

-- Apply all the changes.
FLUSH PRIVILEGES;
EOF

  echo "Database initialization complete."
fi

echo "Starting MariaDB server..."
# 3. Start the server in the foreground. 'exec' is crucial for correct signal handling.
exec mysqld_safe --datadir=/var/lib/mysql