#!/bin/sh

set -e


# Generate wp-config.php if it doesn’t exist
if [ ! -f /var/www/html/wp-config.php ]; then
  echo "[INIT] Creating wp-config.php..."
  cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

  sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wp-config.php
  sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wp-config.php
  sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wp-config.php
  sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wp-config.php
fi

exec php-fpm -F
