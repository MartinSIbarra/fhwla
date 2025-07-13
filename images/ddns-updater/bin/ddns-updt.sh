#!/bin/bash

# Hace source de las variables de entorno
source "$BIN_PATH/env.sh"

log "Updating DuckDNS domain..."
error_messages=()
duckdns_domain=$(jq -r '.ddns.duckdns_domain' "$PARAMS_FILE") && [ -n "$duckdns_domain" ] || error_messages+=("ddns.duckdns_domain is not set in $PARAMS_FILE")
duckdns_token=$(jq -r '.ddns.duckdns_token' "$PARAMS_FILE") && [ -n "$duckdns_token" ] || error_messages+=("ddns.duckdns_token is not set in $PARAMS_FILE")
if [ ${#error_messages[@]} -ne 0 ]; then
    for message in "${error_messages[@]}"; do
        log "Error: $message"
    done
    exit 1
fi
log "DuckDNS domain: $duckdns_domain"
log "DuckDNS token: $duckdns_token"

url="https://www.duckdns.org/update?domains=$duckdns_domain&token=$duckdns_token&ip="

# Ejecutar curl y capturar la respuesta
response=$(echo url="$url" | curl -k -s -K -)

log "DuckDNS update response: $response"
