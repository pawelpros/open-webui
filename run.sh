#!/bin/bash

image_name="open-webui"
container_name="open-webui"
host_port=3000
container_port=8080

# SSL certificate paths (optional)
SSL_CERT_DIR="${SSL_CERT_DIR:-/var/tmp/certs}"
SSL_CERTFILE="${SSL_CERTFILE:-$SSL_CERT_DIR/tdx.sclab.intel.com.fullchain.crt}"
SSL_KEYFILE="${SSL_KEYFILE:-$SSL_CERT_DIR/tdx.sclab.intel.com.key}"

docker build -t "$image_name" .
docker stop "$container_name" &>/dev/null || true
docker rm "$container_name" &>/dev/null || true
docker volume rm "$container_name" &>/dev/null || true

# Build SSL volume and env args if certs exist
SSL_ARGS=()
if [ -f "$SSL_CERTFILE" ] && [ -f "$SSL_KEYFILE" ]; then
    echo "SSL certificates found, enabling HTTPS"
    SSL_ARGS=(
        -v "$SSL_CERT_DIR:/certs:ro"
        -e SSL_CERTFILE=/certs/tdx.sclab.intel.com.fullchain.crt
        -e SSL_KEYFILE=/certs/tdx.sclab.intel.com.key
    )
fi

docker run -d \
    --network=host \
    -v "${image_name}:/app/backend/data" \
    -e OLLAMA_BASE_URL=http://127.0.0.1:11434 \
    -e WEBUI_SESSION_COOKIE_SECURE=true \
    -e USER_PERMISSIONS_CHAT_TEMPORARY_ENFORCED=true \
    -e DATABASE_TYPE=sqlite+sqlcipher \
    -e DATABASE_PASSWORD=tdx_secure_db_key_2026 \
    "${SSL_ARGS[@]}" \
    --name "$container_name" \
    --restart always \
    --gpus=all \
    "$image_name"

docker image prune -f

