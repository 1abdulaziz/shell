#!/bin/bash

# Lando + WordPress setup script
# Author: Abdulaziz + ChatGPT ⚙️

#------------------ CHECK ------------------
if ! command -v lando &> /dev/null; then
  echo "❌ Lando is not installed. Please install Lando first."
  exit 1
fi

read -p "Enter project folder name (e.g. wp-lando): " folder
mkdir "$folder" && cd "$folder" || exit

#------------------ CREATE lando.yml ------------------
cat > lando.yml <<EOF
name: $folder
recipe: wordpress
config:
  webroot: .
  database: mariadb
  xdebug: true
services:
  appserver:
    type: php:8.1
tooling:
  wp:
    service: appserver
EOF

#------------------ START LANDO ------------------
echo "🚀 Starting Lando..."
lando start

#------------------ DOWNLOAD WORDPRESS ------------------
lando wp core download

#------------------ SETUP CONFIG ------------------
lando wp config create --dbname=wordpress --dbuser=wordpress --dbpass=wordpress --dbhost=database

#------------------ INSTALL WORDPRESS ------------------
lando wp core install \
  --url="http://$folder.lndo.site" \
  --title="$folder Site" \
  --admin_user=admin \
  --admin_password=admin \
  --admin_email=admin@example.com

#------------------ ACTIVATE PLUGINS & THEME ------------------
lando wp plugin install classic-editor --activate
lando wp theme install astra --activate

#------------------ DONE ------------------
echo -e "\n✅ WordPress with Lando is ready!"
echo -e "🔗 Open: http://$folder.lndo.site"
echo -e "👤 Username: admin | 🔐 Password: admin"
