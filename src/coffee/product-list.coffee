class ProductList
  constructor: () ->
    @list = []
    @first = []
    @

  show: (url) ->
    url = url.replace krmg.RE.clean, ""
    obj = null
    for product in @list
      obj = product if product.url == url
  

    for product in @list
      product.select(false) if product != obj && product.row == obj.row
   
    obj.select()
    @active = obj
    @insert_detail obj, obj.row + 1

    offset = 0
    TweenLite.to window, 0.25,
      scrollTo:
        y: obj.detail.offset().top - offset
        x: $(window).scrollLeft()
      ease: Power2.easeIn
    @
  insert_detail: (obj, row) ->
    unless @container
      @container = $(".product_list")
    target = null
    detail = obj.detail[0]
    parent = obj.container.parent()[0]
    target = @first[row].container[0] if @first[row]
    # ToDo clean this ugly chain.
    try
      parent.insertBefore detail, target
    catch e
      console.log e
    @
  load: ->
    ref = $(".product_list .product")
    if ref.length
      for child in ref
        @list.push new krmg.Product $(child)
    @
  index: ->
    row = top = -1
    open = []
    @first.pop() while @first.length
    for obj in @list
      if obj.selected
        obj.select false
        open.push obj
    
    #ToDo: optimize screen rewrite
    obj.size("reset") for obj in @list
    obj.size("load") for obj in @list
    obj.size("write") for obj in @list

    for obj in @list
      if obj.size().top > top
        row++
        @first[row] = obj
      obj.row = row
      top = obj.size().top
    
    p = -1
    if @active
      for obj in open
        r = obj.row + 1
        # prioritize active url obj and first obj in row
        if obj == @active || ( obj.row != @active.row && r != p )
          @insert_detail obj, r
          obj.select true
          p = r
    @
 
  flush: ->
    @active = null
    @first.pop() while @first.length
    @list.pop().delete() while @list.length
    @

(exports ? this).krmg ?= {}

krmg.ProductList = new ProductList()
