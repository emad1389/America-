#!/bin/sh
set -eu

CERT_DIR="/app/certs"
CERT_KEY="$CERT_DIR/ssl_key.pem"
CERT_FILE="$CERT_DIR/ssl_cert.pem"

mkdir -p "$CERT_DIR"

if [ ! -s "$CERT_KEY" ] || [ ! -s "$CERT_FILE" ]; then
  cat > /tmp/san.cnf <<'EOF'
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
CN = PasarGuardNode

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = pasarguard-node.railway.internal
DNS.2 = localhost
EOF

  openssl req -x509 -newkey rsa:2048 -nodes -days 3650 \
    -keyout "$CERT_KEY" \
    -out "$CERT_FILE" \
    -config /tmp/san.cnf -extensions v3_req

  chmod 600 "$CERT_KEY"
  chmod 644 "$CERT_FILE"
  rm -f /tmp/san.cnf
fi

exec /app/main
