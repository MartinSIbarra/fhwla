#!/bin/bash
set -o pipefail

# Hace source de las variables de entorno
source "$BIN_PATH/env.sh"

# Se valida el archivo de parametros
$COMMONS_BIN_PATH/validate_params.sh

# Ejecuta el tunnel ngrok en segundo plano
log "Starting ngrok tunnel..."
$BIN_PATH/ngrok-start.sh &

tail -f /dev/null
