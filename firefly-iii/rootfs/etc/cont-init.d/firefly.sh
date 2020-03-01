#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Firefly III
# This file creates the file structure and configures the app key
# ==============================================================================

declare host
declare key
declare password
declare port
declare username

if ! bashio::fs.directory_exists "/data/firefly/upload"; then
    bashio::log "Creating upload directory"
    mkdir -p /data/firefly/upload
    chown www-data:www-data /data/firefly/upload
fi

rm -r /var/www/firefly/storage/upload
ln -s /data/firefly/upload /var/www/firefly/storage/upload

#Create API key if needed
if ! bashio::fs.file_exists "/data/firefly/appkey.txt"; then
	#Command fails without appkey set, this won't be used again
	export APP_KEY=SomeRandomStringOf32CharsExactly
 	bashio::log.info "Generating app key"
 	key=$(php /var/www/firefly/artisan key:generate --show)
 	echo "${key}" > /data/firefly/appkey.txt
 	bashio::log.info "App Key generated: ${key}"
fi

if bashio::config.has_value 'remote_mysql_host'; then
  if ! bashio::config.has_value 'remote_mysql_database'; then
    bashio::exit.nok \
      "Remote database has been specified but no database is configured"
  fi

  if ! bashio::config.has_value 'remote_mysql_username'; then
    bashio::exit.nok \
      "Remote database has been specified but no username is configured"
  fi

  if ! bashio::config.has_value 'remote_mysql_password'; then
    bashio::log.fatal \
      "Remote database has been specified but no password is configured"
  fi

  if ! bashio::config.exists 'remote_mysql_port'; then
    bashio::exit.nok \
      "Remote database has been specified but no port is configured"
  fi
else
  if ! bashio::services.available 'mysql'; then
     bashio::log.fatal \
       "Local database access should be provided by the MariaDB addon"
     bashio::exit.nok \
       "Please ensure it is installed and started"
  fi

  host=$(bashio::services "mysql" "host")
  password=$(bashio::services "mysql" "password")
  port=$(bashio::services "mysql" "port")
  username=$(bashio::services "mysql" "username")

  bashio::log.warning "Firefly-iii is using the Maria DB addon"
  bashio::log.warning "Please ensure this is included in your backups"
  bashio::log.warning "Uninstalling the MariaDB addon will remove any data"

  bashio::log.info "Creating database for Firefly-iii if required"
  mysql \
    -u "${username}" -p"${password}" \
    -h "${host}" -P "${port}" \
    -e "CREATE DATABASE IF NOT EXISTS \`firefly\` ;"
fi
