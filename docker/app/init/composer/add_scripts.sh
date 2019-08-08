#!/usr/bin/env bash

PUB_DIR=/var/www/html
APP_DIR=$PUB_DIR/laravel

# add scripts to composer.json
sed -i -e "/scripts/a \ $(<$PUB_DIR/init/composer/add_scripts.txt)" $APP_DIR/composer.json