# :globe_with_meridians: Hosting gratis con arquitectura local

### :rocket: Instalación y uso

- [Nodo (opcional)](#nodo)
- [Entorno](#entorno)

---

### Nodo

Para la instalación del nodo, una vez instalados los [pre-requisitos](pre-requisitos.md), simplemente se debe descargar el archivo Vagrantfile `/nodo/Vagrantfile` en el destino deseado y ejecutar el comando `vagrant up`.

- **Descarga**
  Utilizando curl (ejecuta el primer `vagrant up`):

  ```
  curl -sSLO https://raw.githubusercontent.com/MartinSIbarra/fhwla/refs/heads/main/nodo/Vagrantfile && vagrant up
  ```

###

- **Instalación de plugin para vbguest additions.**

  Luego de descargar y realizar el primer `vagrant up` se instalará el plugin para instalar los **_vbguest additions_**, luego de esto es necesario volver a ejecutar `vagrant up` nuevamente para iniciar la máquina virtual.

###

- **Instalación de vbguest additions.**

  Una vez instalado el plugin, al ejecutar `vagrant up` se instalarán los **_vbguest additions_** (a veces son necesarios para el correcto funcionamiento de todas las configuraciones de Vagrant) y también se instalarán las dependencias necesarias para poder desplegar el entorno.
  Es recomendable luego de la instalación de las dependencias y los **_vbguest additions_** reiniciar la máquina virtual, se puede hacer usando `vagrant reload`.

###

- **Uso luego de la instalación.**

  Una vez realizados los pasos anteriores quedará operativa e iniciada la máquina vagrant "nodo". Para poder ingresar se debe ejecutar el comando `vagrant ssh`, una vez dentro se puede utilizar como cualquier instalación de Linux, en este caso Ubuntu.

###

- **Configuración.**

  El archivo **_Vagrantfile_** contiene una pequeña sección de parámetros, que sirven para customizar el **_nodo_**.

  #####

  ```ruby
   user_params = {
      hostname: "", # Nombre del host, si no se completa toma por defecto "nodo"
      ssh_pwd: "", # Contraseña de ssh, si no se completa toma por defecto "vagrant"
      lan_ipv4_addr: "", # Dirección IPv4 de la red local, si no se completa toma por defecto "192.168.0.171"
      ram_memory: "", # Memoria RAM asignada a la VM, si no se completa toma por defecto "2048"
      cpus: "" # Cantidad de CPUs asignadas a la VM, por defecto 2
   }
  ```

  - **hostname**, pensado para diferenciar un nodo de desarrollo de un nodo de producción, puede tomar cualquier nombre pero no puede repetirse en el caso de querer utilizar más de un **_nodo_**.

  - **ssh_pwd**, es necesario para poder acceder al **_nodo_** desde fuera de la máquina física donde se ejecuta, por ejemplo desde la **_vpn_**.

  - **lan_ipv4_addr**, se utiliza para situar al **_nodo_** en la misma red que la máquina física donde ejecuta.

  - **ram_memory** y **cpus**, se utilizan para administrar los recursos que puede usar el **_nodo_**.

###

- _A continuación se listan los comandos más utilizados en Vagrant._

  | Comando              | Descripción                                                            |
  | -------------------- | ---------------------------------------------------------------------- |
  | `vagrant up`         | _Inicia y provisiona la máquina virtual definida en el `Vagrantfile`._ |
  | `vagrant reload`     | _Reinicia la máquina virtual y aplica cambios del `Vagrantfile`._      |
  | `vagrant ssh`        | _Se conecta por SSH a la máquina virtual._                             |
  | `vagrant halt`       | _Apaga la máquina virtual._                                            |
  | `vagrant halt -f`    | _Fuerza el apagado de la máquina virtual._                             |
  | `vagrant destroy -f` | _Elimina completamente la máquina virtual._                            |
  | `vagrant status`     | _Muestra el estado actual de la máquina virtual._                      |
  | `vagrant --help`     | _Muestra la ayuda del comando `vagrant`._                              |

---

### Entorno

Para instalar y configurar el entorno es necesario realizar los siguientes pasos:

- **Descargar archivo de configuración del entorno.**

  Descargar el archivo `docker-compose.yml` en el path deseado.
  Usando **_curl_** sería:

  ```
  curl -sSLO https://raw.githubusercontent.com/MartinSIbarra/fhwla/refs/heads/main/docker-compose.yml
  ```

###

- **Descargar y modificar el archivo parámetros.**

  En el path donde se descargó el archivo `docker-compose.yml` se debe crear una carpeta llamada `params` y dentro se debe descargar el archivo `/examples/params.json` en el path deseado.

  ###

  El siguiente comando crea la carpeta `params` y descarga `params.json` dentro.

  ```
  mkdir -p params && curl -sSLo ./params/params.json https://raw.githubusercontent.com/MartinSIbarra/fhwla/refs/heads/main/examples/params.json
  ```

  ###

  ***params/params.json**:*

  #####

  ```JSON
  {
    "ddns": {
       "duckdns_update_time": 5, //Indica en segundos cada cuánto se refresca la IP en DuckDNS
       "duckdns_domain": "mi-dominio-duckdns",
       "duckdns_token": "mi-token-duckdns"
    },
    "vpn": {
       "server_url": "mi-dominio-duckdns.duckdns.org",
       "port": "51820",
       "ipv4_net": "10.101.7.0",
       "ipv6_net": "fd00:101:7::",
       "peers_quantity": 20, // Indica la cantidad de peers que se conectarán a la vpn, se pueden generar de más.
       "ssh_passwd": "mi-contraseña-ssh"
    },
    "tunnel": {
       "ngrok_auth_token": "mi-token-ngrok",
       "ngrok_tunnel_url": "mi-dominio-ngrok.ngrok-free.app",
       "ngrok_tunnel_port": 5000 // Puerto sobre el cual se realizará el túnel, debe coincidir con el del proxy si se quiere utilizar este último.
    },
    "proxy": {
       "auto_update_time": 5,
       "listen_port": 5000, // Puerto en el cual escucha el proxy para rutear
       "apps": [
          {
            "url_path": "prod",
            "name": "prod-app", //Nombre de la aplicación web de producción.
            "port": 3000 // Puerto en el cual escucha la aplicación web de producción.
          },
          {
            "url_path": "uat",
            "name": "uat-app", //Nombre de la aplicación web de pruebas.
            "port": 3000 // Puerto en el cual escucha la aplicación web de pruebas.
          }
       ]
    },
    "log": {
       "max_file_size": 10000,
       "max_quantity_files": 6
    }
  }
  ```

  ###

- **Ejecutar el entorno.**

  Luego de descargar el archivo de parámetros se deben configurar los parámetros que se quieran personalizar.

  Una vez configurados los parámetros del entorno se debe ejecutar `docker compose up -d` para levantar el entorno. Una vez corriendo el entorno si no se detiene con `docker compose down` se reinciará cada vez que se reinicie la maquina host.

  ###

- **Configurar VPN.**

  Luego de lanzar el entorno, este ofrece un servidor de VPN. La idea es poder conectar el host del entorno a la VPN, para que este pueda ser accedido por los peers de la VPN para realizar las configuraciones o el mantenimiento necesario.

  Para esto, es ideal configurar **systemctl** para lanzar un servicio que se ejecute y se conecte a la VPN incluso cuando se reinicia el host.

  Para este objetivo, realiza los siguientes pasos:

  #####

  - En el path donde se encuentra el **docker-compose.yml**:
    ```bash
    sudo cp config/vpn/host.conf /etc/wireguard/
    ```
    Este comando copia el archivo de configuración creado por el componente **vpn-server** al path donde se encuentran las configuraciones de WireGuard.

    #####

  - Luego, ejecuta el siguiente comando:
    ```bash
    sudo systemctl enable wg-quick@host && sudo systemctl start wg-quick@host
    ```
    Este comando habilitará y disparará la ejecucion del servicio de WireGuard para conectarse con el servidor de VPN que provee el entorno. De esta manera, cualquier otro peer conectado a la VPN podrá acceder vía SSH al host del entorno. Luego cada vez que se reinicie la maquina host, el servicio realizará la conexión de forma automática.

  ###

---

# [⬆︎](../README.md) [⬅︎](./pre-requisitos.md) [➡︎](./desarrollo.md)
