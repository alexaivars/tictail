## Because we are lazy and like to console log.
window.console ?=
  log:->
    return

################################################################################
#
# Initalization
#
################################################################################

# requestAnimationFrame and cancel polyfill
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


# jquery document ready
$(document).ready ->
  console.log "\\(x.×)/we are kramgo\\(x.×)/"
  console.log "-----^*_lopiloopilopi_*^-----"
  console.log "Copyright Alexander Aivars"
  
  ref = $("X.product-teaser")
  teaser = null
  if ref.length
    for elm in ref
      unless teaser
        teaser = new Teaser()
      teaser.add($(elm))
  if teaser then teaser.draw()

  ref = $(".jsFlexbox")
  if ref.length
    for elm in ref
      flexbox = new FlexBox($(elm))
      flexbox.draw()
      flexbox = null
  
  new SlideMenu $("#container"), $("#nav"), $("#content")

class SlideMenu
  
  constructor: (@container, @menu, @content) ->
    @width = @menu.width()
    @touch = Hammer @container[0]
    @delta = 0
    @dragX = 0
    @touch.on "touch dragleft dragright swipeleft swiperight release", (event) => @touchHandler(event)
    return

  touchHandler: (event) ->
    # disable browser scrolling
    switch event.type
      when "touch"
        @delta = @dragX
        @container.removeClass "animate"
      when "dragright", "dragleft"
        event.gesture.preventDefault()
        @setOffset Math.max(0,Math.min(@width,event.gesture.deltaX + @delta))
      when "swiperight"
        @setOffset @width, true
      when "swipeleft"
        @setOffset 0, true
      when "release"
        if @dragX > @width * 0.5
          @setOffset @width, true
        else
          @setOffset 0, true
    return

  setOffset:  (px, animate) ->
    @dragX = px
    @container.toggleClass "animate", animate
    if Modernizr.csstransforms3d
      @container.css "transform", "translate3d(#{px}px, 0, 0) scale3d(1,1,1)"
    else if Modernizr.csstransforms
      @container.css "transform", "translate(#{px}px, 0)"
    else
      @container.css "left", "#{px}px"



class FlexBox
  constructor: (@container) ->
    @boxes = []
    for elm in @container.children()
      @boxes.push $(elm)
    $(window).on "resize", (event) => @draw()

    return
  draw: () ->
    h = 0
    for box in @boxes
      val = box.height('auto').height()
      h = val if val > h
    for box in @boxes
      box.height(h)
    return


class Teaser
  constructor: (@container) ->
    @refs = []
    $(window).on "resize", (event) => @draw()
    return

  add: (elm) ->
    @refs.push $(elm)
    elm.on "click", (event) => @clicked(event, elm)
    return
  
  draw: () ->
    for ref in @refs
      heading = $(ref).find("heading")
      if heading.length
        @layoutHeading(heading[0])
    return
  
  layoutHeading: (elm) ->
    total = 0
    for child in elm.children
      total += child.offsetHeight
    y = (elm.parentNode.offsetHeight - total) * 0.5
    
    for child in elm.children
      child.style.position = "absolute"
      child.style.top = "#{y}px"
      y += child.offsetHeight

    return

  clicked: (event, elm) ->
    unless event.target.nodeName.toLowerCase() == "a"
      elm.find("a")[0].click()
    return
