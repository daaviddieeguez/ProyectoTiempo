FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip curl git \
    && docker-php-ext-install pdo pdo_mysql zip

COPY ./Apache/000-default.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    composer global require laravel/installer

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN a2enmod rewrite

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
