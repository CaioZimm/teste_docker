FROM php:8.3.10-fpm-alpine

RUN apk add --no-cache \
    bash \
    curl \
    libpng-dev \
    libzip-dev \
    zlib-dev \
    mysql-client \
    && docker-php-ext-install gd zip pdo_mysql

RUN curl -sSL https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz | tar -C /usr/local/bin -xz

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . /var/www

WORKDIR /var/www

RUN composer install --no-dev --optimize-autoloader \
    && apk add --no-cache nodejs npm \
    && php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache \
    && php artisan key:generate

EXPOSE 8080

CMD ["sh", "-c", "dockerize -wait tcp://${DB_HOST:-mysql}:${DB_PORT:-3306} -timeout 60s sh -c 'php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8080'"]