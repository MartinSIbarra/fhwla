#!/bin/bash
set -o 'pipefail'

# Hace source de las variables de entorno
source "$BIN_PATH/env.sh"

# Se valida el archivo de parametros
$COMMONS_BIN_PATH/validate-params.sh

log "Starting OpenSSH server..."
$BIN_PATH/ssh-init.sh  &

log "Starting WireGuard VPN server..."
$BIN_PATH/vpn-server-init.sh  &

tail -f /dev/null
