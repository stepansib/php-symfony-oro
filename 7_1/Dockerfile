FROM php:7.1-fpm
MAINTAINER Stepan Yudin <stepan.sib@gmail.com>

ENV REFRESHED_AT 2018–08-09

# Install libs
RUN apt-get update && apt-get install -y \
  libc-client-dev \
  libkrb5-dev \
  zlib1g-dev \
  libicu-dev g++ \
  libmcrypt-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpng-dev \
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
  git \
  mc \
  ruby-full \
  gnupg \
  iputils-ping \
  faketime \
  cron \
  mc \
  sudo \
  iputils-ping

# Install node & npm
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs \
  build-essential

# Configure PHP extensions
RUN docker-php-ext-configure imap --with-imap --with-imap-ssl --with-kerberos
RUN docker-php-ext-install imap
RUN docker-php-ext-configure intl
RUN docker-php-ext-configure pcntl
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/

# Install PHP extensions
RUN docker-php-ext-install \
  curl \
  intl \
  pcntl \
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

#Install freetds & MSSQL driver
RUN apt-get -y --force-yes --no-install-recommends install freetds-dev
RUN docker-php-ext-configure pdo_dblib --with-libdir=/lib/x86_64-linux-gnu/
RUN docker-php-ext-install -j$(nproc) pdo_dblib

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Symfony installer
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod a+x /usr/local/bin/symfony

# Install PHPUnit
RUN wget https://phar.phpunit.de/phpunit.phar
RUN chmod +x phpunit.phar
RUN mv phpunit.phar /usr/local/bin/phpunit

# Install Codeception
RUN curl -LsS http://codeception.com/php5/codecept.phar -o /usr/local/bin/codecept
RUN chmod a+x /usr/local/bin/codecept

# Install PHPStan
RUN composer global require phpstan/phpstan ^0.9 --prefer-dist

# Install PHP Code Sniffer
RUN composer global require squizlabs/php_codesniffer --prefer-dist

# Install PHP Mess Detector
RUN composer global require phpmd/phpmd --prefer-dist

# Configure PHP and FPM
COPY ./php.ini /usr/local/etc/php/
COPY php-fpm.conf /etc/php-fpm.conf
RUN sed -i 's/listen = 127.0.0.1:9000/listen = 9000/' /usr/local/etc/php-fpm.d/www.conf

# Create www-data sudoer user
RUN adduser www-data sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install Supercronic
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.6/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=c3b78d342e5413ad39092fd3cfc083a85f5e2b75

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic