(exports ? this).krmg ?= {}
class krmg.Product
  constructor: (@container) ->
    @teaser = @container.find(".product_teaser").first()
    @detail = @container.find(".product_detail").first()
    @slider = @container.find(".product_slide").first()
    @images = @container.find(".product_slide_figure img")
    @hover  = @container.find(".product_teaser_hover .wrapper").first()
    @swipe  = null
    @detail.detach()
    @detail.show() #ToDo. instead of jquery show, we should toggle a class. maby .loading 
    @row = 0
    @url = @teaser.attr("href").replace krmg.RE.clean, ""
    @
  select: (@selected = true) ->
    if @selected
      for img in @images
        src = img.getAttribute("data-src")
        img.removeAttribute("data-src")
        img.src = src if src?
      if not @swipe and @images.length > 1
        @swipe = new krmg.Swipe @slider[0],
          continuous: true
          disableScroll: false
          stopPropagation: false
          mouse: true
      else if  @swipe
        @swipe.setup()
    else
      @detail.detach()
    @
  size: (action)->
    if action == "reset"
      @hover.removeAttr("style")
    else if action == "load"
      @hover_bounds = @hover[0].getBoundingClientRect()
      @container_bounds = @container[0].getBoundingClientRect()
      @list_bounds = $(".product_list")[0].getBoundingClientRect()
    else if action = "write"
      @hover.css
        position: "absolute"
        top: Math.round((@container_bounds.height - @hover_bounds.height ) * 0.5)
      
      @slider.css
        width: @list_bounds.width
        height: Math.round(@list_bounds.width * 0.5625 )
      @slider.width( @list_bounds.width )

    return @container_bounds
  top: ->
    @container.position().top
  delete: ->
    for prop of @
      @[prop].off() if @[prop] instanceof jQuery
      @[prop] = null if @hasOwnProperty(prop)
    return


