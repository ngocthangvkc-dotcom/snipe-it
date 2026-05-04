FROM php:8.2-cli

WORKDIR /app

# Cài extension cần thiết
RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev zip \
    libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring zip gd

# Copy source
COPY . .

# Cài composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Cài Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Fix permission
RUN chmod -R 775 storage bootstrap/cache

# Run Laravel
CMD php artisan serve --host=0.0.0.0 --port=$PORT
