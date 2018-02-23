
FROM php:7.2.2-fpm
MAINTAINER Laurynas Sakalauskas <laurynas@sakalauskas.co.uk>

# Install PHP Dependencies
RUN \
    apt-get update && \
    apt-get install git libxrender1 libfontconfig1 libpcre3-dev libbz2-dev zip unzip libfreetype6-dev libjpeg62-turbo-dev libpng-dev libxml2-dev libxslt-dev build-essential pkg-config libssl-dev -y && \
    pecl channel-update pecl.php.net && \
    pecl install mongodb xdebug && \
    docker-php-ext-enable mongodb xdebug && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install -j$(nproc) pcntl exif soap gd xsl mbstring pdo pdo_mysql zip bz2 bcmath

# Install Composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
  && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
  && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { echo 'Invalid installer' . PHP_EOL; exit(1); }" \
  && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer \
  && php -r "unlink('/tmp/composer-setup.php');" \
  && php -r "unlink('/tmp/composer-setup.sig');"

ENV PATH /composer/vendor/bin:$PATH
