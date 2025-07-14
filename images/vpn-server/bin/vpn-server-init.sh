#!/bin/bash
set -o 'pipefail'

# Hace source de las variables de entorno
source "$BIN_PATH/env.sh"

vpn_config_path="$CONFIG_PATH/vpn"
vpnkeys_list_file="$vpn_config_path/vpnkeys.list"
vpn_interface="$vpn_config_path/server.conf"

mkdir -p "$vpn_config_path"
chown "1000:1000" "$vpn_config_path"

[[ "$RUNNING_AS" == "container" ]] && wg-quick down "$vpn_interface" > /dev/null 2>&1 || true

# Se obtienen los parametros del archivo de configuracion
log "Loading parameters from $PARAMS_FILE..."
error_messages=()
vpn_server_url=$(jq -r '.vpn.server_url' "$PARAMS_FILE") && [ -n "$vpn_server_url" ] || error_messages+=("vpn.server_url is not set in $PARAMS_FILE")
vpn_port=$(jq -r '.vpn.port' "$PARAMS_FILE") && [ -n "$vpn_port" ] || error_messages+=("vpn.port is not set in $PARAMS_FILE")
vpn_ipv4_net=$(jq -r '.vpn.ipv4_net' "$PARAMS_FILE") && [ -n "$vpn_ipv4_net" ] || error_messages+=("vpn.ipv4_net is not set in $PARAMS_FILE")
IFS='.' read -r ipp1 ipp2 ipp3 dump <<< "$vpn_ipv4_net"
vpn_ipv4_mask="$ipp1.$ipp2.$ipp3"
vpn_ipv6_net=$(jq -r '.vpn.ipv6_net' "$PARAMS_FILE") && [ -n "$vpn_ipv6_net" ] || error_messages+=("vpn.ipv6_net is not set in $PARAMS_FILE")
vpn_peers_quantity=$(jq -r '.vpn.peers_quantity' "$PARAMS_FILE") && [ -n "$vpn_peers_quantity" ] || error_messages+=("vpn.peers_quantity is not set in $PARAMS_FILE")
if [ ${#error_messages[@]} -ne 0 ]; then
    for message in "${error_messages[@]}"; do
        log "Error: $message"
    done
    exit 1
fi

keys=()
generate_vpnkey_list() {
    local from=$1
    local peers_quantity=$2
    local file=$3
    local ivp4_mask=$4
    local last_ipv4_value=0
    for i in $(seq $from $peers_quantity); do
        if ([[ "$i" -eq 1 ]] || [[ "$i" -eq 2 ]]); then
            # Para los primeros dos peers, se asigna un valor especial, 101 y 102
            # 101 sera la direccion del servidor de vpn
            # 102 sera la direccion del host donde se ejecuta el servidor de vpn
            last_ipv4_value=$((i + 100))
        else
            # Para los siguientes peers, se asigna un valor secuencial a partir de 1
            last_ipv4_value=$((i - 2))
        fi
        private_key=$(wg genkey) 
        public_key=$(echo "$private_key" | wg pubkey)
        key="$private_key,$public_key,$ivp4_mask.$last_ipv4_value"
        echo "$key" | tee -a "$file" > /dev/null 2>&1
        keys+=("$key")
    done
}

vpn_peers_quantity=$((vpn_peers_quantity + 2)) # Se suman 2 peers para incluir el servidor y el host del servidor
# Verifica si el archivo de claves para la vpn existe y tiene contenido, si no existe lo crea y lo carga sino agrega las claves nuevas
if [ ! -s "$vpnkeys_list_file" ]; then
    rm -f "$vpnkeys_list_file"
    touch "$vpnkeys_list_file"

    generate_vpnkey_list "1" "$vpn_peers_quantity" "$vpnkeys_list_file" "$vpn_ipv4_mask"
else
    while IFS= read -r key; do
        keys+=("$key")
    done < "$vpnkeys_list_file"

    cant_vpnkeys="${#keys[@]}"
    start=$((cant_vpnkeys + 1))

    if [ "$start" -gt "$vpn_peers_quantity" ]; then
        log "Required peers quantity ($vpn_peers_quantity) already reached with $cant_vpnkeys keys."
    else
        generate_vpnkey_list "$start" "$vpn_peers_quantity" "$vpnkeys_list_file" "$vpn_ipv4_mask"
        chown -R "1000:1000" "$vpnkeys_list_file"
    fi
fi

rm -f "$vpn_config_path"/*.conf

# Toma la primera clave de la lista para el servidor y la elimina de la lista
key="${keys[0]}"
IFS=',' read -r server_private_key server_public_key server_vpn_ip <<< "$key"
keys=("${keys[@]:1}")

# Crea el archivo de configuracion del servidor con la primer parte del servidor
while IFS= read -r line; do
    line="${line//<server_vpn_ip>/$server_vpn_ip}"
    line="${line//<vpn_port>/$vpn_port}"
    line="${line//<server_private_key>/$server_private_key}"
    echo "$line" | tee -a "$vpn_interface" > /dev/null 2>&1

    chown -R "1000:1000" "$vpn_interface"
done < "$TEMPLATES_PATH/server-server-part.conf"

i=0
for key in "${keys[@]}"; do
    if [[ "$i" -eq 0 ]]; then
        # El primer peer se configura como el host del servidor
        vpn_peer_config_file="$vpn_config_path/host.conf"  
    else
        vpn_peer_config_file="$vpn_config_path/peer$i.conf"
    fi
    touch "$vpn_peer_config_file"
    IFS=',' read -r peer_private_key peer_public_key peer_vpn_ip <<< "$key"

    # Crea el archivo de configuracion del peer 
    while IFS= read -r line; do
        line="${line//<peer_vpn_ip>/$peer_vpn_ip}"
        line="${line//<peer_private_key>/$peer_private_key}"
        line="${line//<server_public_key>/$server_public_key}"
        line="${line//<vpn_port>/$vpn_port}"
        line="${line//<server_url>/$vpn_server_url}"
        ipv4_with_cidr="$vpn_ipv4_net/24"
        line="${line//<allowed_ips_ipv4>/$ipv4_with_cidr}"
        ipv6_with_cidr="$vpn_ipv6_net/64"
        line="${line//<allowed_ips_ipv6>/$ipv6_with_cidr}"
        echo "$line" | tee -a "$vpn_peer_config_file" > /dev/null 2>&1
    done < "$TEMPLATES_PATH/peer.conf"

    # Agrega la parte del peer al archivo de configuracion del servidor
    echo "" | tee -a "$vpn_interface" > /dev/null 2>&1
    while IFS= read -r line; do
        line="${line//<peer_vpn_ip>/$peer_vpn_ip}"
        line="${line//<peer_public_key>/$peer_public_key}"
        echo "$line" | tee -a "$vpn_interface" > /dev/null 2>&1
    done < "$TEMPLATES_PATH/server-peer-part.conf"

    chown -R "1000:1000" "$vpn_peer_config_file"

    ((i++))
done

[[ "$RUNNING_AS" == "container" ]] && wg-quick up "$vpn_interface"

log "WireGuard VPN server started successfully."
