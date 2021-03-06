#!/usr/bin/env bash

PUB_DIR=/var/www/html
APP_DIR=$PUB_DIR/laravel

MYSQL_LOGIN_FILE_PATH=/root/mysql/root.cnf
DUMP_STRUCTURE_SQL_PATH=./db/init/dump_structure.sql

function setup () {
  COMPOSER_PATH=`which composer`
  LARAVEL_NEW=0

  if test $COMPOSER_PATH == '' ; then
    echo "composer install..."
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
  fi

  if [ ! -d src/laravel ]
  then
      echo "Laravel install..."
      cd src \
       && composer create-project --prefer-dist laravel/laravel laravel \
       && cd laravel/

      LARAVEL_NEW=1
      php artisan key:generate \
      && composer require --dev laravel/dusk \
      && php artisan dusk:install \
      && composer require --dev squizlabs/php_codesniffer \
      && composer require --dev nunomaduro/larastan \
      && cd ../../
  fi

  echo "Docker starting..."

  cd docker

  docker-compose up -d

  if test $LARAVEL_NEW -eq 1 ; then
     echo "Setting env"
     docker-compose exec app cp -f $PUB_DIR/init/env/.env $APP_DIR/.env
     docker-compose exec app cp -f $PUB_DIR/init/env/.env.testing $APP_DIR/.env.testing
     docker-compose exec app cp -f $PUB_DIR/init/env/.env.dusk.local $APP_DIR/.env.dusk.local
     docker-compose exec app cp -f $PUB_DIR/init/DuskTestCase.php $APP_DIR/tests/DuskTestCase.php
     docker-compose exec app cp -f $PUB_DIR/init/phpunit.xml $APP_DIR/phpunit.xml
     docker-compose exec app cp -f $PUB_DIR/init/phpcs.xml $APP_DIR/phpcs.xml
     docker-compose exec app cp -f $PUB_DIR/init/phpstan.neon $APP_DIR/phpstan.neon
     docker-compose exec app php $APP_DIR/artisan key:generate
     docker-compose exec app sh $PUB_DIR/init/env/add_key.sh
     docker-compose exec app sh $PUB_DIR/init/composer/add_scripts.sh
     docker-compose exec app sh $PUB_DIR/init/circleci/add_setting.sh
  fi

  docker-compose exec app dockerize -wait tcp://db:3306 -timeout 30s
  docker-compose exec app php $APP_DIR/artisan migrate --seed

  create_testing_db_tables

  echo "Laravel Server starting..."
  docker-compose exec -d app php $APP_DIR/artisan serve --host 0.0.0.0

  echo "
  +-----------------------------------+
         Laravel Docker Started.
     Please Access http://localhost/
  +-----------------------------------+
  "
}
function create_testing_db_tables () {
  echo "Creating testing database tables ..."
  docker-compose exec db mysqldump --defaults-extra-file=$MYSQL_LOGIN_FILE_PATH laravel_db -d > $DUMP_STRUCTURE_SQL_PATH
  docker-compose exec -T db mysql --defaults-extra-file=$MYSQL_LOGIN_FILE_PATH test_laravel_db < $DUMP_STRUCTURE_SQL_PATH
  rm -f $DUMP_STRUCTURE_SQL_PATH
}
function stop () {
  cd docker
  docker-compose down
  cd ../
}
function restart () {
  stop
  setup
}
function destroy() {
  cd docker && docker-compose down --rmi all
}
function connect () {
  case "$1" in
    "app"   ) connect_app_container ;;
    "db"    ) connect_db_container  ;;
    "mysql" ) connect_mysql         ;;
    ""      ) echo "Please specify the second argument. (app | db)"
  esac
}
function connect_app_container () {
  docker exec -it laravel_app /bin/bash
}
function connect_db_container () {
  docker exec -it laravel_db /bin/bash
}
function connect_mysql () {
  cd docker

  docker-compose exec db mysql --defaults-extra-file=$MYSQL_LOGIN_FILE_PATH
}
function clear_app_cache () {
    cd docker
    docker-compose exec app php $APP_DIR/artisan cache:clear
    docker-compose exec app php $APP_DIR/artisan config:clear
    docker-compose exec app php $APP_DIR/artisan route:clear
    docker-compose exec app php $APP_DIR/artisan view:clear
    docker-compose exec app php $APP_DIR/artisan clear-compiled
    cd ../src/laravel && composer dump-autoload
    rm -f bootstrap/cache/config.php \
           bootstrap/cache/services.php \
           bootstrap/cache/packages.php
}
function docker_prune () {
    # Bulk deletion of stopped containers
    yes | docker container prune

    # Bulk deletion of unused Volume
    yes | docker volume prune

    # Bulk deletion of unused networks
    yes | docker network prune
}
function help () {
  echo "
  +--------------------------------------------------+
            +-+- Laravel Docker Help -+-+

      setup   : Set up Laravel Docker.
      start   : Alias for setup.
      stop    : Stop the container.
      restart : Reboot the container.
      destroy : Delete containers and images.
      conn    :
           app   : Connect to app container.
           db    : Connect to db container.
           mysql : Connect to MySQL in db container.
      clear   : Clear Laravel cache.
      prune   : Delete all container volume networks
                that are not in use.
                [Caution]
                This command affects your entire
                docker environment.
      help    : Display help.

               +-+- Informations -+-+
      Repository of this script :
        https://github.com/rito328/laravel-docker

      Author : rito
          Twitter https://twitter.com/rito328
          Github  https://github.com/rito328

      Disclaimer:
      This script is for trying Laravel in the
      Docker environment.
      Please do not use in production environment.
      Although we are doing our best for code
      maintenance, we assume no responsibility
      even if you use this script and you suffer
      problems and suffer disadvantages.

      Have fun Laravel & Docker life!
  +--------------------------------------------------+
  "
}
function error_msg () {
  echo "Argument is missing. Please display help and check the argument.
  exp.) sh order.sh help
  "
}

case "$1" in
  "setup"   ) setup           ;;
  "start"   ) setup           ;;
  "stop"    ) stop            ;;
  "restart" ) restart         ;;
  "destroy" ) destroy         ;;
  "conn"    ) connect $2      ;;
  "clear"   ) clear_app_cache ;;
  "prune"   ) docker_prune    ;;
  "help"    ) help            ;;
  ""        ) error_msg       ;;
esac

