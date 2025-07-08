#!/bin/sh
set -e

echo "Environment variables:"
echo "DB_HOST: $DB_HOST"
echo "DB_DATABASE: $DB_DATABASE"
echo "DB_USER: $DB_USER"
echo "DB_USER_PASSWORD: $DB_USER_PASSWORD"

# Ensure /run/php exists and is owned by www-data
mkdir -p /run/php
chown -R www-data:www-data /run/php

# Wait for MariaDB to be ready
echo "Waiting for MariaDB..."
for i in $(seq 1 30); do
    if mariadb -h"$DB_HOST" -u"$DB_USER" -p"$DB_USER_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; then
        echo "MariaDB is ready!"
        break
    fi
    echo "Waiting for MariaDB... attempt $i"
    sleep 1
done

# Generate wp-config.php if it doesn't exist
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Creating wp-config.php..."
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

    sed -i "s/database_name_here/$DB_DATABASE/" /var/www/html/wp-config.php
    sed -i "s/username_here/$DB_USER/" /var/www/html/wp-config.php
    sed -i "s/password_here/$DB_USER_PASSWORD/" /var/www/html/wp-config.php
    sed -i "s/localhost/$DB_HOST/" /var/www/html/wp-config.php
    sed -i "s/wp_/$DB_TABLE_PREFIX/" /var/www/html/wp-config.php

    echo "wp-config.php created with:"
    echo "Database: $DB_DATABASE"
    echo "User: $DB_USER"
    echo "Host: $DB_HOST"
fi

echo "Starting PHP-FPM..."
exec php-fpm7.4 -F
