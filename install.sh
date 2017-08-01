#!/bin/bash

# Create common used aliases
ws='/home/vagrant/.config/composer/vendor/bin/wireshell'
configfile='/var/www/public/site/config.php'

# Create public folder if not existing
mkdir /var/www/public
cd /var/www/public
echo "cd /var/www/public" >> /home/vagrant/.bashrc

# Get newest dev branch of Processwire and install
username='robertweiss'
userpass='password'
useremail='post@robertweiss.de'
git clone -b dev https://github.com/processwire/processwire.git /var/www/temppw
$ws new /var/www/public/ --dbUser root --dbPass root --dbName pw --timezone Europe/Berlin --httpHosts $2 --adminUrl pw --username $username --userpass $userpass --useremail $useremail --profile blank --src /var/www/temppw

# Switch on debugging
$ws debug --on

# Install common modules
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

# Install german locale and add to config (will be installed in postinstall.sh)
sudo locale-gen de_DE.UTF-8
sudo update-locale
echo "setlocale(LC_ALL,'de_DE.UTF-8');" >> $configfile

#Get language pack
git clone https://github.com/yellowled/pw-lang-de.git /var/www/langPackDe
rm -rf /var/www/langPackDe/README.md /var/www/langPackDe/.gitignore /var/www/langPackDe/.git

# Get Assets folder
rm -rf /var/www/public/site/templates/*
git clone https://github.com/robertweiss/base-tpl.git /var/www/public/site/templates
# cd /var/www/public/site/templates/
# npm install

# Clean up folders
rm -rf /var/www/temppw
rm /var/www/public/CONTRIBUTING.md /var/www/public/LICENSE.TXT /var/www/public/README.md
rm -rf /var/www/public/site/modules/Helloworld /var/www/public/site/modules/README.txt
