# Laravel Docker Starter
Docker development environment construction package for Laravel application. [for Mac]  

## System requirements
- Docker for Mac must be installed.
- composer (If it is not installed, it will be installed at setup time.)
## Operation confirmed environment
- macOS Catalina
- Docker Desktop for Mac: 2.4.0.0
  - Engine: 19.03.13
  - Compose: 1.27.4
## Environment to be built
### app container
- CentOS 8
  - Apache 2.4
  - PHP 7.4
  - Laravel: Latest edition
    - Dusk
    - PHP_CodeSniffer
    - PHPStan with Larastan
  - Chrome(latest. for Dusk)
### DB container
- MySQL: 8.0
### Email Client container
- MailHog
## Project Structure
```
laravel-docker/
├── README.md
├── .circleci
│   ├── config.yml
├── docker
│   ├── app
│   │   ├── Dockerfile               ... Dockerfile for applications
│   │   └── init
│   │       ├── circleci
│   │       │    ├── add_setting.sh  ... Add setting to database config
│   │       │    └── setting.txt     ... Scripts to add to database config
│   │       ├── composer
│   │       │    ├── add_scripts.sh  ... Add scripts to composer.json
│   │       │    └── add_scripts.txt ... Scripts to add to composer.json
│   │       ├── env
│   │       │    ├── .env                 ... Laravel env file
│   │       │    ├── .env.testing         ... Laravel env file for testing
│   │       │    ├── .env.dusk.local      ... Laravel env file for Dusk
│   │       │    └── add_key.sh           ... Add genarated key to env file for testing and env file for dusk
│   │       ├── app_setting.sh       ... Shell for starting application server
│   │       ├── DuskTestCase.php     ... Base TestCase Class for Dusk
│   │       ├── google-chrome.repo   ... Repository for google-chrome-stable
│   │       ├── phpcs.xml            ... PHP_CodeSniffer Rule definition（PSR-12）
│   │       ├── phpstan.neon         ... Larastan Setting file（PHPStan）
│   │       └── phpunit.xml          ... PHPUnit Setting file
│   ├── db
│   │   ├── Dockerfile         ... Dockerfile for Database
│   │   ├── conf.d
│   │   │   └── my.cnf         ... MySQL configuration file
│   │   └── init
│   │       └── create_test_db.sh ... shellscript for create testing db
│   └── docker-compose.yml     ... The app and db containers are managed by docker-compose.
├── order.sh                   ... ShellScript to operate Laravel and Docker
└── src                        ... Laravel source and configuration file installation directory
```
## Getting started
```
// Download sources
git clone https://github.com/rito328/laravel-docker.git

// Go to the laravel-docker directory.
cd /path/to/laravel-docker

// When you start setup, Laravel will be installed and the Docker environment will be launched.
sh order.sh setup
```
> !! memo !!
>> Since migration and seeding are executed during Laravel setup, initial data can be input by defining these in advance.

When setup is complete, access localhost.
```
http://localhost/
```
You can check the sent email with MailHog.
```
http://localhost:8025
```
Once setup is done, operation can be controlled by start / stop.
```
// stop
sh order.sh stop 

// start
sh order.sh start
```
The Laravel project will be installed under ```src/```
```
laravel-docker/
└── src
     └── laravel
```
The Laravel project mounts from an external volume, so it will be persisted.

## Commands
```
sh order.sh setup      : Set up Laravel Docker.
sh order.sh start      : Alias for setup.
sh order.sh stop       : Stop the container.
sh order.sh restart    : Reboot the container.
sh order.sh destroy    : Delete containers and images.
sh order.sh prune      : Delete all container volume networks that are not in use.
sh order.sh conn app   : Connect to app container.
sh order.sh conn db    : Connect to db container.
sh order.sh conn mysql : Connect to MySQL in db container.
sh order.sh help       : Display help.
```
> !! important !!
>> `sh order.sh prune` affects the entire docker environment beyond the laravel-docker range. Use it only when you want to delete all container volume networks that you no longer use.

## Custom Composer Commands
The following custom Composer commands are available with Laravel installed:
```
composer lint            : Syntax check with PHP_CodeSniffer (phpcs).
composer lint-report-xml : Output syntax check result to XML file.
composer lint-report-csv : Output syntax check result to CSV file.
composer lint-rewrite    : Automatically correct errors detected by syntax checking with phpcbf.
composer analyse         : Perform static code analysis in PHPStan.
```

## Message
This package made Laravel easy to try under Docker environment.
Since we are also committing some configuration files, we do not recommend deploying these source file sets directly in the production environment.

Have fun Laravel & Docker life!
