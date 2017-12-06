#!/bin/bash
cd /var/www
#composer update
#php artisan migrate
#php artisan db:seed
#php artisan key:generate
#This will allow the application to bind to whatever
#IP address docker assigns to the running container
#php artisan serve --host=0.0.0.0 --port=8080
php -S 0.0.0.0:8080 -t public