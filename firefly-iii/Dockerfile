ARG BUILD_FROM=hassioaddons/base:4.0.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
# hadolint ignore=DL3003
RUN \
    apk add --no-cache \
        mariadb=10.3.16-r0 \
        mariadb-client=10.3.16-r0 \
        nginx=1.16.0-r2 \
        php7-bcmath=7.3.7-r0 \
        php7-curl=7.3.7-r0 \
        php7-fileinfo=7.3.7-r0 \
        php7-fpm=7.3.7-r0 \
        php7-gd=7.3.7-r0 \
        php7-intl=7.3.7-r0 \
        php7-json=7.3.7-r0 \
        php7-ldap=7.3.7-r0 \
        php7-mbstring=7.3.7-r0 \
        php7-mysqlnd=7.3.7-r0 \
        php7-pdo_mysql=7.3.7-r0 \
        php7-session=7.3.7-r0 \
        php7-simplexml=7.3.7-r0 \
        php7-tokenizer=7.3.7-r0 \
        php7-xml=7.3.7-r0 \
        php7-zip=7.3.7-r0 \
        php7=7.3.7-r0 \
    \
    && apk add --no-cache --virtual .build-dependencies \
        composer=1.8.6-r0 \
    \
    && FIREFLY_VERSION=4.7.17\
    \
    && curl -J -L -o /tmp/firefly.tar.gz \
        https://github.com/firefly-iii/firefly-iii/archive/${FIREFLY_VERSION}.tar.gz \
    &&  mkdir -p /var/www/firefly \
    && tar zxvf /tmp/firefly.tar.gz -C \
        /var/www/firefly --strip-components=1 \
    && cd /var/www/firefly \
    \
    && composer install --prefer-dist --no-dev --no-scripts --no-suggest \
    && apk del --purge .build-dependencies \
    \
    && find /var/www/firefly -type f -name "*.md" -depth -exec rm -f {} \; \
    && rm -f -r \
         /tmp/*

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Firefly III" \
    io.hass.description="A free and open source personal finance manager" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Paul Sinclair <hello@addons.community>" \
    org.label-schema.description="A free and open source personal finance manager" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Firefly III" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-firefly-iii/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-firefly-iii" \
    org.label-schema.vendor="Community Hass.io Addons"
