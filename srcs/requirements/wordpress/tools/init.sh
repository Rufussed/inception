#!/bin/sh
set -e # Exit on error

# Ensure /run/php exists and is owned by www-data
mkdir -p /run/php
chown -R www-data:www-data /run/php

# Check MariaDB connection
until mariadb -h"$DB_HOST" -u"$DB_USER" -p"$DB_USER_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; do
    echo "Waiting for MariaDB..."
done
echo "MariaDB is ready!"

# Generate wp-config.php if it doesn't exist, copy the sample config and edit it with .env vars
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

# Ensure proper ownership
chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM..."
exec php-fpm7.4 -F
