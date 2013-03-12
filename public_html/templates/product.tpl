{extends file="layout.tpl"}

{block name=title}Tictail shop{/block}

{block name=head}
  <!-- link href="/css/mypage.css" rel="stylesheet" type="text/css"/ -->
  <!-- script src="/js/mypage.js"></script-->
{/block}

{block name=body}
	<header class="main-header">
		<a href="/">
		<h1>My Tictail Store</h1>
		</a>
	</header>
	<article class="product">
		<figure class="product-image">
			<div id='slider' class='swipe'>
				<div class='swipe-wrap'>
					<div><img src="dummy-content/product-slide/6.jpg" alt="" /></div>
					<div><img src="dummy-content/product-slide/7.jpg" alt="" /></div>
					<div><img src="dummy-content/product-slide/8.jpg" alt="" /></div>
					<div><img src="dummy-content/product-slide/9.jpg" alt="" /></div>
				</div>
			</div>
		</figure>
		<div class="product-description">
			<h2>A.P.C. Backpack Dark Green</h2>
			<p>The Backpack from A.P.C. is a classically designed rucksack, made from ultra-durable Japanese Nylon. It features a zipped main compartment and front pocket, adjustable padded shoulder straps and a waist strap, and plenty of inner storage pockets. This backpack is perfect for daily usage while ensuring an artsy look.</p>
			<h3>Material:</h3>
			<p>100% nylon, 100% calf leather base</p>
			<h3>Measurements:</h3>
			<p>Width 52cm, height 28cm, depth 36cm</p>
		
			<a href="#" class="button">Select size</a>
			<a href="#" class="button disabled">Add to cart</a>
			<a href="#" class="button-text">Return policy</a>
			<a href="#" class="button-text">Terms &amp; conditions</a>
		</div>
	
	</article>
{/block}
