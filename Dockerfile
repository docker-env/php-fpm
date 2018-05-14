FROM php:7.1-fpm

RUN apt-get update && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libmcrypt-dev \
		libpng-dev \
	&& docker-php-ext-install -j$(nproc) iconv mcrypt \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd \
   	&& docker-php-ext-install pdo_mysql \
   	&& docker-php-ext-install zip
	
RUN pecl install redis-4.0.1 \
	&& docker-php-ext-enable redis

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    	&& composer config -g repo.packagist composer https://packagist.phpcomposer.com
 
COPY cacert.pem /usr/local/etc/php/

COPY php.ini /usr/local/etc/php/

COPY www.conf /usr/local/etc/php-fpm.d/

RUN mkdir -p /var/www/html/ \
	&& chown -R www-data:www-data /var/www/html/
