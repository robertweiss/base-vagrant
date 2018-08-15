#!/bin/bash

# Change Homepage param in package.json and siteTitle in _init.php
sed -i "s/http:\/\/base.test\//http:\/\/$3\//g" public/site/templates/package.json
sed -i "s/\$siteTitle = '';/\$siteTitle = '$1';/g" public/site/templates/_init.php

# Open Admin in Chrome
open http://$3/pw/access/users/edit/?id=41
