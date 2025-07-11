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

    # Add Redis configuration
    echo "define('WP_CACHE', true);" >> /var/www/html/wp-config.php
    echo "define('WP_REDIS_HOST', 'redis');" >> /var/www/html/wp-config.php
    echo "define('WP_REDIS_PORT', 6379);" >> /var/www/html/wp-config.php
    echo "define('WP_CACHE_KEY_SALT', 'rlane.42.fr');" >> /var/www/html/wp-config.php

    echo "wp-config.php created with:"
    echo "Database: $DB_DATABASE"
    echo "User: $DB_USER"
    echo "Host: $DB_HOST"
    echo "Redis Host: redis"
fi

# Insert Redis config before require_once in wp-config.php
if grep -q "require_once ABSPATH . 'wp-settings.php';" /var/www/html/wp-config.php; then
  sed -i "/require_once ABSPATH . 'wp-settings.php';/i \
define('WP_CACHE', true);\ndefine('WP_REDIS_HOST', 'redis');\ndefine('WP_REDIS_PORT', 6379);\ndefine('WP_CACHE_KEY_SALT', 'rlane.42.fr');\n" /var/www/html/wp-config.php
fi

# Install Redis Object Cache plugin if not already installed
if [ ! -d /var/www/html/wp-content/plugins/redis-cache ]; then
    echo "Installing Redis Object Cache plugin..."
    # Use -L to follow redirects and -f to fail silently if error
    if curl -L -f -o /tmp/redis-cache.zip https://downloads.wordpress.org/plugin/redis-cache.latest-stable.zip; then
        unzip -o /tmp/redis-cache.zip -d /var/www/html/wp-content/plugins/
        rm /tmp/redis-cache.zip
        chown -R www-data:www-data /var/www/html/wp-content/plugins/redis-cache
        echo "Redis Object Cache plugin installed successfully"
    else
        echo "Failed to download Redis Object Cache plugin"
    fi
fi

# Ensure Redis object-cache.php drop-in is present
if [ -d /var/www/html/wp-content/plugins/redis-cache ]; then
  PLUGIN_DROPIN=$(find /var/www/html/wp-content/plugins/redis-cache -name object-cache.php | head -n1)
  if [ -n "$PLUGIN_DROPIN" ]; then
    cp "$PLUGIN_DROPIN" /var/www/html/wp-content/object-cache.php
    chown www-data:www-data /var/www/html/wp-content/object-cache.php
    echo "Redis object-cache.php drop-in installed."
  else
    echo "Could not find object-cache.php in redis-cache plugin directory."
  fi
fi

# Ensure proper ownership
chown -R www-data:www-data /var/www/html
chown -R www-data:www-data /var/www/html/wp-content

# Also allow FTP user to write to /var/www/html (for FTP uploads)
if [ -n "$FTP_USER" ]; then
  # Try to set group ownership to www-data and add FTP user to group
  adduser "$FTP_USER" www-data 2>/dev/null || true
  chown -R www-data:www-data /var/www/html
  chmod -R 775 /var/www/html
fi

echo "Starting PHP-FPM..."
exec php-fpm7.4 -F
