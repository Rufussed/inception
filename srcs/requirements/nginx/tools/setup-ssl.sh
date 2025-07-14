#!/bin/bash
set -e

# Use project-root-relative path for SSL certs
CERT_DIR="srcs/requirements/nginx/conf/ssl"
mkdir -p "$CERT_DIR"

DOMAINS=(
  rlane.42.fr
  static.42.fr
  adminer.42.fr
  tinyapi.42.fr
)

for domain in "${DOMAINS[@]}"; do
  if [[ ! -f "$CERT_DIR/$domain.crt" || ! -f "$CERT_DIR/$domain.key" ]]; then
    echo "Generating certs for $domain..."
    mkcert -cert-file "$CERT_DIR/$domain.crt" -key-file "$CERT_DIR/$domain.key" "$domain"
  else
    echo "Certs for $domain already exist. Skipping."
  fi
done

echo "All certificates are in $CERT_DIR."