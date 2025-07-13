#!/bin/bash
set -o 'pipefail'

# Hace source de las variables de entorno
source "$BIN_PATH/env.sh"

# Se establece la contraceña de root para poder usar SSH
error_messages=()
vpn_ipv4_net=$(jq -r '.vpn.ipv4_net' "$PARAMS_FILE") && [ -n "$vpn_ipv4_net" ] || error_messages+=("vpn.ipv4_net is not set in $PARAMS_FILE")
ssh_passwd=$(jq -r '.vpn.ssh_passwd' "$PARAMS_FILE") && [ -n "$ssh_passwd" ] || error_messages+=("vpn.ssh_passwd is not set in $PARAMS_FILE")
if [ ${#error_messages[@]} -ne 0 ]; then
    for message in "${error_messages[@]}"; do
        log "Error: $message"
    done
    exit 1
fi

echo "root:$ssh_passwd" | chpasswd

sshd_config_file="/etc/ssh/sshd_config"
sshd_config_file_backup="/etc/ssh/sshd_config.bak"

# Backup del archivo original
cp "$sshd_config_file" "$sshd_config_file_backup"

# Eliminar bloques previos si ya existen (limpio antiguos Match root)
sed -i "/^AllowTcpForwarding/d" "$sshd_config_file"
sed -i "/^PermitOpen/d" "$sshd_config_file"
sed -i "/^PermitTunnel/d" "$sshd_config_file"
sed -i "/^#InicioCustomSettings/,/^#FinCustomSettings/d" "$sshd_config_file"

# Agregar al final la configuración nueva
cat << EOF >> "$sshd_config_file"
#InicioCustomSettings
# Permitir acceso TCP y tunelización
AllowTcpForwarding yes
PermitOpen any
PermitTunnel yes
# Permitir acceso root con clave solo desde la VPN
PermitRootLogin yes
Match Address $vpn_ipv4_net User root
    PasswordAuthentication yes
#FinCustomSettings

EOF

# Validar configuración
echo "Validando configuración..."
ssh_test=$(/usr/sbin/sshd -t)
if [ -n "$ssh_test" ]; then
    log "OpenSSH server configuration failed."
    cp "$sshd_config_file_backup" "$sshd_config_file"
    exit 1
else
    # Se inicia el servicio SSH
    /usr/sbin/sshd
    log "OpenSSH server started successfully."
fi
