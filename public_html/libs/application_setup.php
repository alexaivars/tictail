<?php

/**
 * Project: Weekday shop protoype
 * Author: Alexander Aivars <alex [AT] kramgo [DOT] com>
 * File: application_setup.php
 * Version: 1.0
 */

require(APPLICATION_DIR . 'libs/application.lib.php');
require(SMARTY_DIR . 'Smarty.class.php');

// smarty configuration
class Prototype_Smarty extends Smarty {
    function __construct() {
      parent::__construct();
      $this->setTemplateDir(APPLICATION_DIR . 'templates');
      $this->setCompileDir(APPLICATION_DIR . 'templates_c');
      $this->setConfigDir(APPLICATION_DIR . 'configs');
      $this->setCacheDir(APPLICATION_DIR . 'cache');
    }
}
   
?>
