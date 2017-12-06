#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$(dirname "${SCRIPT_DIR}")"

HOSTNAME=`cat ${ROOT}/.env | grep "VIRTUAL_HOST" | awk -F"=" '{print $2}'`

NATIVE=0
docker-machine > /dev/null 2>&1
if [[ "$?" != "0" ]];
then
    echo "Running Docker Natively"
    NATIVE=1
else
    echo "Running Docker Machine"
fi

DOCKER_ACCESS_IP="0.0.0.0"
if [ ${NATIVE} -eq 0 ]; then
    DOCKER_ACCESS_IP=`docker-machine ip default`
fi

if [ "$(cat /etc/hosts | grep ${DOCKER_ACCESS_IP} 2> /dev/null)" = "" ];
then
   echo "----- Adding Docker Machine IP and Hostname to /etc/hosts -----"
   echo "$DOCKER_ACCESS_IP $HOSTNAME" | sudo tee -a /etc/hosts
else
    # We found an entry for hosts - now lets see if we find an entry for our particular hostname
    if [ "$(cat /etc/hosts | grep ${DOCKER_ACCESS_IP} | grep ${HOSTNAME} 2> /dev/null)" = "" ]; then
        echo "----- Adding Hostname to /etc/hosts -----"
        sudo sed -i '' "/^${DOCKER_ACCESS_IP}/ s/$/ ${HOSTNAME}/" /etc/hosts
    fi
fi
