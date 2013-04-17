{extends file="layout-simple.tpl"}
{block name=title}Tictail shop{/block}
{block name=body}
			<div class="swipe" style="display:none">
				<div class"swipe-wrap">
					<div><img src="dummy-content/swipe-setup/A.jpg"/></div>
					<div><img src="dummy-content/swipe-setup/B.jpg"/></div>
					<div><img src="dummy-content/swipe-setup/C.jpg"/></div>
				</div>
			</div>
<section class="box-grid">
		<article id="box-view" class="box-row">
			<div class="box-wrapper">
				<img src="/dummy-content/product-teaser/apc-sweat-geo001.jpg"/>
				<p>Donec augue sapien, rutrum ut ullamcorper id, varius ac elit. Curabitur diam magna, lacinia vitae hendrerit vitae, mattis vitae est. Donec vestibulum ullamcorper nisi ut laoreet. Nullam bibendum nibh vitae est consequat sit amet ultricies elit placerat. Pellentesque et elit augue. Duis egestas mollis erat vitae egestas. Curabitur pharetra, lacus eu aliquet volutpat, odio velit luctus dolor, vitae laoreet ligula dolor non dolor.</p>
				<p>Aliquam erat volutpat. Curabitur congue tincidunt velit, sed viverra urna ultrices a. Cras non dolor a quam rhoncus malesuada at a risus. Suspendisse congue est vel felis tempor fermentum imperdiet velit dapibus. Integer eu lectus et odio bibendum blandit. Vivamus euismod, sapien at sodales venenatis, ipsum lacus sagittis arcu, vestibulum elementum libero lorem in nisl. Nunc elit sapien, suscipit a condimentum in, mollis sit amet turpis.</p>
				<p>Praesent sed eleifend enim. Nunc ante lectus, blandit sit amet porta quis, fermentum ac tortor. Integer semper lorem a diam tempus cursus. Curabitur eleifend eros sapien, id pharetra lorem. Donec lobortis vestibulum lectus, quis rhoncus purus vestibulum consectetur. Integer aliquam urna vitae elit pellentesque ultricies. Nullam tellus mauris, interdum quis lobortis nec, lacinia quis tellus. Quisque risus mauris, volutpat sed venenatis vitae, imperdiet et metus. Mauris id lacus malesuada urna imperdiet malesuada a ac libero. Integer sapien mi, dictum id imperdiet ac, elementum in arcu. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam eget nibh a nisl facilisis varius non et ante.</p>
			</div>
		</article>
	
		{assign var='count' value=$count|default:'15'}
		{foreach from=$products key=index item=product}
		<article class="box">
			<div class="box-wrapper">
				<div class="box-header">
					<img src="{$product->file}" alt="{$product->name}" />
				</div>
				<div class="box-body">
					<h2>Header</h2>
					<h3>Sub header</h3>
					<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque in facilisis ligula. Sed nulla elit, malesuada id placerat id, imperdiet vitae enim.</p>
				</div>
				<div class="box-overlay">
					[HOVER]
				</div>
			</div>
		</article>
		{/foreach}
</section>
{/block}
