#!/bin/bash

set -e

source "$BIN_PATH/env.sh"
# Hace source para cargar la funcion log
source "$COMMONS_BIN_PATH/log.sh"

# Verifica si el archivo de parametros existe y tiene contenido si no existe termina la ejecucion
if [ ! -s "$PARAMS_FILE" ]; then
    log " Params file not found, please add to \"$PARAMS_FILE\"."
    exit 1
fi
