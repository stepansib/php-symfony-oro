FROM php:5.6-fpm
MAINTAINER Stepan Yudin <stepan.sib@gmail.com>

ENV REFRESHED_AT 2017–09-04

# Install libs
RUN apt-get update && apt-get install -y \
  zlib1g-dev \
  libicu-dev g++ \
  libmcrypt-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpng12-dev \
  libldap2-dev \
  libxml2-dev \
  libcurl4-openssl-dev \
  libtidy-dev \
  zip \
  unzip \
  wget \
  xvfb \
  wkhtmltopdf \
  mysql-client \
  git

# Install fresh node & npm
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs \
  build-essential

# Configure PHP extensions
RUN docker-php-ext-configure intl
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/

# Install PHP extensions
RUN docker-php-ext-install \
  curl \
  intl \
  mcrypt \
  gd \
  ldap \
  opcache \
  pdo \
  pdo_mysql \
  soap \
  zip \
  tidy \
  bcmath

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configure PHP and FPM
COPY ./php.ini /usr/local/etc/php/
COPY php-fpm.conf /etc/php-fpm.conf
