ARG BUILD_FROM=hassioaddons/debian-base:3.2.3
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
        git=1:2.20.1-2+deb10u3 \
        locales=2.28-10 \
        mariadb-client=1:10.3.23-0+deb10u1 \
        nginx=1.14.2-2+deb10u3 \
        software-properties-common=0.96.20.2-2 \
        unzip=6.0-23+deb10u1 \
    #Requires PHP 7.4
    && curl -J -L -o /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/php.list \
    && apt-get update \
    && apt-get install  -y --no-install-recommends \
        composer=1.8.4-1 \
        php7.4-bcmath=7.4.11-6+0~20201018.31+debian10~1.gbpdc1a93 \
        php7.4-curl=7.4.11-6+0~20201018.31+debian10~1.gbpdc1a93 \
        php7.4-cli=7.4.11-6+0~20201018.31+debian10~1.gbpdc1a93 \
        php7.4-common=7.4.11-6+0~20201018.31+debian10~1.gbpdc1a93 \
        php7.4-fpm=7.4.11-6+0~20201018.31+debian10~1.gbpdc1a93 \
        php7.4-gd=7.4.11-6+0~20201018.31+debian10~1.gbpdc1a93 \
        php7.4-intl=7.4.11-6+0~20201018.31+debian10~1.gbpdc1a93 \
        php7.4-ldap=7.4.11-6+0~20201018.31+debian10~1.gbpdc1a93 \
        php7.4-mbstring=7.4.11-6+0~20201018.31+debian10~1.gbpdc1a93 \
        php7.4-mysql=7.4.11-6+0~20201018.31+debian10~1.gbpdc1a93 \
        php7.4-opcache=7.4.11-6+0~20201018.31+debian10~1.gbpdc1a93 \
        php7.4-readline=7.4.11-6+0~20201018.31+debian10~1.gbpdc1a93 \
        php7.4-sqlite3=7.4.11-6+0~20201018.31+debian10~1.gbpdc1a93 \
        php7.4-xml=7.4.11-6+0~20201018.31+debian10~1.gbpdc1a93 \
        php7.4-zip=7.4.11-6+0~20201018.31+debian10~1.gbpdc1a93 \
        php7.4=7.4.11-6+0~20201018.31+debian10~1.gbpdc1a93 \
    \
    && FIREFLY_VERSION=5.4.5 \
    \
    && curl -J -L -o /tmp/firefly.tar.gz \
        https://github.com/firefly-iii/firefly-iii/archive/${FIREFLY_VERSION}.tar.gz \
    &&  mkdir -p /var/www/firefly \
    && tar zxf /tmp/firefly.tar.gz -C \
        /var/www/firefly --strip-components=1 \
    && printf "vi_VN.UTF-8 UTF-8\nfi_FI.UTF-8 UTF-8\nsv_SE.UTF-8 UTF-8\nel_GR.UTF-8 UTF-8\nhu_HU.UTF-8 UTF-8\nro_RO.UTF-8 UTF-8\nnb_NO.UTF-8 UTF-8\nde_DE.UTF-8 UTF-8\ncs_CZ.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\nes_ES.UTF-8 UTF-8\nfr_FR.UTF-8 UTF-8\nid_ID.UTF-8 UTF-8\nit_IT.UTF-8 UTF-8\nnl_NL.UTF-8 UTF-8\npl_PL.UTF-8 UTF-8\npt_BR.UTF-8 UTF-8\nru_RU.UTF-8 UTF-8\ntr_TR.UTF-8 UTF-8\nzh_TW.UTF-8 UTF-8\nzh_CN.UTF-8 UTF-8\n\n" > /etc/locale.gen \
    && locale-gen \
    && cd /var/www/firefly \
    && composer install --prefer-dist --no-dev --no-scripts --no-suggest \
    && apt-get purge -y --auto-remove \
        composer \
        git \
        software-properties-common \
        unzip \
    \
    && apt-get clean \
    && find /var/www/firefly -type f -name "*.md" -depth -exec rm -f {} \; \
    && rm -f -r \
        /tmp/* \
        /etc/nginx \
        /var/{cache,log}/* \
        /var/lib/apt/lists/* \
        /var/www/firefly/Docker* \
        /var/www/firefly/docker* \
        /var/www/firefly/phpunit* \
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
    org.opencontainers.image.title="Firefly III" \
    org.opencontainers.image.description="A free and open source personal finance manager" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Paul Sinclair <hello@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/hassio-addons/addon-firefly-iii" \
    org.opencontainers.image.documentation="https://github.com/hassio-addons/addon-firefly-iii/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
