<!DOCTYPE html>
<!-- 

	 __  __ ______ _______ _______ _______ _______    _______ _______
	|  |/  |   __ \   _   |   |   |     __|       |  |     __|    ___|
	|     <|      <       |       |    |  |   -   |__|__     |    ___|
	|__|\__|___|__|___|___|__|_|__|_______|_______|__|_______|_______|
	@alexaivars

-->
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
	<head xmlns:og="http://opengraphprotocol.org/schema/"
		xmlns:fb="http://developers.facebook.com/schema/"
    profile="http://www.w3.org/1999/xhtml/vocab">
			<meta charset="utf-8">
			<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
			<title>{block name=title}Tictail{/block}</title>
			<meta name="description" content="">
			<meta name="author" content="Alex Aivars, Kramgo AB">
			<meta name="copyright" content="Kramgo AB">
			<meta name="generator" content="Vi IMproved 7.3">
			<meta name="no-email-collection" content="http://www.metatags.info/nospamharvesting">
			<!--<meta name="viewport" content="width=device-width" />-->
			<meta name="viewport" content="width=device-width, initial-scale=1">

			<meta property="og:type" content="protoype" />
			<meta property="og:title" content="Tictail theme prototype" />
			<meta property="og:image" content="img/logo.gif" />
			<meta property="og:url" content="http://krmg.se" />
			<meta property="og:description" content="This is a protype for a tictail custom Tictail shop theme." />

			<!-- Place favicon.ico and apple-touch-icon.png in the root directory -->
			<link href='http://fonts.googleapis.com/css?family=PT+Serif|Open+Sans:600,800' rel='stylesheet' type='text/css'>

			<link rel="stylesheet" href="css/main.css">
			<script src="js/vendor/modernizr-2.6.2.min.js"></script>
			{block name=head}{/block}
	</head>
	<body class="pagetypee-{$page}">
		{function menu level=0}          {* short-hand *}
			<ul class="level{$level}">
			{foreach $data as $entry}
				{if is_array($entry)}
					<li><a href="/?p=product">{$entry@key} ({random in=1 out=100})</a></li>
					{menu data=$entry level=$level+1}
				{else}
					<li><a href="/?p=product">{$entry}  ({random in=1 out=100})</a></li>
				{/if}
			{/foreach}
			</ul>
		{/function}
		{* create menu array *}
		{$categories = ['Show All', 'Accessoarer', 'Arbetsplats &amp; Pyssel', 'Badrum', 'Barn', 'Filtar &amp; Pl&auml;dar', 'Korgar &amp; S&auml;ckar', 'Kuddar', 'K&ouml;k', 'Mellandags-REA', 'Porslin &amp; Keramik', 'Posters &amp; Kort']}
		{$brands = ['Visa alla', 'Acne', 'A.P.C.', 'Badrum', 'Barn', 'Filtar &amp; Pl&auml;dar', 'Korgar &amp; S&auml;ckar', 'Kuddar', 'K&ouml;k', 'Mellandags-REA', 'Porslin &amp; Keramik', 'Posters &amp; Kort']}
		<!--[if lt IE 7]>
		<p class="chromeframe">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">activate Google Chrome Frame</a> to improve your experience.</p>
		<![endif]-->
		<div id="container"> 
			<aside id="nav">
				<nav class="main-navigation">
						<div id="search_container" class="search-wrapper">
					    <form id="tictail_search" class="tictail_form tictail_search">
      			  	<input id="tictail_search_box" name="q" autocomplete="off" type="text" class="placeholder search-input" placeholder="Search...">
					    	<div id="tictail_search_results" class="results_box results-box search-result" style="display: none; ">No products found</div>
							</form>
            </div>
					
					
					{block name=navigation}
					{* run the array through the function *}
					<h2>categorie</h2>
					{menu data=$categories}

					<h2>brand</h2>
					{menu data=$brands}
					<ul class="legal">
						<li><a href="/?p=article">About</a></li>
						<li><a href="/?p=article">Contact</a></li>
						<li><a href="/?p=article">FAQ</a></li>
					</ul>
					{/block}
				</nav>
			</aside>
			<div id="content">
				<div id="main-content">
					<nav class="content-menu nav-bar">
						<a href="#main-nav" data-action="menu-toggle"><img src="img/menu.gif" alt="Toggle menu"></a></li>
					</nav>
					<section class="content-body">
						{block name=body}{/block}
					<section>
				</div>
				<footer>
					{block name=footer}{/block}
				</footer>
			</div>
			</div>
			<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
			<script>window.jQuery || document.write('<script src="js/vendor/jquery-1.9.0.min.js"><\/script>')</script>
			<script src="js/vendor/jquery.hammer-1.0.4.min.js"></script>
			<!--
			<script src="js/vendor/swipe-2.0.0.min.js"></script>
			-->
			<script src="js/swipe.js"></script>
			<script src="js/main.js"></script>
	</body>
</html>
