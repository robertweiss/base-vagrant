<?php
include('/var/www/public/index.php');

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

# Change admin theme to UIKit
$admin = $users->get('robertweiss');
$admin->of(false);
$admin->admin_theme = 'AdminThemeUikit';
$admin->save();

// Install Pro Modules (can not be installed via Wireshell)
$modules->install('FieldtypeRepeater');
$modules->install('FieldtypeRepeaterMatrix');
$modules->install('FieldtypeFunctional');
$modules->install('ProcessProfilerPro');
$modules->install('ProcessWireAPI');
$modules->refresh();

// Module Settings
$adminUiKit = $modules->getConfig('AdminThemeUikit');
$adminUiKit['useAsLogin'] = 1;
$modules->saveConfig('AdminThemeUikit', $adminUiKit);

$steroids = $modules->getConfig('AdminOnSteroids');
$steroids['PageListTweaks'] = str_replace('pListIDs', '', $steroids['PageListTweaks']);
$steroids['Tooltips'] = '[]';
$modules->saveConfig('AdminOnSteroids', $steroids);

$tracy = $modules->getConfig('TracyDebugger');
$tracy['enabled'] = 1;
$tracy['superuserForceDevelopment'] = 1;
$tracy['maxDepth'] = 6;
$tracy['maxLength'] = 2000;
$tracy['editor'] = 'vscode-insiders://file/%file:%line';
$tracy['localRootPath'] = $argv[1]; // hostWebrootPath
$tracy['email'] = 'post@robertweiss.de';
$tracy['processwireInfoPanelSections'] = [
    "configData",
    "versionsList",
    "adminLinks",
    "documentationLinks",
    "gotoId",
    "processWireWebsiteSearch"
];
$tracy['customPWInfoPanelLinks'] = [
    "/processwire/setup/template/",
    "/processwire/setup/field/",
    "/processwire/setup/",
    "/processwire/module/",
    "/processwire/access/users/"
];
$tracy['pWInfoPanelLinksNewTab'] = 1;
$tracy['dumpPanelTabs'] = [
    "debugInfo",
    "fullObject",
    "iterator"
];
$tracy['styleAdminType'] = [
    "default",
    "favicon"
];
$modules->saveConfig('TracyDebugger', $tracy);

$pagename = $modules->getConfig('InputfieldPageName');
$pagename['replacements']['ä'] = 'ae';
$pagename['replacements']['ö'] = 'oe';
$pagename['replacements']['ü'] = 'ue';
$modules->saveConfig('InputfieldPageName', $pagename);

// Complete imgs field config
$imgs = $fields->get('imgs');
$imgs->fileSchema = 2;
$imgs->extensions = "gif jpg jpeg png";
$imgs->maxFiles = 0;
$imgs->outputFormat = 0;
$imgs->defaultValuePage = 0;
$imgs->useTags = 0;
$imgs->inputfieldClass = "InputfieldImage";
$imgs->collapsed = 0;
$imgs->descriptionRows = 1;
$imgs->gridMode = "grid";
$imgs->resizeServer = 0;
$imgs->clientQuality = 90;
$imgs->noLang = 1;
$imgs->maxWidth = 4000;
$imgs->maxHeight = 4000;
$imgs->save();

?>
