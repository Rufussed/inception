#!/bin/sh

# Exit if wp-config.php already exists
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Creating wp-config.php..."

    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

    # Insert database credentials using double quotes (not single)
    sed -i "s/database_name_here/${WORDPRESS_DB_NAME}/" /var/www/html/wp-config.php
    sed -i "s/username_here/${WORDPRESS_DB_USER}/" /var/www/html/wp-config.php
    sed -i "s/password_here/${WORDPRESS_DB_PASSWORD}/" /var/www/html/wp-config.php
    sed -i "s/localhost/${WORDPRESS_DB_HOST}/" /var/www/html/wp-config.php
fi

mkdir -p /run/php

exec php-fpm -F
