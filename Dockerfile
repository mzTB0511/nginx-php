# 使用php 官方 php:7.1-fpm
# TO mztb0511/php:7.1-fpm
FROM php:7.1-fpm

WORKDIR /var/www/html

#安装jd pod_mysql sockets, redis ,mysqlli扩展
RUN sed -i "s/archive.ubuntu./mirrors.aliyun./g" /etc/apt/sources.list \
    && sed -i "s/deb.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list \
    && apt-get clean \
    && apt-get update \
    && echo "<?php echo phpinfo();" >> /var/www/html/index.php \
    && echo "Asia/Shanghai" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install sockets \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && docker-php-ext-install mysqli