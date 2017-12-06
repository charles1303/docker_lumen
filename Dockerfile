# Use the predefined node base image for this module.
FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
RUN echo "Africa/Lagos" > /etc/timezone; dpkg-reconfigure tzdata

RUN apt-get update
RUN apt-get -y install software-properties-common
RUN apt-get update
RUN add-apt-repository ppa:ondrej/php -y


RUN apt-get update && apt-get install -y --force-yes \
    python \
    build-essential \
    ca-certificates \
    curl \
    nodejs \
    npm \
    php5.6 \
    php5.6-dev \
    php5.6-cli \
    php5.6-json \
    php5.6-fpm \
    php5.6-intl \
    php5.6-curl \
    php5.6-gd \
    php5.6-redis \
    php5.6-xml \
    php5.6-zip \
    php5.6-mbstring \
    unzip \
    php5.6-mcrypt \
    libpcre3-dev \
    php5.6-mysql \
    mysql-client-5.6 \
    pdo-mysql \
    nginx --fix-missing

# Mcrypt
RUN phpenmod mcrypt

# Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Allow shell for www-data (to make composer commands)
RUN sed -i -e 's/\/var\/www:\/usr\/sbin\/nologin/\/var\/www:\/bin\/bash/' /etc/passwd

# UMASK par defaut
RUN sed -i -e 's/^UMASK *[0-9]*.*/UMASK    002/' /etc/login.defs

# CONF PHP-FPM
RUN sed -i "s/^listen\s*=.*$/listen = 127.0.0.1:9000/" /etc/php/5.6/fpm/pool.d/www.conf

RUN sed -i "s/display_errors = .*/display_errors = stderr/" /etc/php/5.6/fpm/php.ini && \
    sed -i "s/memory_limit = .*/memory_limit = 2048M/" /etc/php/5.6/fpm/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = Africa\/Lagos/" /etc/php/5.6/fpm/php.ini && \
    sed -i "s/max_execution_time = .*/max_execution_time = 300/" /etc/php/5.6/fpm/php.ini && \
    sed -i "s/max_input_time = .*/max_input_time = 300/" /etc/php/5.6/fpm/php.ini && \
    sed -i "s/post_max_size = .*/post_max_size = 32M/" /etc/php/5.6/fpm/php.ini && \
    sed -i "s/upload_max_filesize = .*/upload_max_filesize = 32M/" /etc/php/5.6/fpm/php.ini

# CONF PHP-CLI
RUN sed -i "s/;date.timezone.*/date.timezone = Africa\/Lagos/" /etc/php/5.6/cli/php.ini

# CONF Nginx
ADD docker/vhost.conf /etc/nginx/sites-enabled/default

# ------ From here on we do specifics for our code. The above commands were just to build up our container. ------

# Install git
RUN apt-get install -y --fix-missing git vim && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create all files and folders for php
RUN if [ ! -d /etc/php/5.6/mods-available/ ] ; then mkdir /etc/php/5.6/mods-available/ ; fi && \
	if [ ! -d /etc/php/5.6/fpm/conf.d/ ] ; then mkdir /etc/php/5.6/fpm/conf.d/ ; fi && \
	if [ ! -d /etc/php/5.6/cli/conf.d/ ] ; then mkdir /etc/php/5.6/cli/conf.d/ ; fi

# create the log directory
RUN mkdir -p /var/log/applications/ipay

# Make "runtime" directory for use by web-app. We set writable nature explicitly.
# /!\ DEVELOPMENT ONLY SETTINGS /!\
# Running PHP-FPM as root, required for volumes mounted from host
RUN sed -i.bak 's/user = www-data/user = root/' /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i.bak 's/group = www-data/group = root/' /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i.bak 's/--fpm-config /-R --fpm-config /' /etc/init.d/php5.6-fpm
# /!\ DEVELOPMENT ONLY SETTINGS /!\

# And give ownership to the log folder.
RUN chown -R www-data:www-data /var/log/applications/ipay

# This particular image works in the /var/www folder (which is where nginx points to)
# For compose, we copy the single file only (for docker cache) and afterward all the code.
WORKDIR /var/www

#INSTALL LUMEN
RUN composer global require "laravel/lumen-installer"

#SET LUMEN COMMAND TO BE USED GLOBALLY
RUN echo 'export PATH="$PATH:~/.composer/vendor/bin"' >> ~/.bashrc

# NOW we copy the code.
COPY . /var/www

# Ensure all the various scripts are executable
RUN chmod 700 /var/www/docker/*.sh

# Expose port
EXPOSE 8080

# Map a volume for the log files and add a volume to override the code
VOLUME ["/var/www", "/var/log/applications/ipay"]


# Finally, after all of this, ensure our image automatically seeks out and populates env vars and linked vars
# and starts up relevant nginx and php processes. We have a single script that does this for us, contained in our
# source code copied across earlier.
CMD ["bash", "/var/www/docker/start.sh"]
