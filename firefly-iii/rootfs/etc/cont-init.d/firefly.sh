#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Firefly III
# This file creates the file structure and configures the app key
# ==============================================================================

if ! bashio::fs.directory_exists "/data/firefly/upload"; then
    bashio::log "Creating upload directory"
    mkdir -p /data/firefly/upload
    chown www-data:www-data /data/firefly/upload
fi
if ! bashio::fs.directory_exists "/data/firefly/database"; then
    bashio::log "Creating database directory"
    mkdir -p /data/firefly/database
	touch /data/firefly/database/database.sqlite
    chown www-data:www-data /data/firefly/database
fi
rm -r /var/www/firefly/storage/upload
ln -s /data/firefly/upload /var/www/firefly/storage/upload
rm -r /var/www/firefly/storage/database
ln -s /data/firefly/database /var/www/firefly/storage/database

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
