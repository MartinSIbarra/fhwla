#!/bin/bash
set -e

docker_hub_user=$(cat ./common/helpers/docker.hub.user.name)
image_name=$1
image_tag=$2

[ -z "$docker_hub_user" ] \
    && { echo "Docker Hub user (or some name) is required, if not exists, create common/helpers/docker.hub.user.name and place a username into it."; exit 1; }
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

docker rmi -f "$image_name:$image_tag" 2>/dev/null || true
docker build --no-cache -t "$image_name:$image_tag" "$image_path"

if [ -d "$image_scripts_path" ]; then
    for script in "${common_scripts[@]}"; do
        rm "$image_scripts_path/$(basename $script)"
    done
fi
