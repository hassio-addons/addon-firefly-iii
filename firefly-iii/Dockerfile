ARG BUILD_FROM=hassioaddons/ubuntu-base:3.1.3
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
# hadolint ignore=DL3003
RUN \
    apt-get update \
    \
    && apt-get install -y --no-install-recommends \
        locales=2.27-3ubuntu1 \
        nginx=1.14.0-0ubuntu1.2 \
        php7.2-bcmath=7.2.19-0ubuntu0.18.04.1 \
        php7.2-curl=7.2.19-0ubuntu0.18.04.1 \
        php7.2-common=7.2.19-0ubuntu0.18.04.1 \
        php7.2-fpm=7.2.19-0ubuntu0.18.04.1 \
        php7.2-gd=7.2.19-0ubuntu0.18.04.1 \
        php7.2-intl=7.2.19-0ubuntu0.18.04.1 \
        php7.2-json=7.2.19-0ubuntu0.18.04.1 \
        php7.2-ldap=7.2.19-0ubuntu0.18.04.1 \
        php7.2-mbstring=7.2.19-0ubuntu0.18.04.1 \
        php7.2-mysql=7.2.19-0ubuntu0.18.04.1 \
        php7.2-opcache=7.2.19-0ubuntu0.18.04.1 \
        php7.2-sqlite3=7.2.19-0ubuntu0.18.04.1 \
        sqlite3=3.22.0-1ubuntu0.1 \
        php7.2-xml=7.2.19-0ubuntu0.18.04.1 \
        php7.2-zip=7.2.19-0ubuntu0.18.04.1 \
        php7.2=7.2.19-0ubuntu0.18.04.1 \
        composer=1.6.3-1 \
    \
    && FIREFLY_VERSION=4.7.17\
    \
    && curl -J -L -o /tmp/firefly.tar.gz \
        https://github.com/firefly-iii/firefly-iii/archive/${FIREFLY_VERSION}.tar.gz \
    &&  mkdir -p /var/www/firefly \
    && tar zxf /tmp/firefly.tar.gz -C \
        /var/www/firefly --strip-components=1 \
    && echo "de_DE.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\nes_ES.UTF-8 UTF-8\nfr_FR.UTF-8 UTF-8\nid_ID.UTF-8 UTF-8\nit_IT.UTF-8 UTF-8\nnl_NL.UTF-8 UTF-8\npl_PL.UTF-8 UTF-8\npt_BR.UTF-8 UTF-8\nru_RU.UTF-8 UTF-8\ntr_TR.UTF-8 UTF-8\nzh_TW.UTF-8 UTF-8\nzh_CN.UTF-8 UTF-8\n\n" > /etc/locale.gen \
    && locale-gen \
    && cd /var/www/firefly \
    && COMPOSER_ALLOW_SUPERUSER=1 \
    && composer install --prefer-dist --no-dev --no-scripts --no-suggest \
    && apt-get purge -y --auto-remove \
        composer \
    \
    && find /var/www/firefly -type f -name "*.md" -depth -exec rm -f {} \; \
    && rm -f -r \
        /tmp/* \
        /etc/nginx \
        /var/{cache,log}/* \
        /var/lib/apt/lists/* \
        /var/lib/mysql/*logfile* \
        \
    && mkdir -p /var/log/nginx \
    && touch /var/log/nginx/error.log

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
