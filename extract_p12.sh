#!/bin/bash

# extract_p12.sh - Extract cert.pem and key.pem from a .p12 file

# First time
# mkdir -p ~/scripts
# chmod +x ~/scripts/extract_p12.sh


if [ -z "$1" ]; then
  echo "Usage: extract_p12 <path-to-p12-file>"
  exit 1
fi

P12_FILE="$1"

if [ ! -f "$P12_FILE" ]; then
  echo "Error: File '$P12_FILE' not found."
  exit 1
fi

echo "Extracting from: $P12_FILE"

echo "[1/4] Extracting certificate..."
openssl pkcs12 -in "$P12_FILE" -nokeys -out cert.pem -nodes || exit 1

echo "[2/4] Converting certificate..."
openssl x509 -in cert.pem -out cert.pem || exit 1

echo "[3/4] Extracting private key..."
openssl pkcs12 -in "$P12_FILE" -nocerts -out key.pem -nodes || exit 1

echo "[4/4] Cleaning private key..."
openssl rsa -in key.pem -out key.pem || exit 1

echo "Done! cert.pem and key.pem created in current directory."