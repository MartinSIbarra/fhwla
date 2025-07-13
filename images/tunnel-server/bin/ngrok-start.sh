#!/bin/bash
set -o pipefail

# Hace source de las variables de entorno
source "$BIN_PATH/env.sh"

log_file="$LOG_PATH/ngrok.log"

error_messages=()
ngrok_auth_token=$(jq -r '.tunnel.ngrok_auth_token' "$PARAMS_FILE") && [ -n "$ngrok_auth_token" ] || error_messages+=("tunnel.ngrok_auth_token is not set in $PARAMS_FILE")
ngrok_tunnel_url=$(jq -r '.tunnel.ngrok_tunnel_url' "$PARAMS_FILE") && [ -n "$ngrok_tunnel_url" ] || error_messages+=("tunnel.ngrok_tunnel_url is not set in $PARAMS_FILE")
ngrok_tunnel_port=$(jq -r '.tunnel.ngrok_tunnel_port' "$PARAMS_FILE") && [ -n "$ngrok_tunnel_port" ] || error_messages+=("tunnel.ngrok_tunnel_port is not set in $PARAMS_FILE")
if [ ${#error_messages[@]} -ne 0 ]; then
    for message in "${error_messages[@]}"; do
        log "Error: $message"
    done
    exit 1
fi

log "Using ngrok with the following parameters:"
log "ngrok_auth_token: $ngrok_auth_token"
log "ngrok_tunnel_url: $ngrok_tunnel_url"
log "ngrok_tunnel_port: $ngrok_tunnel_port"
log "ngrok_log_file: $log_file"
[ "$ENVIRONMENT" == "container" ] \
    && rm -f "$log_file" \
    && ngrok http proxy-server:$ngrok_tunnel_port --url=$ngrok_tunnel_url --authtoken=$ngrok_auth_token --log=$log_file
log "Ngrok tunnel started."

chown "1000":"1000" "$log_file"
