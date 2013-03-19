{extends file="layout.tpl"}

{block name=title}Start{/block}

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

	<section class="hero gutter">
		<div id='slider' class='swipe'>
			<div class='swipe-wrap'>
				<div><img src="dummy-content/product-slide/1.jpg" alt="" /></div>
				<div><img src="dummy-content/product-slide/2.jpg" alt="" /></div>
				<div><img src="dummy-content/product-slide/3.jpg" alt="" /></div>
				<div><img src="dummy-content/product-slide/4.jpg" alt="" /></div>
			</div>
		</div>	
	</section>
	
	{assign var='count' value=$count|default:'15'}
	<section class="grid">
	{foreach from=$products key=index item=product}
		<article class="teaser">
		<a href="/?p=product">
			<div class="teaser-gutter"><div class="teaser-wrapper">
				<div class="teaser-description js-align-vertical">
					<h3 class="teaser-category">wood wood</h3>
					<h2 class="teaser-title">Guadini shirt</h2>
					<h4 class="teaser-variation">White/striped</h4>
					<span class="teaser-price">€150.00</span>
				</div>
				<figure class="teaser-content">
					<img src="http://src.sencha.io/-40x50/http://tictail.krmg.se/{$product->file}" alt="{$product->name}" />
				</figure>
			</div></div>
		</a>
		</article>
	{/foreach}
	</section>

		
{/block}
