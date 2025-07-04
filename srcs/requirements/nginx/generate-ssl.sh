#!/bin/bash

# Change to the script’s directory to make relative paths work
cd "$(dirname "$0")"

# Create the SSL directory if it doesn't exist
mkdir -p conf/ssl

# Generate self-signed certificate and key
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout conf/ssl/rlane.42.fr.key \
  -out conf/ssl/rlane.42.fr.crt \
  -subj "/C=FR/ST=42/L=Intra/O=Inception/CN=rlane.42.fr"

echo "✅ SSL certificate and key generated in $(pwd)/conf/ssl/"
