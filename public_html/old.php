<?php

/**
 * Project: Weekday shop protoype
 * Author: Alexander Aivars <alex [AT] kramgo [DOT] com>
 * File: index.php
 * Version: 1.0
 */

// define our application directory
define('APPLICATION_DIR', './');
// define smarty lib directory
define('SMARTY_DIR', './libs/smarty/');

// include the setup script
include(APPLICATION_DIR . '/libs/application_setup.php');

$shop = new Prototype;

// set the current action
$_page = isset($_REQUEST['p']) ? $_REQUEST['p'] : 'frontpage';
$_type = isset($_REQUEST['t']) ? $_REQUEST['t'] : 'default';
?>

<?php 
try { 
  $shop->render($_page,$_type); 
} catch(SmartyException $e) { 
  print $e->getMessage(); 
  exit; 
}



?>
