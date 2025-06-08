#!/bin/bash
set -e

if [ -z "$(ls -A /var/www/html)" ]; then
  echo "No se encontró proyecto Laravel, creando uno..."
  composer create-project laravel/laravel /var/www/html
  chown -R www-data:www-data /var/www/html
fi

echo "Iniciando Apache..."
exec apache2-foreground
