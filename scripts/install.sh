#!/bin/bash

# Create common used aliases
ws='/home/vagrant/.config/composer/vendor/bin/wireshell'
configfile='/var/www/public/site/config.php'

# # Silent wireshell warnings
# sed -i "s|<?php|<?php error_reporting(E_ALL ^ E_WARNING)\;|g" /home/vagrant/.config/composer/vendor/wireshell/wireshell/app/wireshell.php

# Create public folder if not existing
mkdir /var/www/public
cd /var/www/public

# Create db
sudo mysqladmin -uroot -proot create $2

# Get newest dev branch of Processwire and install
username='robertweiss'
userpass='password'
useremail='post@robertweiss.de'
git clone -b dev https://github.com/processwire/processwire.git /var/www/temppw
$ws new /var/www/public/ --dbUser root --dbPass root --dbName $2 --timezone Europe/Berlin --httpHosts $3 --adminUrl pw --username $username --userpass $userpass --useremail $useremail --profile blank --src /var/www/temppw

# Switch on debugging
$ws debug --on

# Install common modules
$ws m:e AdminThemeUikit
$ws m:e MarkupSimpleNavigation
$ws m:e AdminOnSteroids
$ws m:e TextformatterHannaCode
$ws m:e TracyDebugger

# Create common fields and add them to the templates
$ws f:create body --label Body --type textarea
$ws f:create imgs --label Bilder --type image

$ws t:f home --fields body,imgs
$ws t:f basic-page --fields body,imgs

# Add settings to configfile
echo "\$config->prependTemplateFile = '_init.php';" >> $configfile
echo "\$config->urls->templates = \$config->urls->templates.'pages/';" >> $configfile
echo "\$config->paths->templates = \$config->paths->templates.'pages/';" >> $configfile
echo "\$config->sessionExpireSeconds = 86400;" >> $configfile
echo "\$config->pageNumUrlPrefix = 'seite';" >> $configfile
echo "setlocale(LC_ALL,'de_DE.UTF-8');" >> $configfile

#Get language pack
git clone -b dev --single-branch https://github.com/jmartsch/pw-lang-de /var/www/langPackDe
rm -rf /var/www/langPackDe/README.md /var/www/langPackDe/.gitignore /var/www/langPackDe/.git

# Get Assets folder
rm -rf /var/www/public/site/templates
git clone https://github.com/robertweiss/base-tpl.git /var/www/public/site/templates

# Clean up folders
rm -rf /var/www/temppw
rm /var/www/public/CONTRIBUTING.md /var/www/public/LICENSE.TXT /var/www/public/README.md
rm -rf /var/www/public/site/modules/Helloworld /var/www/public/site/modules/README.txt

# Change Homepage param in package.json and siteTitle in _init.php
sed -i "s/http:\/\/base.test\//http:\/\/$3\//g" /var/www/public/site/templates/package.json
sed -i "s/\$siteTitle = '';/\$siteTitle = '$1';/g" /var/www/public/site/templates/pages/_init.php
