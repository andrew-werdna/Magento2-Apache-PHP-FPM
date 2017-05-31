FROM ubuntu:16.04

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y \
    curl \
    vim \
    man \
    git \
    software-properties-common \
    wget \
    dos2unix \
    zip \
    unzip \
    apt-transport-https \
    lsb-release \
    ca-certificates
    # tmux \
    # build-essential

RUN apt-get install -y apache2

RUN apt-get install -y \
    libapache2-mod-fastcgi \
    libmcrypt-dev \
    php7.0-fpm \
    php7.0 

RUN a2enmod alias rewrite fastcgi expires headers remoteip ssl actions
ADD ./php-fpm.conf /etc/apache2/conf-available/php-fpm.conf
RUN a2enconf php-fpm

RUN apt-get install -y \
    php7.0-mysql \
    php7.0-curl \
    php7.0-gd \
    php7.0-intl \
    php7.0-mbstring \
    php7.0-mcrypt \
    php7.0-xmlrpc \
    #php7.0-xml \
    php-xml \
    php7.0-zip

ADD ./getcomposer.sh /tmp/
RUN dos2unix /tmp/getcomposer.sh
RUN bash /tmp/getcomposer.sh

WORKDIR /var/www/html

ADD ./startups.sh /root/
RUN dos2unix /root/startups.sh && chmod 777 /root/startups.sh
RUN chown -R www-data:www-data /var/www/html
RUN sed -i 's/max_execution_time = 30/max_execution_time = 300/' /etc/php/7.0/cli/php.ini

ENTRYPOINT ["/root/startups.sh"]
CMD ["/bin/bash"]
