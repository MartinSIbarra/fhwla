# :globe_with_meridians: Hosting gratis con arquitectura local

### :gear: Pre-requisitos

- [Configuraciones](#configuraciones)
- [Nodo (opcional)](#nodo-opcional)
- [Software (opcional)](#software)

---

### Configuraciones

###

- **[Ngrok](https://ngrok.com/)**

  Se debe obtener un token y un dominio para la configuración del entorno, ambos se pueden obtener de forma gratuita luego de generar una cuenta en Ngrok.

#####

- **[DuckDNS](https://www.duckdns.org/)**

  Se debe obtener un subdominio de DuckDNS, el mismo se utilizará para tener una dirección estática para el uso de la VPN.

#####

- **[Port Forwarding](https://www.redeszone.net/tutoriales/configuracion-puertos/abrir-puerto-tcp-udp-router/)**

  Se debe realizar el "forwardeo" de puertos en el router para redirigir el tráfico del puerto donde escucha el servidor de **_WireGuard_**, por defecto el servidor ya se encuentra configurado para escuchar el puerto 51820, de la misma manera que el "nodo" **_Vagrant_** si se usa. El forwardeo de puertos se debe realizar desde el router a la máquina host física donde se ejecuta la solución.

---

### Nodo (opcional)

El proyecto incluye un **_Vagrantfile_** configurado para servir de "nodo" donde desplegar la solución, esta máquina virtual se puede utilizar tanto en sistemas operativos Linux como Windows, y aunque no es necesario es recomendable para aislar el entorno de la máquina host física. Así mismo ya viene configurada con las dependencias de software necesarias.

Para poder utilizar el "nodo" es requerido el siguiente software:

- [VirtualBox](https://www.virtualbox.org/) se utiliza para poder ejecutar **_Vagrant_**. [Instalación](https://www.virtualbox.org/wiki/Downloads)

#####

- [Vagrant](https://developer.hashicorp.com/vagrant/) es una máquina virtual sin entorno gráfico que ejecuta sobre VirtualBox, tiene la ventaja de ser liviana y altamente configurable. [Instalación](https://developer.hashicorp.com/vagrant/install)

---

### Software

El software requerido es necesario para el host del entorno, si se utiliza la solución de ["nodo"](#nodo-opcional) ya se encuentran instaladas por defecto las dependencias y no es necesario instalarlas en el host físico.

- **[Docker](https://www.docker.com/)**

  La solución utiliza Docker para la mayoría de sus componentes, con lo cual es requerido en el host del entorno. [Instalación](https://docs.docker.com/engine/install/)

  #####

- **[WireGuard](https://www.wireguard.com/)**

  Idealmente el host de la solución se puede conectar a la VPN para poder ser accedido remotamente por los peers y así facilitar el mantenimiento y configuración del entorno. [Instalación](https://www.wireguard.com/install/)

  #####

- **[Curl (recomendado)](https://curl.se/)**

  Se utiliza Curl para facilitar la descarga de los archivos de instalación y componentes del repositorio desde la terminal (aunque también se pueden realizar descargas manuales o clonar el repositorio).

  **_Debian / Ubuntu_**

  ```
  apt install -y curl
  ```

  **_Alpine_**

  ```
  apk add --no-cache curl
  ```

---

# [⬆︎](../README.md) [⬅︎ ](../README.md) [➡︎](instalacion-y-uso.md)
