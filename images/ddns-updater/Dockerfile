# Dockerfile para el contenedor de actualización de DDNS
FROM alpine:latest

ENV BIN_PATH="/usr/local/bin"

# Agrega scripts al contenedor
COPY ./bin/entrypoint.sh \ 
    ./bin/env.sh \
    ./bin/log.sh \
    ./bin/validate-params.sh \
    ./bin/ddns-updt.sh \
    ${BIN_PATH}/

# Instalar paquetes necesarios
RUN apk update \
    # Instala dependencias y herramientas
    && apk add --no-cache iproute2 curl nano jq bash \
    && rm -rf /var/cache/apk/* \
    # Establecer bash como shell predeterminado
    && sed -i 's|/bin/sh|/bin/bash|' /etc/passwd \
    # Agrega permisos de ejecución a los scripts
    && chmod +x ${BIN_PATH}/entrypoint.sh \
    && chmod +x ${BIN_PATH}/env.sh \
    && chmod +x ${BIN_PATH}/log.sh \
    && chmod +x ${BIN_PATH}/validate-params.sh \
    && chmod +x ${BIN_PATH}/ddns-updt.sh \
    # agregar aliases
    && echo "alias a='ls -la --color --group-directories-first'" >> /root/.bashrc

# Setea el entrypoint
ENTRYPOINT ["/bin/bash", "entrypoint.sh"]
