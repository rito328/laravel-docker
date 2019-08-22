#!/usr/bin/env bash

PUB_DIR=/var/www/html
APP_DIR=$PUB_DIR/laravel

# add setting to config/database.php
sed -i -e "/'connections'/a \ $(<$PUB_DIR/init/circleci/setting.txt)" $APP_DIR/config/database.php