# The images with `apt-get` are requried.
# https://hub.docker.com/_/php/
ARG PHP_VERSION

FROM php:${PHP_VERSION}

ARG DOCKER_IMAGE_SOURCE="https://github.com/slavcodev/docker-php"
ARG DOCKER_IMAGE_MAINTAINER="Veaceslav Medvedev <slavcopost@gmail.com>"
ARG DOCKER_IMAGE_LICENSE="MIT"
ARG DOCKER_IMAGE_VENDOR="slavcodev"

MAINTAINER "${DOCKER_IMAGE_MAINTAINER}"

LABEL maintainer="${DOCKER_IMAGE_MAINTAINER}" \
    org.opencontainers.image.source="${DOCKER_IMAGE_SOURCE}" \
    org.label-schema.license="${DOCKER_IMAGE_LICENSE}" \
    org.label-schema.license="${DOCKER_IMAGE_LICENSE}" \
    org.label-schema.vendor="${DOCKER_IMAGE_VENDOR}" \
    org.label-schema.name="php" \
    org.label-schema.description="While designed for web development, the PHP scripting language also provides general-purpose use." \
    org.label-schema.version="${MAILCATCHER_VERSION}"

HEALTHCHECK NONE

ARG WORKING_DIR=/var/www/html

ENV HOME=/home
ENV WORKING_DIR=${WORKING_DIR}

ARG RUNTIME_DEPS="\
    git \
    curl \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libpq-dev \
    zip \
    unzip \
    "

ARG PHP_EXT_INSTALL="\
    bcmath \
    calendar \
    exif \
    mbstring \
    pdo_mysql \
    pdo_pgsql \
    intl \
    pcntl \
    gettext \
    gd \
    zip \
    sockets \
    soap \
    "

ARG PHP_EXT_ENABLE=""

# TODO: Add xdebug default config.
# Example: memcached
ARG PECL_EXT_INSTALL="\
    xdebug \
    "

ARG PECL_EXT_ENABLE=""

# Workaround to build ext-socket
# https://github.com/docker-library/php/issues/1245#issuecomment-1019957169
ENV CFLAGS="$CFLAGS -D_GNU_SOURCE"

# If you are having difficulty figuring out which Debian or Alpine packages need to be installed before `docker-php-ext-install`,
# then have a look at the [install-php-extensions project](https://github.com/mlocati/docker-php-extension-installer).
RUN apt-get update && \
    apt-get install -y ${RUNTIME_DEPS} && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Configure core extensions
# RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Install core extensions
RUN if [ -n "${PHP_EXT_INSTALL}" ]; then docker-php-ext-install -j "$(nproc)" ${PHP_EXT_INSTALL}; fi
RUN if [ -n "${PHP_EXT_ENABLE}" ]; then docker-php-ext-enable ${PHP_EXT_ENABLE}; fi

# Install PECL extensions.
# If PECL extensions required compiling options, should be set using argument `PHP_EXTRA_CONFIGURE_ARGS`.
RUN if [ -n "${PECL_EXT_INSTALL}" ]; then pecl install ${PECL_EXT_INSTALL}; fi
RUN if [ -n "${PECL_EXT_ENABLE}" ]; then docker-php-ext-enable ${PECL_EXT_ENABLE}; fi

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN mkdir -p ${HOME}/.composer/cache

RUN echo "PS1='\w\$ '" >> ~/.bashrc  && \
    echo "HISTCONTROL=ignoredups" >> ~/.bashrc  && \
    sed -i 's/\\h\:\\w\\\$/\\w\\$/' /etc/profile
