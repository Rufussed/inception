#!/bin/bash
# Generate SSL certs for all required domains using mkcert
set -e
CERT_DIR="$(dirname "$0")/../conf/ssl"
mkdir -p "$CERT_DIR"

# List your domains here
DOMAINS=(
  rlane.42.fr
  static.42.fr
  adminer.42.fr
  tinyapi.42.fr
  # Add more domains as needed
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
