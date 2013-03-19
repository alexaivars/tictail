{extends file="layout.tpl"}

{block name=title}Tictail shop{/block}

{block name=head}
  <!-- link href="/css/mypage.css" rel="stylesheet" type="text/css"/ -->
  <!-- script src="/js/mypage.js"></script-->
{/block}

{block name=body}
	<header class="main-header">
		<a href="/">
		<h1 class="logotype">My Tictail Store</h1>
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
			<h2 class="product-title">A.P.C. Backpack Dark Green</h2>
			<p>The Backpack from A.P.C. is a classically designed rucksack, made from ultra-durable Japanese Nylon. It features a zipped main compartment and front pocket, adjustable padded shoulder straps and a waist strap, and plenty of inner storage pockets. This backpack is perfect for daily usage while ensuring an artsy look.</p>
			<div class="product-cart">
				<form class="button button-select">
					<select name="variations" id="variations">	
						<option value="small" data-noprefix="true">Small</option>
						<option value="medium">Medium</option>
						<option value="large">Large</option>
					</select>
					<noscript>
						<button type="submit" value="go" name="go"/>;
					</noscript>
					<label class="selectLabel jsSelectLable" for="variations" data-prefix="">Small</label>				
				</form>	
				<a href="#" class="button">Add to cart</a>
				<a href="#" class="button disabled">Add to cart</a>
			</div>
			<div class="product-legal">
			<a href="#" class="button-text">Return policy</a>
				<a href="#" class="button-text">Terms &amp; conditions</a>
			</div>
		</div>
	
	</article>
{/block}
