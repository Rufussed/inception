#!/bin/bash

# Ensure proper permissions on startup
chown -R www-data:www-data /var/www/static
chmod -R 755 /var/www/static

# Keep container running
exec tail -f /dev/null
