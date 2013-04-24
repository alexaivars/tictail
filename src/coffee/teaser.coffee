## Because we are lazy and like to console log.
window.console ?=
  log:->
    return

## Util function
getNextRow = (element) ->
  nextSibling = element.nextSibling
  nextSibling = nextSibling.nextSibling while nextSibling && nextSibling.nodeType != 1
  unless nextSibling then return false
  else if nextSibling.offsetTop == element.offsetTop then return getNextRow nextSibling
  else return nextSibling

inView = (elm) ->
  rect = elm.parentNode.getBoundingClientRect()
  height = (window.innerHeight or document.documentElement.clientHeight)
  rect.top >= 0 and rect.top <= height or rect.bottom >= 0 and rect.bottom <= height


removeToInsertLater = (element) ->
  parentNode = element.parentNode
  nextSibling = element.nextSibling
  parentNode.removeChild element
  ->
    if nextSibling
      parentNode.insertBefore element, nextSibling
    else
      parentNode.appendChild element



#/product/dan-tee-white

app = null

$(document).ready ->
  handler = null
  ref = $(".product")
  if ref.length
    for element in ref
      handler = new Handler() unless handler?
      handler.add new Product(element)
    handler.draw()

  app = $.sammy ".page_content", () ->
    @get "#/", (context) ->
      # Index page
      return

    @get "#/product/:name", (context) ->
      # context.log "its #{@params["name"]}"
      handler.show "/product/#{@params["name"]}"
        
  app.run('#/')

class Handler
  constructor: ->
    @container = $(".product_list")[0]
    @products = []
    @draw_pending = false
    $(window).on "resize", () => @redraw()
    @

  add: (product) ->
    @products.push product
    @

  show: (url) ->
    for product in @products
      if product.url == url
        product.toggle()
    @

  redraw: ->
    if @draw_pending then return
    @draw_pending = true
    requestAnimationFrame () => @draw()

  draw: ->
    max = 0
    # insertFunction = removeToInsertLater(@container)
    for product in @products
      product.reset()
    # insertFunction()
    
    for product in @products
      height = product.height()
      max = height if height > max
    
    # insertFunction = removeToInsertLater(@container)
    for product in @products
      product.resize(max)
    # insertFunction()

    @draw_pending = false
    return


class Product
  constructor: (element) ->
    @element = if element instanceof jQuery then element else $(element)
    @teaser = new ProductTeaser @element.find(".product_teaser").first()
    @detail = new ProductDetail @element.find(".product_detail")[0], @element[0]
    @url = @element.data("url")
    # Fast click
    @element.on "click", (event) ->
      event.preventDefault()
      event.stopPropagation()
      event.stopImmediatePropagation()
      return false

    Hammer(@element[0]).on "tap doubletap", (event) => @selected(event)
    @

  selected: (event) ->
    app.setLocation "##{@url}"
    event.preventDefault()
    return

  toggle: (event) ->
    event.preventDefault() if event
    @detail.moveNode()
    @teaser.select()
    # @detail.show(@teaser.height() * 0.5)
    @detail.show(0)
    return false

  reset: ->
    @teaser.reset()
    @
    
  height: ->
    @teaser.calc().height()

  resize: (val) ->
    @teaser.height(val)

###
#load = (elm, express) ->
  img = new Image()
  src = elm.getAttribute("data-src")
  img.onload = ->
    unless not elm.parent
      elm.parent.replaceChild img, elm
    else
      elm.src = src
    unless express
      TweenLite.from elm, 0.25,
        opacity : 0
###

$(window).on "resize", () ->
  ref = $(".product_detail.selected")
  if ref.length
    for elm in ref
      obj = $(elm)
      width = $(".product_list").width()
      height = Math.round( width * (2/3) )
      obj.find(".product_slide").first().width(width)
      obj.find(".product_slide").first().height(height)

slideImage = []
layoutSlide = () ->
  for img in slideImage
    cosoleole.log img.height()

loadSlide = (elm) ->
  src = elm.getAttribute("data-src")
  if src?
    elm.src = src

  # img.onload = ->
  #   TweenLite.from elm, 2,
  #    opacity : 0
  #  layoutSlide()
  # img.src = src

class ProductDetail
  constructor: (@element, @container) ->
    return
  moveNode: () ->
    @element.parentNode.removeChild @element
    
    parent =  @container.parentNode
    nextSibling = getNextRow @container
    
    parent.insertBefore @element, nextSibling

    return

  show: (offset) ->

    obj = $(@element)
    width = $(".product_list").width()
    height = Math.round( width * (2/3) )
    obj.find(".product_slide").first().width(width)
    obj.find(".product_slide").first().height(height)
    swipe = obj.find(".product_slide").first()[0].swipe
    
        
    next = obj.next()
    while next.length && next.hasClass("product_detail")
      next.toggleClass("selected",false)
      next = next.next()

    obj.toggleClass("selected",true)
    slides = obj.find(".product_slide_figure img")
    if swipe?
      swipe.setup()
    

    for slide in slides
      loadSlide slide
    

    # unless inView(@element)
    TweenLite.to window, 0.25,
      scrollTo:
        y:obj.offset().top - offset
        x: $(window).scrollLeft()
      ease: Power2.easeIn
    return

class ProductTeaser
  constructor: (element) ->
    @element = if element instanceof jQuery then element else $(element)
    @hover = @element.find(".product_teaser_hover .wrapper").first()
    return

  reset: ->
    @element.removeAttr("style")
    @hover.removeAttr("style")
    @

  height: (val) ->
    unless val then return @heightElm
    @element.height(val)
    @element.css
      position: "relative"
    top = Math.round((val - @heightHover) * 0.5)
    @hover.css
      position: "absolute"
      top: "#{top}px"
    @

  calc: ->
    @heightElm = @element.height()
    @heightHover = @hover.height()
    @

  select: (toggle = true)->
    # ToDo: better solution for deslecting
    $(".product_teaser").toggleClass "selected", false
    @element.toggleClass "selected", toggle
    @

enquire.register "screen and (min-width: 300px) and (max-width: 500px)",
  match : () ->
    console.log "match 1"
  unmatch: () ->
    console.log "unmatch"
  setup: () ->
    console.log "setup"
  deferSetup: true
.register "screen and (min-width: 500px) and (max-width: 800px)",
  match : () ->
    console.log "match 2"
  unmatch: () ->
    console.log "unmatch"
  setup: () ->
    console.log "setup"
  deferSetup: true
.register "screen and (min-width: 800px)",
  match : () ->
    console.log "match 3"
  unmatch: () ->
    console.log "unmatch"
  setup: () ->
    console.log "setup"
  deferSetup: true
