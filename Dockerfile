FROM php:8.0.2-fpm

WORKDIR /var/www/html
RUN ls -al
# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
	$PHPIZE_DEPS \
    default-mysql-client \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libxml2-dev \
    libicu-dev \
    curl \
    nano \
    libcurl4-openssl-dev \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    bzip2 \
    libbz2-dev \
    openssh-client

#Update Node
RUN curl -L https://deb.nodesource.com/setup_14.x | bash
RUN apt install -y nodejs

#Update NPM
RUN npm i npm@latest -g
RUN npm install -g yarn

#Install extensions
RUN docker-php-ext-install pdo_mysql zip exif pcntl xmlrpc intl bz2 bcmath
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

RUN pecl install -o -f redis xmlrpc\
  &&  rm -rf /tmp/pear \
  && docker-php-ext-enable redis \
  && docker-php-ext-enable xmlrpc

#Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer