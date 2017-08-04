#!/bin/bash

# Clone Sublime Text Config, change name
git clone git@gist.github.com:fc2929477281ee6fc90b2fd8c265237e.git temp
mv temp/Base.sublime-project ./
rm -rf temp
sed -i "s/Base/$1/g" Base.sublime-project
mv Base.sublime-project "$2.sublime-project"

# Change Homepage param in package.json and siteTitle in _init.php
sed -i "s/http:\/\/base.dev\//http:\/\/$3\//g" public/site/templates/package.json

sed -i "s/\$siteTitle = '';/\$siteTitle = '$1';/g" public/site/templates/_init.php

# Open Sublime Text and Chrome
subl "$2.sublime-project"
open http://$3/pw/access/users/edit/?id=41
