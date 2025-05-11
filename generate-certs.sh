#!/bin/bash

# Remove existing certs directory and create a new one
rm -rf certs/
mkdir -p certs/

# Check if an argument is passed to use as the certificate name
if [ $# -eq 0 ]; then
  # No argument provided, use default name
  NAME="service"
else
  # Use the first argument as the name
  NAME="$1"
fi

# Generate private key and self-signed certificate in one command
# Using Ed25519 which is more secure than RSA 2048
openssl req -x509 -newkey rsa:2048 -noenc -days 365 -subj "/CN=localhost" \
  -keyout certs/$NAME.key -out certs/$NAME.crt

# Set proper permissions
chmod 600 certs/$NAME.key
chmod 644 certs/$NAME.crt

echo "SSL certificates have been generated successfully in the certs/ directory:"
echo "- Private key: certs/$NAME.key"
echo "- Certificate: certs/$NAME.crt"
