#!/bin/bash

IMAGE_NAME="ipay"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$(dirname "${SCRIPT_DIR}")"

if [[ $(docker inspect --format='{{.RepoTags}}' ${IMAGE_NAME}) == "[${IMAGE_NAME}:latest]" ]]; then
    echo " ----- Web App Image Available for Use. -----"
else
    echo " ----- Web App Image Does Not Exist. Building Now. -----"
    docker build -t ${IMAGE_NAME} ${ROOT}
fi

echo " ----- Appending Chosen App Host Name to /etc/hosts, if required -----"
${ROOT}/docker/add_host_entry.sh


${ROOT}/docker/start_nginx.sh

docker-compose -p ipay_ up -d

echo " ----- Starting Disposable Ipay Container -----"
docker run \
    -i \
    -t \
    -p 8080 \
    -v ${ROOT}:/var/www \
    --env-file=${ROOT}/.env \
    --network=ipay_main-network \
    ${IMAGE_NAME} \
    sh -c "docker/prep.sh && docker/app_start_up.sh && service nginx restart && service php5.6-fpm restart && bash"

docker ps -a | grep Exited | awk '{ print $1,$2 }' | \
grep ${IMAGE_NAME} |  awk '{print $1 }' | xargs -I {} docker rm {}

