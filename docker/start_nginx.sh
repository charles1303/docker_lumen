#!/bin/bash

NGINX_PROXY_NAME="nginx_proxy"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$(dirname "${SCRIPT_DIR}")"

echo " ----- Checking if nginx container has been run before... ----- "
if [ $(docker ps -a | grep ${NGINX_PROXY_NAME} | wc -l) -eq 1 ]; then

    # Check if this container is running. If so, stop it.
    if [[ $(docker inspect --format='{{.State.Status}}' ${NGINX_PROXY_NAME}) == "running" ]]; then
        echo " ----- Nginx Container Already Running. Stopping It. ----- "
        docker stop $(docker ps -a | grep ${NGINX_PROXY_NAME} | awk '{print $1}')
    fi

    echo " ----- Removing Existing Nginx Container ----- "
    docker rm $(docker ps -a | grep ${NGINX_PROXY_NAME} | awk '{print $1}')

fi

# Create the central "Certs" folder, if required, and copy our https certs across (if applicable to this repo)
# NB - we use the "central" ${HOME} location. All user's should have this and docker maps this into the docker-machine
# by default.
echo " ----- Ensuring certificates are in ${HOME}/certs directory, if required. ----- "
mkdir -p ${HOME}/certs

# Start the NGINX container, and map the certificates folder. We ensure this exists at the user's home directory.
echo " ----- Starting Nginx Container ----- "
docker run \
    -d \
    -p 81:81 \
    -p 443:443 \
    -v /var/run/docker.sock:/tmp/docker.sock:ro \
    -v ${HOME}/certs:/etc/nginx/certs \
    --name ${NGINX_PROXY_NAME} \
    jwilder/nginx-proxy

# docker-compose file. These names match those in the compose file (or they should).
docker ps | grep ${NGINX_PROXY_NAME}