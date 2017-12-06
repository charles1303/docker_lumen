#!/bin/bash

echo " ----- Stopping ALL Docker Containers -----"

docker-compose -p ipay_ -f docker-compose.yml -f docker-compose.web_app.yml stop


