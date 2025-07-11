#!/bin/bash
set -e

# Start PHP built-in server for Adminer
exec php -S 0.0.0.0:8080 -t /var/www/html
