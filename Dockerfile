##############################################
# Dockerfile to build Apache HTTP server image
##############################################
# Base image
FROM ubuntu:16.04

# Author: MobileSnapp Inc.
MAINTAINER MobileSnapp <support@mobilesnapp.com>

# Install Apache HTTP server
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
      apache2 \
      curl \
    && rm -r /var/lib/apt/lists/*

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Assign working directory
WORKDIR /var/www/site/

# Expose web and SSL ports.
EXPOSE 80
EXPOSE 443

# Copy this repo into place.
ADD index.html /var/www/site

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# Activate mod_rewrites
RUN a2enmod rewrite

# Restart server
RUN service apache2 restart

# By default start up apache in the foreground, override with /bin/bash for interative.
CMD /usr/sbin/apache2ctl -D FOREGROUND