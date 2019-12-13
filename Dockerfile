# 使用php 官方 php:7.1-fpm
# TO registry-vpc.cn-hangzhou.aliyuncs.com/mztb0511/nginx-phpfpm:7.1
FROM php:7.1-fpm

WORKDIR /var/www/html

RUN sed -i "s/archive.ubuntu./mirrors.aliyun./g" /etc/apt/sources.list \
    && sed -i "s/deb.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y nginx \
    && echo "<?php echo phpinfo();" >> //var/www/html/index.php \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && rm -rf /etc/nginx/sites-enabled/* \
    && echo "Asia/Shanghai" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

#配置php 扩展
RUN docker-php-ext-install bcmath \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install sockets \
    && pecl install redis\
    && docker-php-ext-enable redis

#虚拟主机配置文件
COPY default.conf /etc/nginx/sites-enabled/

#nginx 配置文件
COPY nginx.conf /etc/nginx/

#fpm 配置文件
COPY www.conf /usr/local/etc/php-fpm.d/

# 生命容器运行时提供的服务端口
EXPOSE 80

# 以前台方式运行nginx
CMD nohup /usr/local/sbin/php-fpm -D && service nginx start