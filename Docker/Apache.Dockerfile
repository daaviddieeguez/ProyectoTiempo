FROM php:8.3-apache

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    git unzip zip libzip-dev libpng-dev libonig-dev libxml2-dev default-mysql-client \
    && docker-php-ext-install pdo_mysql zip

# Copiar Composer desde su imagen oficial
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Activar mod_rewrite de Apache
RUN a2enmod rewrite

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Copiar el código fuente (esto se sobreescribirá con el volumen en compose)
COPY ./proyectoTiempo /var/www/html

# Asignar permisos a carpetas necesarias de Laravel
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Exponer puerto 80
EXPOSE 80

# Usar el entrypoint para preparar el entorno al iniciar el contenedor
CMD ["apache2-foreground"]
