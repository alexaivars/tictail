<?php

/**
 * Project: Tictail shop protoype
 * Author: Alexander Aivars <alex [AT] kramgo [DOT] com>
 * File: application_setup.php
 * Version: 1.0
 */

class Prototype {

  // smarty template object
  var $tpl = null;
  // error messages
  var $error = null;

  /**
  * class constructor
  */
  function __construct() {
    // instantiate the template object
    $this->tpl = new Prototype_Smarty;
  }
	
	/**
	* get a list of products
	*/
	private function getProducts() {
		$return = array();
		
		$url = "dummy-content/product-teaser/";
		$dir = opendir($url);
		if($dir) {
			while($file = readdir($dir)) {
				if( stripos($file,".jpg") > 0) {
					// new Product( $file , "null");
					$name = $file;
					$name = preg_replace('/\.jpg/i',"", $name);
					$name = preg_replace('/[_\-]/i'," ", $name);
					if( !stripos($file,"2x.jpg") ) { 
						array_push($return, new ProductItem($url.$file,$name));
					}	
				}
			}			
			closedir($dir);
		}
		usort( $return, 'itemSort' );
		return $return;
	}

	
	/**
  * display the webshop
  *
  * @param array $data the webshop data
  */
	function render($name = 'frontpage', $type = 'default') {
		$this->tpl->assign('page',$name);
		$this->tpl->assign('products',$this->getProducts());
		$this->tpl->display($name . '.tpl');
  }

}

class ProductItem {
	public $file;
	public $name;
	public $price;
	public $currency = 'Sek';
	public function __construct($file,$name) {
		$this->file = $file;
		$this->name = $name;
		$this->price = 15 * rand(2,100);

		$hires = $file;
		$hires = preg_replace('/\.jpg/i',"@2x.jpg", $hires);
		$hires = substr_replace($hires,"/large",strripos($hires,"/"),0);
		$this->hires = $hires; 

	}

	public function __toString() {
		return 'ListItem('.$this->file.','.$this->name.')';
	}
}


function itemSort( $a, $b ) {
    return $a->name == $b->name ? 0 : ( $a->name > $b->name ) ? 1 : -1;
}

?>
