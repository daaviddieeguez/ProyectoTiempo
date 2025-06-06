FROM php:8.3-apache

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    git unzip zip libzip-dev libpng-dev libonig-dev libxml2-dev default-mysql-client \
    && docker-php-ext-install pdo_mysql zip

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Activar mod_rewrite de Apache
RUN a2enmod rewrite

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Instalar Laravel
RUN composer create-project laravel/laravel . --prefer-dist

# Configurar entorno Laravel
RUN cp .env.example .env && php artisan key:generate

# Permisos necesarios
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Exponer puerto 80
EXPOSE 80

CMD ["apache2-foreground"]
