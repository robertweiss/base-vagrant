#!/bin/bash

# Change Homepage param in package.json and siteTitle in _init.php
sed -i "s/http:\/\/base.test\//http:\/\/$3\//g" public/site/templates/package.json
sed -i "s/\$siteTitle = '';/\$siteTitle = '$1';/g" public/site/templates/_init.php

# Open VS Code and Chrome
/usr/local/bin/code-insiders ./public/site/templates
open http://$3/pw/access/users/edit/?id=41
