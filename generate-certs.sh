#!/bin/bash

rm -rf certs/
mkdir -p certs/

if [ $# -eq 0 ]; then
  NAME="service"
else
  NAME="$1"
fi

# Generate private key and self-signed certificate in one command
openssl req -x509 -newkey rsa:2048 -noenc -days 365 -subj "/CN=localhost" \
  -keyout certs/$NAME.key -out certs/$NAME.crt

chmod 600 certs/$NAME.key
chmod 644 certs/$NAME.crt

echo "SSL certificates have been generated successfully in the certs/ directory:"
echo "- Private key: certs/$NAME.key"
echo "- Certificate: certs/$NAME.crt"
