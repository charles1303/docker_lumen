#!/bin/bash

# Taken and adapted form original PHP5-fpm dockerfile by Robert Gründler that provided a "start.sh" script to
# dynamically find and populate environment variables. What a legend.

# Function to update the fpm configuration to make the service environment variables available
function setEnvironmentVariable() {

    if [ -z "$2" ]; then
        echo "Environment variable '$1' not set."
        return
    fi

    # Check whether variable already exists
    if grep -q "$1" /etc/php/5.6/fpm/pool.d/www.conf; then
        # Reset variable
        sed -i 's/^env\[$1.*/env[$1] = "$2"/g' /etc/php/5.6/fpm/pool.d/www.conf
    else
        # Add variable
        echo "env[$1] = \"$2\"" >> /etc/php/5.6/fpm/pool.d/www.conf
    fi
}


# Grep for variables that look like docker set them (_PORT_)
for _curVar in `env | grep ^REDIS_PORT_ | awk -F = '{print $1}'`;do
    # awk has split them by the equals sign
    # Pass the name and value to our function
    setEnvironmentVariable ${_curVar} ${!_curVar}
done

# Run through our local .env file and set it into the pool as well. We "execute" it beforehand so that it is picked up
# later. We dont want to throw in ALL the env vars... which is why we do it this way.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$(dirname "${SCRIPT_DIR}")"

. $ROOT/.env
for _curVar in `cat .env | awk -F = '{print $1}'`;do
    # awk has split them by the equals sign
    # Pass the name and value to our function
    setEnvironmentVariable ${_curVar} ${!_curVar}
done

echo "DONE"
