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
        <meta name="author" content="Alex Aivars, Kramgo AB">
        <meta name="generator" content="Vi IMproved 7.3">
        <meta name="no-email-collection" content="http://www.metatags.info/nospamharvesting">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="{{meta_description}}">
        {{#product_page}}
        <meta property="og:type" content="product" />
        {{#product}}
        <meta property="og:title" content="{{title}}" />
        <meta property="og:description" content="{{meta_og_description}}" />
        {{/product}}
        {{/product_page}}
        {{^product_page}}
        <meta property="og:type" content="{{meta_og_type}}" />
        <meta property="og:title" content="{{title}}" />
        <meta property="og:description" content="{{meta_og_description}}" />
        {{/product_page}}
        <meta property="og:site_name" content="{{meta_og_site_name}}" />
        <meta property="og:url" content="{{meta_og_url}}" />
        
        {{#meta_og_images}}
        <meta property="og:image" content="{{url}}" />
        {{/meta_og_images}}
        
        <title>
            {{store_name}}
            {{! Add the label of the current navigation item on list pages }}
            {{#list_page}}{{#navigation}}{{#is_current}}- {{label}}{{/is_current}}{{/navigation}}{{/list_page}}
            {{! Add the product title on product pages }}
            {{#product_page}}{{#product}}- {{title}}{{/product}}{{/product_page}}
            {{! Add "About" on the about page }}
            {{#about_page}}- About{{/about_page}}
        </title>
        
    	<script type="text/javascript">
			WebFontConfig = {
				google: { families: [ 'PT+Serif::latin', 'Open+Sans:400,700,800:latin' ] }
			};
			(function() {
				var wf = document.createElement('script');
					wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
						'://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
					wf.type = 'text/javascript';
					wf.async = 'true';
					var s = document.getElementsByTagName('script')[0];
					s.parentNode.insertBefore(wf, s);
			})();
    	</script>            
        <link rel="stylesheet" href="http://tictail.krmg.se/css/main.css">
        <script src="http://tictail.krmg.se/js/vendor/modernizr-2.6.2.min.js"></script>
    </head>
    <body>
    <div class="page">
        <div class="page_body">
            <div id="navigation" class="page_navigation">
                <div id="menu_blocker"></div>
                <div class="navigation_toggle"></div>
                <nav>
            		<ul>
                        <li><div class="search_container">{{search}}</div></li>
                    </ul>
                    <ul>
                        <li>
                            <a href="/" {{#is_current}}class="selected"{{/is_current}}>All Products</a>
                        </li>
            		    {{#navigation}}
                        <li>
                            <a href="{{url}}" {{#is_current}}class="selected"{{/is_current}}>{{label}}</a>
                            {{! #is_current }}
                            {{! Render the submenu if it has any navigation items }}
                            {{#children?}}
                            <ul>
                                {{#children}}<li><a href="{{url}}" {{#is_current}}class="selected"{{/is_current}}>{{label}}</a></li>{{/children}}
                            </ul>
                            {{/children?}}
                            {{! /is_current}}
                        </li>
            			{{/navigation}}
                    </ul>
                    <ul>
                        {{#store_blog_url}}
            			<li>
            			    <a href="{{store_blog_url}}" target="_blank">Blog</a>
                        </li>
                        {{/store_blog_url}}
                        <li class="{{#about_page}}selected{{/about_page}}">
                            <a href="/page/about">About</a>
                        </li>						
            		</ul>
                </nav>
            </div>
            <div id="page" class="page_content">

				
				    <h1 class="page_header">
                    <a href="{{store_url}}">
                    {{#logotype}}<img src="{{url-300}}" alt="{{store_name}}"/>{{/logotype}}
					{{#no_logotype}}{{store_name}}{{/no_logotype}}
                    </a>
					</h1>
				 
                <section class="page_column">

                    {{! This block is rendered when displaying a list of products }}        
                    {{#list_page}}
                    <div class="product_list">
                        <div class="product_list_wrapper">
                            {{! Output a list if we have any products }}
                            {{#products}}
                            <article id="{{id}}" class="product" data-url="{{url}}" data-price="{{price}}">
                                <a href="{{url}}" class="product_teaser" data-product-id="{{id}}">
                                    <div class="product_teaser_image">
                                        {{#primary_image}}
                                            <img src="//tictail.krmg.se/img/transparent.gif" data-src="{{url-300}}" class="lazy" alt="{{title}}"/>
                                            <noscript>
                                                <img src="{{url-300}}" data-src="{{url-300}}" class="noscript" alt="{{title}}"/>
                                            </noscript>
                                        {{/primary_image}}                  
                                    </div>
                                    <div class="product_teaser_hover">
                                        <div class="product_teaser_hover_wrapper">
                                            <h2 class="product_teaser_title">{{title}}</h2>
                                            <span class="product_teaser_price">{{price_with_currency}}</span>
                                            {{#out_of_stock}}<span class="product_teaser_stock">out of stock</span>{{/out_of_stock}}
                                        </div>
                                    </div>
                                </a>
                                <section class="product_detail" data-product-id="{{id}}">
                                    <div class="product_slide">
                                        <div class="product_slide_wrapper">
                                            {{#all_images}}
                                            <figure class="product_slide_figure">
                                                <img src="//tictail.krmg.se/img/transparent.gif" data-src="{{url-500}}" alt="{{title}} - {{position}}"/>
                                                <noscript>
                                                    <img src="{{url-500}}" data-src="{{url-500}}" class="noscript" alt="{{title}}"/>
                                                </noscript>
                                            </figure>
                                            {{/all_images}}
                                            
                                        </div>
                                    </div>
                                    <div class="details">
                                        <div class="product_detail_name">{{title}}</div>
                                        <div class="product_detail_price">{{price_with_currency}}</div>
                                        <div class="product_detail_description">{{description}}</div>
                                        <div class="product_detail_cart">
                                        {{#out_of_stock}}<div class="stock_label">Out of stock</div>{{/out_of_stock}}
                                        {{#add_to_cart}}
                                            {{#variations_select}}{{/variations_select}}
                                            <label class="variations_select_label">Select size</label>
                                            {{#add_to_cart_button}}Add to cart{{/add_to_cart_button}}
                                        {{/add_to_cart}}
                                        </div>
                                        <div class="product_detail_social">
                                            {{! facebook_like_button }}
                                            <a href="https://twitter.com/intent/tweet?original_referer={{store_url}}&related=tictail&text=Worth checking out! {{title}}" target="_blank" class="tweetbutton" title="Tweet">Tweet</a>
                                            {{pinterest_pin_it_button}}
                                        </div>
                                        <ul class="product_detail_terms">
                                            <li>
                                                {{#return_policy}}Return Policy{{/return_policy}}
                                            </li>
                                            <li>
                                                {{#terms}}Terms &amp; Conditions{{/terms}}
                                            </li>
                                        </ul>                                    
                                    </div>
                                </section>
                            </article>                        
                            {{/products}}
                            {{! END list of products }}
                        </div>
                    </div>
                    {{/list_page}}
                    
                    {{! This block is rendered when displaying a single product }}
                    {{#product_page}}
                    {{#product}}
                    <div class="product_single">
                        <article class="product_detail" data-product-id="{{id}}" itemscope itemtype="http://schema.org/Product">
                            <div class="product_slide">
                                <div class="product_slide_wrapper">
                                    {{#all_images}}
                                    <figure class="product_slide_figure">
                                        <img src="{{url-500}}" alt="{{title}} - {{position}}"{{#is_primary}} itemprop="image"{{/is_primary}}/>
                                    </figure>
                                    {{/all_images}}
                                    
                                </div>
                            </div>
                            <div class="details">
                                <div class="product_detail_name" itemprop="name">{{title}}</div>
                                <div class="product_detail_price" itemprop="offers" itemscope itemtype="http://schema.org/Offer"><span itemprop="price">{{price_with_currency}}</span></div>
                                <div class="product_detail_description" itemprop="description">{{description}}</div>
                                <div class="product_detail_cart">
                                {{#out_of_stock}}<div class="stock_label">Out of stock</div>{{/out_of_stock}}
                                {{#add_to_cart}}
                                    {{#variations_select}}{{/variations_select}}
                                    <label class="variations_select_label">Select size</label>
                                    {{#add_to_cart_button}}Add to cart{{/add_to_cart_button}}
                                {{/add_to_cart}}
                                </div>
                                <div class="product_detail_social">
                                    {{! facebook_like_button }}
                                    <a href="https://twitter.com/intent/tweet?original_referer={{store_url}}&related=tictail&text=Worth checking out! {{title}}" target="_blank" class="tweetbutton" title="Tweet">Tweet</a>
                                    {{pinterest_pin_it_button}}
                                </div>
                                <ul class="product_detail_terms">
                                    <li>
                                        {{#return_policy}}Return Policy{{/return_policy}}
                                    </li>
                                    <li>
                                        {{#terms}}Terms &amp; Conditions{{/terms}}
                                    </li>
                                </ul>                                    
                            </div>
                        </article>
                    </div>
                    {{/product}}
                    {{/product_page}}
                    {{! END single product }}
                
                    {{! This block is rendered when displaying the about page }}
                    {{#about_page}}
                    <article class="about_page">
                        <div class="post html_content">
                        <h2>About</h2>
                        {{store_description}}
                        </div>
                    </article>
                    {{/about_page}}
                    {{! END single product }}
                
                </section>
            </div>
        </div>
    </div>
    
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    {{!
    <script src="http://tictail.krmg.se/js/vendor/jquery.hammer.js"></script>
    <script src="http://tictail.krmg.se/js/vendor/sammy-0.7.4.min.js"></script>
    <script src="http://cdnjs.cloudflare.com/ajax/libs/gsap/1.9.3/TweenLite.min.js"></script>
    <script src="http://cdnjs.cloudflare.com/ajax/libs/gsap/1.9.3/plugins/CSSPlugin.min.js"></script>
    <script src="http://cdnjs.cloudflare.com/ajax/libs/gsap/1.9.3/plugins/ScrollToPlugin.min.js"></script>
    <script src="http://tictail.krmg.se/js/vendor/polyfills.js"></script>    
    }}
    <script src="http://tictail.krmg.se/js/dist/vendor-pack.min.js"></script>
    {{!<script src="http://tictail.krmg.se/js/dist/kramgo.min.js"></script>}}	
    <script src="http://tictail.krmg.se/js/app.js"></script>
    <script src="http://tictail.krmg.se/js/lazy.js"></script>
    <script src="http://tictail.krmg.se/js/menu.js"></script>
    <script src="http://tictail.krmg.se/js/page-helpers.js"></script>
    <script src="http://tictail.krmg.se/js/product.js"></script>
    <script src="http://tictail.krmg.se/js/product-list.js"></script>
    <script src="http://tictail.krmg.se/js/select-box.js"></script>
    <script src="http://tictail.krmg.se/js/swipe.js"></script>
    <script src="http://tictail.krmg.se/js/utils.js"></script>    
    {{!
    <script>
    $('a.klarna_popup').click(function(e) {
        e.preventDefault();
        var win = window.open($(this).attr('href'), 'klarnaPopupWindow', 'width=600,height=500,menubar=no,location=no,toolbar=no,status=no,directories=no');
        win.focus();
    });
    </script>

    }}
</body>
</html>

<!--
Want to create your own awsome Tictail theme?
Check out the documentation at https://tictail.com/docs
-->






