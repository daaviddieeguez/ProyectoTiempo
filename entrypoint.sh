#!/bin/bash
set -e

cd /var/www/html

if [ ! -f "composer.json" ]; then
    echo "Instalando Laravel..."
    composer create-project laravel/laravel . --prefer-dist
fi

if [ -f ".env.example" ] && [ ! -f ".env" ]; then
    cp .env.example .env
    sed -i "s/DB_DATABASE=.*/DB_DATABASE=mariadb/" .env
    sed -i "s/DB_USERNAME=.*/DB_USERNAME=admin/" .env
    sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=admin/" .env
    sed -i "s/DB_HOST=.*/DB_HOST=mariadb/" .env
    sed -i "s/DB_PORT=.*/DB_PORT=3306/" .env
fi

chown -R www-data:www-data /var/www/html
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

exec apache2-foreground
