#!/bin/sh
username=$(id -u -n 1000)
sudo apt update && sudo apt upgrade
echo "DRUPAL_HOME=/var/www/html" | tee -a "$HOME"/.bashrc > /dev/null
export DRUPAL_HOME=/var/www/html
sudo apt install apache2
cd /etc/apache2/mods-enabled || exit
sudo ln -s ../mods-available/rewrite.load
sudo gedit /etc/apache2/sites-available/000-default.conf
<Directory /var/www/html>
   Options Indexes FollowSymLinks MultiViews
   AllowOverride All
   Order allow,deny
   allow from all
</Directory>
sudo service apache2 restart
sudo apt install php php-dev php-cli libapache2-mod-php php8.2-mbstring
sudo apt install php-pgsql php-gd php-xml
sudo sed -i "/memory_limit/ c\memory_limit = 2048M" /etc/php/8.2/apache2/php.ini
sudo service apache2 restart
sudo apt install postgresql
sudo apt install phppgadmin
sudo apt install composer
cd $DRUPAL_HOME
composer require drush/drush
composer require drupal/core
drush init
sudo su - postgres
createuser -P drupal
createdb drupal -O drupal
exit
sudo chown -R $username $DRUPAL_HOME
wget https://www.drupal.org/download-latest/tar.gz -O drupal-latest.tar.gz
tar -zxvf drupal-latest.tar.gz
mv drupal-*/* ./
mv drupal-*/.htaccess ./
mv index.html index.html.orig
cd $DRUPAL_HOME/sites/default/
cp default.settings.php settings.php
sudo chown www-data:www-data $DRUPAL_HOME/sites/default/settings.php
$databases['default']['default'] = array(
  'driver' => 'pgsql',
  'database' => 'drupal',
  'username' => 'drupal',
  'password' => '********',
  'host' => 'localhost',
  'prefix' => '',
);
# sudo chown www-data:www-data $DRUPAL_HOME/sites/default/ # maybe not required?
psql -U drupal -d drupal -h localhost
CREATE EXTENSION pg_trgm;
exit
mkdir -p $DRUPAL_HOME/sites/default/files
sudo chgrp www-data $DRUPAL_HOME/sites/default/files
sudo chmod g+rw $DRUPAL_HOME/sites/default/files
http://localhost/install.php
composer require drupal/entity
composer require drupal/tripal
drush en entity
drush en tripal
drush en tripal_chado

