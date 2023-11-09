FROM php:8.0-apache

## MAINTAINER Victor Queiroga (victorqueiroga.com)

ENV VERSION="1.4.3"
ENV BASE_URL="http://localhost"
ENV LANGUAGE="english"
ENV DEBUG_MODE="FALSE"
ENV DB_HOST="db"
ENV DB_NAME="easyappointments"
ENV DB_USERNAME=""
ENV DB_PASSWORD=""
ENV GOOGLE_SYNC_FEATURE=FALSE
ENV GOOGLE_PRODUCT_NAME=""
ENV GOOGLE_CLIENT_ID=""
ENV GOOGLE_CLIENT_SECRET=""
ENV GOOGLE_API_KEY=""
ENV EMAIL_ENABLED="FALSE"
ENV EMAIL_AUTH=""
ENV EMAIL_HOST=""
ENV EMAIL_USER=""
ENV EMAIL_PASS=""
ENV EMAIL_CRYPTO=""
ENV EMAIL_PORT=""


EXPOSE 80

RUN mkdir /tmp/app && mkdir -p /tmp/dependencies/assets

WORKDIR /tmp/app

COPY ./docker/99-overrides.ini /usr/local/etc/php/conf.d
COPY ./docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN apt-get update \
    && apt-get install -y nfs-common \
    && apt-get install -y libfreetype-dev libjpeg62-turbo-dev libpng-dev unzip wget nano \
	&& curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s curl gd mbstring mysqli xdebug gettext \
    && docker-php-ext-enable xdebug 

COPY ./utils/integrity_test.php /tmp/dependencies
COPY ./assets /tmp/dependencies/assets

RUN wget https://github.com/alextselegidis/easyappointments/releases/download/${VERSION}/easyappointments-${VERSION}.zip \
    && unzip easyappointments-${VERSION}.zip \
    && rm easyappointments-${VERSION}.zip \
    && echo "alias ll=\"ls -al\"" >> /root/.bashrc 

RUN apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/tmp/* \
    && chown -R www-data:www-data .


ENTRYPOINT ["docker-entrypoint.sh"]

