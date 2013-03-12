{extends file="layout.tpl"}

{block name=title}Start{/block}

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
		<a href="/?p=product">
		<article class="teaser">
			<div class="teaser-gutter"><div class="teaser-wrapper">
				<figure class="teaser-content">
					<img src="{$product->file}" alt="{$product->name}" />
				</figure>
			</div></div>
		</article>
		</a>
	{/foreach}
	</section>

		
{/block}
