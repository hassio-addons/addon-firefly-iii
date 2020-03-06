ARG BUILD_FROM=hassioaddons/debian-base:3.0.1
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
        composer=1.8.4-1 \
        locales=2.28-10 \
        mariadb-client=1:10.3.22-0+deb10u1 \
        nginx=1.14.2-2+deb10u1 \
        php7.3-bcmath=7.3.11-1~deb10u1 \
        php7.3-curl=7.3.11-1~deb10u1 \
        php7.3-cli=7.3.11-1~deb10u1 \
        php7.3-common=7.3.11-1~deb10u1 \
        php7.3-fpm=7.3.11-1~deb10u1 \
        php7.3-gd=7.3.11-1~deb10u1 \
        php7.3-intl=7.3.11-1~deb10u1 \
        php7.3-json=7.3.11-1~deb10u1 \
        php7.3-ldap=7.3.11-1~deb10u1 \
        php7.3-mbstring=7.3.11-1~deb10u1 \
        php7.3-mysql=7.3.11-1~deb10u1 \
        php7.3-opcache=7.3.11-1~deb10u1 \
        php7.3-readline=7.3.11-1~deb10u1 \
        php7.3-sqlite3=7.3.11-1~deb10u1 \
        php7.3-xml=7.3.11-1~deb10u1 \
        php7.3-zip=7.3.11-1~deb10u1 \
        php7.3=7.3.11-1~deb10u1 \
        software-properties-common=0.96.20.2-2 \
    \
    && FIREFLY_VERSION=5.1.0 \
    \
    && curl -J -L -o /tmp/firefly.tar.gz \
        https://github.com/firefly-iii/firefly-iii/archive/${FIREFLY_VERSION}.tar.gz \
    &&  mkdir -p /var/www/firefly \
    && tar zxf /tmp/firefly.tar.gz -C \
        /var/www/firefly --strip-components=1 \
    && printf "sv_SE.UTF-8 UTF-8\nfi_FI.UTF-8 UTF-8\nel_GR.UTF-8 UTF-8\nhu_HU.UTF-8 UTF-8\nro_RO.UTF-8 UTF-8\nnb_NO.UTF-8 UTF-8\nde_DE.UTF-8 UTF-8\ncs_CZ.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\nes_ES.UTF-8 UTF-8\nfr_FR.UTF-8 UTF-8\nid_ID.UTF-8 UTF-8\nit_IT.UTF-8 UTF-8\nnl_NL.UTF-8 UTF-8\npl_PL.UTF-8 UTF-8\npt_BR.UTF-8 UTF-8\nru_RU.UTF-8 UTF-8\ntr_TR.UTF-8 UTF-8\nzh_TW.UTF-8 UTF-8\nzh_CN.UTF-8 UTF-8\n\n" > /etc/locale.gen \
    && locale-gen \
    && cd /var/www/firefly \
    && composer install --prefer-dist --no-dev --no-scripts --no-suggest \
    && apt-get purge -y --auto-remove \
        composer \
        software-properties-common \
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
    org.label-schema.description="A free and open source personal finance manager" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Firefly III" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-firefly-iii/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-firefly-iii" \
    org.label-schema.vendor="Community Home Assistant Addons"
