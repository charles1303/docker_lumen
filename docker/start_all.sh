#!/bin/bash


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$(dirname "${SCRIPT_DIR}")"

echo " ----- Appending Chosen App Host Name to /etc/hosts, if required -----"
${ROOT}/docker/add_host_entry.sh

echo " ----- Starting ALL Docker Containers -----"

${ROOT}/docker/start_nginx.sh

docker-compose -p ipay_ -f docker-compose.yml -f docker-compose.web_app.yml up -d

echo " ----- The Following Docker Containers Are Running -----"

# Just in case there are MANY other docker containers running, grep on the specific ones we have started via the
# docker-compose file. These names match those in the compose file (or they should).
docker ps | grep nginx_proxy
docker ps | grep ipay_mariadb
docker ps | grep ipay_redis
docker ps | grep ipay_app

