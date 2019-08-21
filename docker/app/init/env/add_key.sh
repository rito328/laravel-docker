#!/usr/bin/env bash

PUB_DIR=/var/www/html
APP_DIR=$PUB_DIR/laravel
ENV=$APP_DIR/.env
ENV_TEST=$APP_DIR/.env.testing
ENV_DUSK=$APP_DIR/.env.dusk.local

APP_KEY=`grep -E "^APP_KEY=" $ENV`

sed -i -e "s|^APP_KEY=|$APP_KEY|g" $ENV_TEST
sed -i -e "s|^APP_KEY=|$APP_KEY|g" $ENV_DUSK
