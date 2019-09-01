FROM centos:latest

RUN yum -y install yum-utils && package-cleanup --oldkernels && yum -y update && yum -y install httpd openssl unzip wget

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
 && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
 && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN yum -y install epel-release \
 && rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm \
 && yum -y install --enablerepo=remi,remi-php73 php \
php-opcache php-devel php-mbstring php-mcrypt php-mysqlnd php-phpunit-PHPUnit \
php-pecl-xdebug php-gd php-intl php-symfony php-pdo php-xml php-tokenizer php-pear php-zip \
 && yum -y install composer

# Google Chrome for Dusk install
COPY ./init/google-chrome.repo /etc/yum.repos.d/google-chrome.repo
RUN yum -y install google-chrome-stable

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/var/www/html/init/app_setting.sh"]