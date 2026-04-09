#!/bin/bash

# Script to generate self-signed SSL certificate for local development

SSL_DIR="./ssl"

# Create SSL directory if not exists
mkdir -p $SSL_DIR

# Generate private key
openssl genrsa -out $SSL_DIR/nginx.key 2048

# Generate self-signed certificate
openssl req -new -x509 -key $SSL_DIR/nginx.key -out $SSL_DIR/nginx.crt -days 365 \
    -subj "/C=VN/ST=Hanoi/L=Hanoi/O=SportFieldHub/OU=Development/CN=localhost"

echo "SSL certificate generated successfully!"
echo "Location: $SSL_DIR/"
echo "  - Private key: $SSL_DIR/nginx.key"
echo "  - Certificate: $SSL_DIR/nginx.crt"
