#!/bin/bash
set -o 'pipefail'

# Hace source de las variables de entorno
source "$BIN_PATH/env.sh"

# Se valida el archivo de parametros
$COMMONS_BIN_PATH/validate-params.sh

duckdns_update_time=""
last_duckdns_update_time=""
(
  while true; do
    $BIN_PATH/ddns-updt.sh
    duckdns_update_time=$(jq -r '.ddns.duckdns_update_time' "$PARAMS_FILE")
    [ -z "$duckdns_update_time" ] && duckdns_update_time=3600  # Default if not set

    if [ -z "$last_duckdns_update_time" ]; then
      log "Started background process to update DDNS(DuckDNS) every $duckdns_update_time seconds."
      last_duckdns_update_time="$duckdns_update_time"
    elif [ "$duckdns_update_time" != "$last_duckdns_update_time" ]; then
      log "Update time to update DDNS(DuckDNS) changed from every $last_duckdns_update_time seconds to every $duckdns_update_time seconds."
      last_duckdns_update_time="$duckdns_update_time"
    else
      log "DDNS(DuckDNS) will be updated every $duckdns_update_time seconds."
    fi
    sleep $duckdns_update_time
  done
) &

wait
