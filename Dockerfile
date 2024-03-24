# Use PHP 8.2 image
FROM php:8.2-fpm

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libonig-dev \
    libzip-dev  # Install libzip-dev package \

#install netstat
RUN apt-get update && apt-get install net-tools 

#install systemctl 
RUN apt-get update && apt-get install -y systemctl

# Install Supervisor
RUN apt-get update && apt-get install -y supervisor && \
    rm -rf /var/lib/apt/lists/*

# Install RabbitMQ PHP extension
RUN apt-get update && apt-cache search librabbitmq-dev 
RUN apt-get update
RUN apt-get install -y librabbitmq-dev && pecl install amqp && docker-php-ext-enable amqp

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Install PHP and PHP-FPM
#RUN apt-get update && apt-get install -y php8.2 php8.2-fpm

# Copy existing application files
COPY . .

# Install phpMyAdmin (if available)
RUN apt-get update && apt-get install -y phpmyadmin || echo "phpmyadmin installation skipped"

# Create storage directory for Laravel logs
RUN mkdir -p /var/www/html/storage/logs/

# Copy Supervisor configuration file
#COPY laravel-worker.conf /etc/supervisor/conf.d/laravel-worker.conf
#ADD  supervisor.conf /etc/supervisor/conf.d/worker.conf 

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN  mkdir -p /run/supervisor/
RUN chown -R nobody:nogroup /run/supervisor/

RUN mkdir /var/log/supervisord/
RUN touch /var/log/supervisord/supervisord.log
COPY idle.conf /var/www/idle.sh

RUN chown -R root:root /var/log/supervisord/
RUN chmod -R 777 /var/www/idle.sh
RUN chmod o+w /var/log/supervisord/supervisord.log

COPY idle_script.sh /usr/local/bin/idle_script.sh

# Expose port 9000 and start php-fpm server
EXPOSE 9000

# Start PHP-FPM service
CMD ["php-fpm"]

# Start Supervisor when the container starts
RUN echo user=root >>  /etc/supervisor/supervisord.conf
#CMD ["/usr/bin/supervisord","-n"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
#CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
