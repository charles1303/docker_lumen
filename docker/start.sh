#!/bin/bash

. docker/app_start_up.sh

# Now start our various services...
# Start php-fpm
service php5.6-fpm restart

# Start nginx in foreground. This will keep the docker image open.
nginx -g 'daemon off;'
