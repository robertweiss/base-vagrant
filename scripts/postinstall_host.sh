#!/bin/bash

# Change Homepage param in package.json and siteTitle in _init.php
sed -i "s/https:\/\/base.test\//https:\/\/$3\//g" public/site/templates/package.json
sed -i "s/\$siteTitle = '';/\$siteTitle = '$1';/g" public/site/templates/_init.php

# Open Admin in Chrome
open https://$3/pw/access/users/edit/?id=41
