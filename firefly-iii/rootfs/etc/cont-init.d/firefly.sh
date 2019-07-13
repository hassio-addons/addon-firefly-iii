#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Firefly III
# This file creates the file structure and configures the app key
# ==============================================================================

if ! bashio::fs.directory_exists "/data/firefly/upload"; then
    bashio::log "Creating upload directory"
    mkdir -p /data/firefly/upload
    chown nginx:nginx /data/firefly/upload
fi

rm -r /var/www/firefly/storage/upload
ln -s /data/firefly/upload /var/www/firefly/storage/upload

declare key
#Create API key if needed
if ! bashio::fs.file_exists "/data/firefly/appkey.txt"; then
	#Command fails without appkey set, this won't be used again
	export APP_KEY=SomeRandomStringOf32CharsExactly
 	bashio::log.info "Generating app key"
 	key=$(php /var/www/firefly/artisan key:generate --show)
 	echo "${key}" > /data/firefly/appkey.txt
 	bashio::log.info "App Key generated: ${key}"
fi
