FROM alpine:latest

ENV BIN_PATH="/usr/local/bin"

# Agrega scripts al contenedor
COPY ./bin/entrypoint.sh \
    ./bin/env.sh \
    ./bin/log.sh \
    ./bin/validate-params.sh \
    ./bin/vpn-server-init.sh \
    ./bin/ssh-init.sh \
    ${BIN_PATH}/

# Agrega templates al contenedor
COPY ./templates/peer.conf \
    ./templates/server-peer-part.conf \
    ./templates/server-server-part.conf \
    /root/templates/

# Instalar paquetes necesarios
RUN apk update \
    # Instala dependencias y herramientas
    && apk add --no-cache openssh wireguard-tools iptables iproute2 tar wget curl nano jq bash \
    && rm -rf /var/cache/apk/* \
    # Establecer bash como shell predeterminado
    && sed -i 's|/bin/sh|/bin/bash|' /etc/passwd \
    # Crear path necesario para el servidor SSH
    && mkdir -p /var/run/sshd \
    # Generar las claves del host
    && ssh-keygen -A \
    # Agrega permisos de ejecución a los scripts
    && chmod +x ${BIN_PATH}/entrypoint.sh \
    && chmod +x ${BIN_PATH}/env.sh \
    && chmod +x ${BIN_PATH}/log.sh \
    && chmod +x ${BIN_PATH}/validate-params.sh \
    && chmod +x ${BIN_PATH}/vpn-server-init.sh \
    && chmod +x ${BIN_PATH}/ssh-init.sh \
    # agregar aliases
    && echo "alias a='ls -la --color --group-directories-first'" >> /root/.bashrc

# Exponer el puerto SSH
EXPOSE 22

# Setea el entrypoint
ENTRYPOINT ["/bin/bash", "entrypoint.sh"]
