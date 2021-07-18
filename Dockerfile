FROM php:7.4-apache
WORKDIR /usr/local/bin
COPY ./composer-install.sh .
COPY ./install-magento-core.sh .
RUN cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN apt update && apt install zip libssl-dev pkg-config zlib1g-dev libpng-dev libicu-dev libxml2-dev libzip-dev libxslt-dev libcurl4-openssl-dev libmagickwand-dev libjpeg-dev freetype2-demos -y
RUN ./composer-install.sh
RUN ln -snf composer.phar composer
RUN pecl install xdebug
RUN pecl install imagick
RUN echo zend_extension="/usr/local/lib/php/extensions/no-debug-non-zts-20190902/xdebug.so" >> /usr/local/etc/php/php.ini
RUN docker-php-ext-configure gd --with-jpeg --with-freetype
RUN docker-php-ext-install gd intl pdo_mysql soap zip xsl sockets bcmath 
RUN sed -ri -e 's/DocumentRoot\ \/var\/www\/html/DocumentRoot \/var\/www\/html\/magento\n<Directory\ \/var\/www\/html\/magento>\nOptions Indexes FollowSymLinks\nAllowOverride All\nRequire all granted\n<\/Directory>/g' /etc/apache2/sites-enabled/000-default.conf 
RUN sed -i 's/memory_limit\ =\ 128M/memory_limit = 512M/' /usr/local/etc/php/php.ini
RUN a2enmod rewrite
WORKDIR /var/www/html
