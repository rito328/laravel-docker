FROM centos:latest

RUN yum -y install yum-utils \
 && dnf -y remove $(dnf repoquery --installonly --latest-limit=-1 -q) \
 && yum -y update \
 && yum -y install httpd openssl unzip wget

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
 && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
 && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN dnf -y install epel-release \
 && dnf -y install http://rpms.famillecollet.com/enterprise/remi-release-8.rpm \
 && dnf -y module install php:remi-7.4 \
 && dnf install -y php-opcache php-mcrypt php-mysqlnd php-pecl-xdebug php-gd php-intl php-pdo php-xml php-tokenizer php-pear php-zip php-bcmath \
 && wget https://getcomposer.org/installer -O composer-installer.php \
 && php composer-installer.php --filename=composer --install-dir=/usr/local/bin \
 && composer self-update

# Google Chrome for Dusk install
COPY ./init/google-chrome.repo /etc/yum.repos.d/google-chrome.repo
RUN yum -y install google-chrome-stable

CMD ["/var/www/html/init/app_setting.sh"]