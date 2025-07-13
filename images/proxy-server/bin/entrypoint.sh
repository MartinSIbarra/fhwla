#!/bin/bash
set -o pipefail

# Hace source de las variables de entorno
source "$BIN_PATH/env.sh"

# Se valida el archivo de parametros
$COMMONS_BIN_PATH/validate_params.sh

# Ejecuta nginx en segundo plano
log "Starting nginx server in background..."
rm -f "/etc/nginx/http.d/ngrok-proxy.conf" 2>/dev/null || true
rm -f "$CONFIG_PATH/proxy/ngrok-proxy.conf" 2>/dev/null || true
nginx -g "daemon off;" &

# Lanzar un loop para actualizar la config cada X segundos en background
sleep 5
(
  while true; do
    $BIN_PATH/proxy-conf-updt.sh
    auto_update_time=$(jq -r '.proxy.auto_update_time' "$PARAMS_FILE")
    [ -z "$auto_update_time" ] && auto_update_time=60  # Default to 60 seconds if not set
    sleep $auto_update_time
  done
) &
log "Started background process to update proxy configuration every $auto_update_time seconds."

wait
