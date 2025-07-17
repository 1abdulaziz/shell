#!/bin/bash

# WordPress Auto Installer Script (Full Setup + Safe)
# Author: Abdulaziz + ChatGPT ⚙️

#------------------ CHECK ROOT ------------------
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root (e.g. sudo ./wpinstaller.sh)"
  exit 1
fi

#------------------ INSTALL REQUIRED PACKAGES ------------------
echo "📦 Installing required packages..."
apt update -y
apt install apache2 mysql-server mysql-client php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-zip wget unzip -y

#------------------ ENABLE APACHE MODULES ------------------
a2enmod rewrite
systemctl enable apache2
systemctl start apache2

#------------------ START MYSQL SERVICE ------------------
systemctl enable mysql
systemctl start mysql

#------------------ GET DB DETAILS ------------------
read -p "Enter desired database name: " dbname
read -p "Enter new MySQL username: " dbuser
read -p "Enter password for user $dbuser: " userpass

#------------------ CREATE DATABASE ------------------
echo "🔐 Setting up MySQL..."
mysql -e "CREATE DATABASE IF NOT EXISTS $dbname DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -e "CREATE USER IF NOT EXISTS '$dbuser'@'localhost' IDENTIFIED BY '$userpass';"
mysql -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
echo "✅ MySQL setup complete."

#------------------ SETUP WORDPRESS ------------------
read -r -p "Enter your site folder name (e.g. example.com): " wpURL
site_path="/var/www/$wpURL"

# Check if directory exists
if [ -d "$site_path" ]; then
  echo "❌ Directory $site_path already exists. Aborting."
  exit 1
fi

echo "⬇️ Downloading WordPress..."
wget -q -O - "https://wordpress.org/latest.tar.gz" | tar -xzf - -C /var/www --transform s/wordpress/$wpURL/

cd "$site_path" || exit
cp wp-config-sample.php wp-config.php
chmod 640 wp-config.php
mkdir -p wp-content/uploads
chown -R www-data:www-data .

# Inject DB credentials
sed -i "s/database_name_here/$dbname/" wp-config.php
sed -i "s/username_here/$dbuser/" wp-config.php
sed -i "s/password_here/$userpass/" wp-config.php

#------------------ APACHE VHOST ------------------
echo "🛠 Creating Apache virtual host..."

cat > /etc/apache2/sites-available/$wpURL.conf <<EOF
<VirtualHost *:80>
    ServerName $wpURL
    ServerAlias www.$wpURL
    DocumentRoot /var/www/$wpURL
    <Directory /var/www/$wpURL>
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/$wpURL-error.log
    CustomLog \${APACHE_LOG_DIR}/$wpURL-access.log combined
</VirtualHost>
EOF

a2ensite $wpURL.conf
systemctl reload apache2

#------------------ DONE ------------------
WPVER=$(grep "wp_version = " wp-includes/version.php | awk -F\' '{print $2}')
echo -e "\n✅ WordPress version $WPVER installed!"
echo -e "➡️ Open http://$wpURL in your browser to complete the setup."
