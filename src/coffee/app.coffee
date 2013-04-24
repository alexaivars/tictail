## polyfills
(->
  lastTime = 0
  vendors = ["ms", "moz", "webkit", "o"]
  x = 0

  while x < vendors.length and not window.requestAnimationFrame
    window.requestAnimationFrame = window[vendors[x] + "RequestAnimationFrame"]
    window.cancelAnimationFrame = window[vendors[x] + "CancelAnimationFrame"] or window[vendors[x] + "CancelRequestAnimationFrame"]
    ++x
  unless window.requestAnimationFrame
    window.requestAnimationFrame = (callback, element) ->
      currTime = new Date().getTime()
      timeToCall = Math.max(0, 16 - (currTime - lastTime))
      id = window.setTimeout(->
        callback currTime + timeToCall
      , timeToCall)
      lastTime = currTime + timeToCall
      id
  unless window.cancelAnimationFrame
    window.cancelAnimationFrame = (id) ->
      clearTimeout id
)()


## Because we are lazy and like to console log.
window.console ?=
  log:->
    return

reWash1 = /<(script|head|style|iframe|frame|noscript)[^\>]*>[\s\S]*?<\/.*?\1>/gi
reWash2 = /<(!doctype|head|html|body).*?>/gi
reWash3 = /<\/.*?(head|html|body)>/gi
reWash4 = /<!--[\s\S]*?-->/gi
reClean = /^\/\#|^\/|\#|\/\#/
images  = []

removeToInsertLater = (element) ->
  parentNode = element.parentNode
  nextSibling = element.nextSibling
  parentNode.removeChild element
  ->
    if nextSibling
      parentNode.insertBefore element, nextSibling
    else
      parentNode.appendChild elemenMissing TT.store.domReadyt

unstyle = (element) ->
  element.removeAttribute("style")
  if element.children.length
    for child in element.children
      unstyle child
  return element


wash = (html) ->
  html = html.replace reWash1, ""
  html = html.replace reWash2, ""
  html = html.replace reWash3, ""
  html = html.replace reWash4, ""
  return html

read = (html, target) ->
  doc = document
  if document.implementation? && document.implementation.createHTMLDocument?
    try
      doc = document.implementation.createHTMLDocument("")
    catch e
      doc = document

  container = doc.createElement('div')
  container.innerHTML = html

  $(target).first().html $(container).find(target).first().html()
  try
    TT.store.domReady()
  catch e
    console.log "Missing TT.store.domReady"

class ProductList
  constructor: (@container) ->
    @list = []
    @first = []
    @

  show: (url) ->
    url = url.replace reClean, ""
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
        @list.push new Product $(child)
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

class Product
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
    @url = @teaser.attr("href").replace reClean, ""
    @
  select: (@selected = true) ->
    if @selected
      for img in @images
        src = img.getAttribute("data-src")
        img.removeAttribute("data-src")
        img.src = src if src?
      if not @swipe and @images.length > 1
        @swipe = new Swipe @slider[0],
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


list = new ProductList($(".product_list"))
cat = "index"
app = $.sammy ".page_column", () ->

  @get "/", (context) ->
    unless cat == "index"
      context.load("/")
      .then (html) ->
        wash(html)
        read wash(html), ".page_column"
        init()
        return
    return
  
  @get /products\/(.*)/, (context) ->
    console.log context.params
    category = context.params["splat"][0]
    cat = category
    context.load("products/#{category}")
    .then (html) ->
      wash(html)
      read wash(html), ".page_column"
      init()
      return

  @get /product\/(.*)/, (context) ->
    name = context.params["splat"][0]
    target = $(".page_column a[href$='product/#{name}']")
    $(".page_column .selected").removeClass "selected"
    target.addClass "selected"
    list.show @path
    #context.load("product/#{context.params["name"]}")
    # .then (html) ->
    #  read wash(html), ".content_body"
    return
  
  @get /page\/(.*)/, (context) ->
    name = context.params["splat"][0]
    cat = name
    console.log name
    context.load("page/#{name}")
    .then (html) ->
      list.flush()
      read wash(html), ".page_column"
      clean()
    return

  @bind "event-context-after", (event) ->
    target = $(".navigation a[href$='#{@path.replace /^\/\#|^\//, ""}']")
    $(".navigation .selected").removeClass "selected" if target.length
    target.addClass "selected"
    $(".navigation ul").has(".selected").addClass "selected"
    return



loadLazy = (elm, express) ->
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

  img.src = src

inView = (elm) ->
  rect = elm.parentNode.getBoundingClientRect()
  height = (window.innerHeight or document.documentElement.clientHeight)
  rect.top >= 0 and rect.top <= height or rect.bottom >= 0 and rect.bottom <= height


processScroll = (express) ->
  unless images.length then return
  queue = []
  pending = false
  for img in images
    queue.push img if inView img
	
  for img in queue
    images.splice images.indexOf(img), 1
    loadLazy img, express
  return


init = () ->
  $(".product_slide_figure img").on "dragstart", (event) ->
    event.preventDefault()
    return false
  list.flush().load().index()
  images = $("img.lazy").toArray()
  processScroll()

clean = () ->
  ref = $(".html_content")
  if ref.length
    for element in ref
      insert = removeToInsertLater element
      unstyle(element)
      element.className = element.className.replace(/html_content\s*/,"")
      insert()
  return

$(document).ready ->
  init()
  app.run()
  clean()

scrolling = false
$(window).on "scroll", () ->
  unless scrolling
    scrolling = true
    window.requestAnimationFrame () ->
      processScroll()
      scrolling = false
      
resizing = false
$(window).on "resize", () ->
  unless resizing
    resizing = true
    window.requestAnimationFrame () ->
      list.index()
      processScroll()
      resizing = false

# Client-side routes
###
    Sammy () ->
    @get '/products', () ->
      console.log "list all products"
      # $.get("/mail", { folder: this.params.folder }, self.chosenFolderData)
      return
    @get /\#\/products\/(.*)/, () ->
      console.log "list #{@params['splat']} products"
      # $.get("/mail", { folder: this.params.folder }, self.chosenFolderData)
      return
    @get /\#\/product\/(.*)/, () ->
      console.log "show product #{@params['splat']}"
      # $.get("/mail", { folder: this.params.folder }, self.chosenFolderData)
      return
    @get /\#\/(.*)/, () ->
      console.log "show other #{@params['splat']}"
      return
    @get '', () ->
      console.log "show default"
      return
  .run()
###




