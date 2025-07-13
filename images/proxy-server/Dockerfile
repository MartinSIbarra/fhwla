FROM alpine:latest

ENV BIN_PATH="/usr/local/bin"

# Agrega scripts al contenedor
COPY ./bin/entrypoint.sh \
    ./bin/env.sh \
    ./bin/log.sh \
    ./bin/validate-params.sh \
    ./bin/proxy-conf-updt.sh \
    ${BIN_PATH}/

# Agrega templates al contenedor
COPY ./templates /root/templates

# Instalar paquetes necesarios
RUN apk update \
    # Instala dependencias y herramientas
    && apk add --no-cache nginx curl nano jq bash \
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
    && chmod +x ${BIN_PATH}/proxy-conf-updt.sh \
    # Agrega alias para facilitar el uso
    && echo "alias a='ls -la --color --group-directories-first'" >> /root/.bashrc

# Setea el entrypoint
ENTRYPOINT ["/bin/bash", "entrypoint.sh"]
