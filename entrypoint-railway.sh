#!/bin/sh
set -eu

CERT_DIR="/app/certs"
CERT_KEY="$CERT_DIR/ssl_key.pem"
CERT_FILE="$CERT_DIR/ssl_cert.pem"

mkdir -p "$CERT_DIR"

NEED_CERT=0

if [ ! -s "$CERT_KEY" ] || [ ! -s "$CERT_FILE" ]; then
  NEED_CERT=1
elif ! SAN_OUTPUT="$(openssl x509 -in "$CERT_FILE" -noout -ext subjectAltName 2>/dev/null)"; then
  NEED_CERT=1
elif ! printf '%s\n' "$SAN_OUTPUT" | grep -Fq "DNS:pasarguard-node.railway.internal"; then
  NEED_CERT=1
elif ! printf '%s\n' "$SAN_OUTPUT" | grep -Fq "DNS:pasarguard-nod.railway.internal"; then
  NEED_CERT=1
elif ! printf '%s\n' "$SAN_OUTPUT" | grep -Fq "DNS:pasarguard-nood.railway.internal"; then
  NEED_CERT=1
elif ! printf '%s\n' "$SAN_OUTPUT" | grep -Fq "DNS:localhost"; then
  NEED_CERT=1
fi

if [ "$NEED_CERT" -eq 1 ]; then
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
DNS.2 = pasarguard-nod.railway.internal
DNS.3 = pasarguard-nood.railway.internal
DNS.4 = localhost
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
