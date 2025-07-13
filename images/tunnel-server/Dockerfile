FROM alpine:latest

ENV BIN_PATH="/usr/local/bin"

# Agrega scripts al contenedor
COPY ./bin/entrypoint.sh \
    ./bin/env.sh \
    ./bin/log.sh \
    ./bin/validate-params.sh \
    ./bin/ngrok-start.sh \
    ${BIN_PATH}/

# Instalar paquetes necesarios
RUN apk update \
    # Instala dependencias y herramientas
    && apk add --no-cache curl gnupg ca-certificates nano jq bash \
    # Agrega ngrok al contenedor
    && curl -sSfL https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.tgz | tar -xz -C ${BIN_PATH} \
    && rm -rf /var/cache/apk/* \
    # Establecer bash como shell predeterminado
    && sed -i 's|/bin/sh|/bin/bash|' /etc/passwd \
    # Crear path necesario para nginx
    && mkdir -p /run/nginx \
    # Agrega permisos de ejecución a los scripts
    && chmod +x ${BIN_PATH}/entrypoint.sh \
    && chmod +x ${BIN_PATH}/env.sh \
    && chmod +x ${BIN_PATH}/log.sh \
    && chmod +x ${BIN_PATH}/validate-params.sh \
    && chmod +x ${BIN_PATH}/ngrok-start.sh \
    # Agrega alias para facilitar el uso
    && echo "alias a='ls -la --color --group-directories-first'" >> /root/.bashrc

# Expone el puerto para nginx
EXPOSE 5000

# Setea el entrypoint
ENTRYPOINT ["/bin/bash", "entrypoint.sh"]
