#!/bin/bash

# Variables
sed -i '$a\DRUPAL_HOME=/var/www/html' ~/.bashrc && DRUPAL_HOME=/var/www/html

# Take user choice before continuing
function continueORNot {
   read -r -p "Continue? (yes/no): " choice
   case "$choice" in 
     "yes" ) echo "Moving on to next step..";sleep 2;;
     "no" ) echo "Exiting.."; exit 1;;
     * ) echo "Invalid Choice! Keep in mind this is case-sensitive."; continueORNot;;
   esac
}

# Display task name
echo -e '\n+-------------------------+'
echo '|   Drupal Installation   |'
echo '+-------------------------+'

# Get user input
if [[ -z ${drupalsitedir} ]]; then
	read -r -p "Enter the name of the directory in which drupal website was installed: " drupalsitedir
fi

# Installation
sudo chown -R "$USER" "$DRUPAL_HOME"
cd "$DRUPAL_HOME" || exit
mv index.html index.html.orig
wget http://ftp.drupal.org/files/projects/drupal-7.98.tar.gz
tar -zxvf drupal-7.98.tar.gz
rm drupal-7.98.tar.gz
mv drupal-7.98/ "$drupalsitedir"/
cp "$drupalsitedir"/sites/default/default.settings.php "$drupalsitedir"/sites/default/settings.php
mkdir "$drupalsitedir"/sites/default/files/
sudo chgrp -R www-data "$drupalsitedir"/sites/default/files/
sudo chmod 777 "$drupalsitedir"/sites/default/settings.php
sudo chmod g+rw "$drupalsitedir"/sites/default/files/
echo -e '\n+----------------+'
echo '|   Site Setup   |'
echo '+----------------+'
echo "1. Go to http://localhost/""$drupalsitedir""/install.php and complete initial setup of website by providing newly created database details, new site maintenance account details, etc"
echo "- IMP NOTE: Make sure to note down site maintenance account username."
echo "2. After completing initial setup, come back and type 'yes' to continue."
continueORNot
sudo chmod 755 "$drupalsitedir"/sites/default/settings.php