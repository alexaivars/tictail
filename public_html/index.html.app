<html>
<head>
<style>
	.selected {
		display: block;
		color: red;
	}

	.selected + ul {
		display: block;
	}
	li > ul {
		display: none;
	}
	.content_body .product_teaser {
		display: block; 
		background: yellow;
		width: 150px;
		height: 150px;
		border: 1px solid red;
	}
	.content_body .product {
		float: left;
	}
	.content_body .product_detail {
		display: block; 
		background: green;
		width: 100%;
		height: 300px;
		clear: both;
	}
</style>
</head>
<body>
	<ul class="navigation">
		<li><a href="#/">All products</a></li>
		<li><a href="#products/jeans1">jeans1</a></li>
		<li><a href="/#products/jeans2">jeans2</a></li>
		<li><a href="#/products/jeans3">jeans3</a></li>
		<li><a href="/#/products/jeans4">jeans3</a></li>
		<li>
			<a href="#products/women">women</a>
			<ul>
				<li><a href="#products/tops">tops</a></li>
				<li><a href="#products/dresses">dresses</a></li>
			</ul>
		</li>	
	</ul>
	<div class="product_list">
		<!--div class="product">
			<a href="#product/jeans-1" class="product_teaser">jeans #1</a>
			<div class="product_detail">info about jeans #1</div>
		</div>
		<div class="product">
			<a href="#product/top-1" class="product_teaser">top #1</a>
			<div class="product_detail">info about top #1</div>
		</div>

		<div class="product">
			<a href="#product/dress-1" class="product_teaser">dress #1</a>
			<div class="product_detail">info about dress #1</div>
		</div>

		<div class="product">
			<a href="#product/dress-2" class="product_teaser">dress #2</a>
			<div class="product_detail">info about dress #2</div>
		</div>

		<div class="product">
			<a href="#product/dress-3" class="product_teaser">dress #3</a>
			<div class="product_detail">info about dress #3</div>
		</div-->
	</div>
	<script src="/js/vendor/jquery-1.9.1.min.js"></script>	
	<script src="/js/vendor/sammy-0.7.4.min.js"></script>	
	<script src="http://cdnjs.cloudflare.com/ajax/libs/gsap/1.9.3/TweenLite.min.js"></script>
	<script src="http://cdnjs.cloudflare.com/ajax/libs/gsap/1.9.3/plugins/CSSPlugin.min.js"></script>
	<script src="http://cdnjs.cloudflare.com/ajax/libs/gsap/1.9.3/plugins/ScrollToPlugin.min.js"></script>
	<script src="/js/app.js"></script>	
</body>
</html>

