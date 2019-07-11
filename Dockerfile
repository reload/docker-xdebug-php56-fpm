FROM php:7.3.7-fpm-alpine

RUN apk add --update \
    php5-fpm \
    php5-apcu \
    php5-curl \
    php5-gd \
    php5-iconv \
    php5-imagick \
    php5-json \
    php5-intl \
    php5-mcrypt \
    php5-mysql \
    php5-opcache \
    php5-openssl \
    php5-pdo \
    php5-pdo_mysql \
    php5-mysql \
    php5-xml \
    php5-zlib \
    # Adding gcc, g++ and make for autoconf
    gcc \
    g++ \
    make \
    # Adding autoconf for xdebug
    autoconf \
    # Adding libjpeg-turbo-dev and libpng-dev for gd
    libjpeg-turbo-dev \
    libpng-dev \
    freetype-dev

RUN rm -rf /var/cache/apk/* && rm -rf /tmp/*

# Adding gd for (atleast) CKFinder
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd mbstring pdo pdo_mysql pdo_pgsql

# Install xdebug and add some basic config (could be in a separate file)
RUN yes | pecl install xdebug \
  && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.max_nesting_level=256" >> /usr/local/etc/php/conf.d/xdebug.ini

ADD web.ini /usr/local/etc/php/php.ini

ADD web.pool.conf /etc/php5/fpm.d/

CMD ["php-fpm", "-F"]

EXPOSE 9000