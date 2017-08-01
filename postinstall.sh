#!/usr/bin/php
<?php
include '/var/www/public/index.php';

// Install Language Support (superuser needed)
$users->setCurrentUser($users->get('robertweiss'));
$modules->refresh();
$modules->install('LanguageSupport');

// Install german language files (files were downloaded in install.sh)
$lang = $pages->get('name=default,template=language');
foreach ($files->find('/var/www/langPackDe') as $file) {
    $lang->language_files->add($file);
}
$lang->save();
$files->rmdir('/var/www/langPackDe', true);

// Install Pro Modules (can not be installed via Wireshell)
$modules->install('FieldtypeRepeater');
$modules->install('FieldtypeRepeaterMatrix');
$modules->install('FieldtypeFunctional');
$modules->install('ProcessProfilerPro');
$modules->install('ProcessWireAPI');
$modules->refresh();

// Module Settings
$modules->saveConfig('AdminThemeDefault', 'colors', 'warm');

$steroids = $modules->getConfig('AdminOnSteroids');
$steroids['PageListTweaks'] = str_replace('pListIDs', '', $steroids['PageListTweaks']);
$modules->saveConfig('AdminOnSteroids', $steroids);

?>
