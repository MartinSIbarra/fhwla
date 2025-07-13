#!/bin/bash
# Setea las variables de entorno para el entornos de produccion
export ENVIRONMENT="container"
export ROOT_PATH="$HOME"
export COMMONS_BIN_PATH="$BIN_PATH"
export CONFIG_PATH="$ROOT_PATH/config"
export TEMPLATES_PATH="$ROOT_PATH/templates"
export LOG_PATH="$ROOT_PATH/logs"
export PARAMS_FILE="$ROOT_PATH/params/params.json"

# Hace source para cargar la funcion log
source "$COMMONS_BIN_PATH/log.sh"

# Se crean los directorios necesarios si no existen
mkdir -p "$CONFIG_PATH" && chown "1000:1000" "$CONFIG_PATH"
mkdir -p "$TEMPLATES_PATH" && chown "1000:1000" "$TEMPLATES_PATH"
mkdir -p "$LOG_PATH" && chown "1000:1000" "$LOG_PATH"
