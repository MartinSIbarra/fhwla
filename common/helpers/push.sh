#!/bin/bash
set -e

docker_hub_user=$(cat ./common/helpers/docker.hub.user.name) \
    || { echo "./common/helpers/docker.hub.user.name must exists."; exit 1; }
image_name=$1
image_tag=$2

[ -z "$docker_hub_user" ] \
    && { echo "Docker Hub user (or some name) is required into \"./common/helpers/docker.hub.user.name\""; exit 1; }
[ -z "$image_name" ] && { echo "Image name is required"; exit 1; }
[ -z "$image_tag" ] && { echo "Image tag is required"; exit 1; }

common_scripts=(./common/bin/*) 
image_path="./images/$image_name"
image_scripts_path="$image_path/bin"

if [ -d "$image_scripts_path" ]; then
    for script in "${common_scripts[@]}"; do
        cp "$script" "$image_scripts_path/"
    done
fi

docker buildx create --use
docker buildx inspect --bootstrap
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --no-cache \
    -t "$docker_hub_user/$image_name:$image_tag" \
    --push \
    "$image_path"

if [ -d "$image_scripts_path" ]; then
    for script in "${common_scripts[@]}"; do
        rm "$image_scripts_path/$(basename $script)"
    done
fi

docker rmi "$docker_hub_user/$image_name:$image_tag" || true
docker pull "$docker_hub_user/$image_name:$image_tag"

# Verifica si hay contenedores que coincidan con el patrón 'buildx' y los elimina
mapfile -t containers < <(docker ps -a --format '{{.Names}}' | grep '^buildx')
if [ ${#containers[@]} -gt 0 ]; then
    docker rm -f "${containers[@]}"
fi
