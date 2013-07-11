(exports ? this).krmg ?= {}
class krmg.Product
  constructor: (@container) ->
    @teaser = @container.find(".product_teaser").first()
    @detail = @container.find(".product_detail").first()
    @slider = @container.find(".product_slide").first()
    @images = @container.find(".product_slide_figure img")
    @index  = @container.find(".product_slider_index").first()
    @parent = @container.parent()
    # @hover  = @container.find(".product_teaser_hover .product_teaser_hover_body").first()
    @swipe  = null
    
    if @teaser.length
      @detail.detach()
      @detail.show() #ToDo. instead of jquery show, we should toggle a class. maby .loading 
      @row = 0
      @url = @teaser.attr("href").replace krmg.RE.clean, ""
    else
      @size("load")
      @size("write")
      @select true
    @

  select: (@selected = true) ->
    if @selected
      for img in @images
        src = img.getAttribute("data-src")
        img.removeAttribute("data-src")
        img.src = src if src?
      if not @swipe # and @images.length > 1
        if @index.length && @index.children().length > 1
          @index.children()[0].className = "active"
          @index.show()
        
        @swipe = new krmg.Swipe @slider[0],
          continuous: true
          disableScroll: false
          stopPropagation: false
          mouse: true
          transitionEnd: (swipe, index, slide) =>
            i = parseInt(slide.getAttribute("data-index"))
            if @index.length
              @index.children().removeClass("active")
              @index.children()[i].className = "active"
      else if  @swipe
        @swipe.setup()

      unless @social
        if window.FB?
          FB.XFBML.parse(@detail[0])
        if window.twttr? and window.twttr.widgets?
          window.twttr.widgets.load()
        @social = true

    else
      @detail.detach()
    @
  size: (action)->
    if action == "reset"
      # @hover.removeAttr("style")
    else if action == "load"
      @parent_bounds = @parent[0].getBoundingClientRect()
      @bounds = @container[0].getBoundingClientRect()
    else if action = "write"
      width = @parent_bounds.width | @parent_bounds.right - @parent_bounds.left 
      @slider.height( Math.round(width * (2/3) ))
    return @bounds
  top: ->
    @container.position().top
  delete: ->
    for prop of @
      @[prop].off() if @[prop] instanceof jQuery
      @[prop] = null if @hasOwnProperty(prop)
    return


