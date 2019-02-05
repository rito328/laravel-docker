#!/bin/bash

# httpd start
/usr/sbin/httpd -DFOREGROUND

# Laravel Path
APP_DIR=/var/www/html/laravel

# Permission setting
chmod -R 777 $APP_DIR/storage $APP_DIR/bootstrap/cache