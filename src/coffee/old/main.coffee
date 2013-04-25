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
###
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
###
# jquery document ready

hover = (event) ->
  event.data.toggleClass "hover", (event.type == "touch")

$(document).ready ->
  console.log "\\(x.×)/we are kramgo\\(x.×)/"
  console.log "-----^*_lopiloopilopi_*^-----"
  console.log "Copyright Alexander Aivars"

  # disable the dragging of images on desktop browsers
  $("img").on "dragstart", () ->
    return false
  
  layout
  ref = $(".js-align-vertical")
  if ref.length
    for elm in ref
      unless layout
        layout = new ElementLayout()
      layout.add(elm)
    layout.render()
  
  ref = $(".jsSelectLable")
  if ref.length
    for elm in ref
      instance = new SelectLable(elm)

  mySwipe = new Swipe(document.getElementById("slider"),
    continuous: true
    disableScroll: false
    stopPropagation: false
    mouse: true
    auto: 0
    delay: 15000
  )
  
  ###
  if Modernizr.touch
    ref = $(".teaser")
    if ref.length
      for elm in ref
        j = $(elm)
        j.on "touch tap release", j,  (event) ->
          if (event.type == "tap")
            j.find("a")[0].click()
          else
            requestAnimationFrame ( (event) => hover(event) )

   
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
  
  ###
  new SlideMenu $("#container"), $("#nav"), $("#content")

class ElementLayout
  constructor: ->
    @elements = []
    @invalid = false
    @waiting = false
    $(window).on "resize", (event) => @render()
    return

  add: (elm) ->
    @invalid = true
    obj = $(elm)
    @elements.push obj
    return
  
  render: () ->
    unless @waiting
      requestAnimationFrame () => @draw()
    @waiting = true

    return

  draw: () ->
    # Do nothing if ther's no change.
    @waiting = false
    for elm in @elements
      elm.py = Math.floor (elm.parent().outerHeight() - elm.outerHeight() ) * 0.5
      
    for elm in @elements
      elm.css "bottom", elm.py

    return
  
class SlideMenu
  
  constructor: (@container, @menu, @content) ->
    @width = @menu.width()
    @touch = Hammer @container[0]
    @delta = 0
    @dragX = 0
    @touch.on "touch dragleft dragright swipeleft swiperight release", (event) => @touchHandler(event)
    
    Hammer($("[data-action=menu-toggle]")[0]).on "tap", (event) => @toggle(event)

    return

  touchHandler: (event) ->
    # disable browser scrolling
    event.preventDefault()
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

  toggle: (event) ->
    event.preventDefault()
    event.gesture.preventDefault()
    if @dragX > @width * 0.5
      @setOffset 0, true
    else
      @setOffset @width, true
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
 
class SelectLable
  
  prefix: ''

  constructor: (element) ->
    @source = (if (element instanceof jQuery) then element else $(element))
    prefix = @source.data('prefix')
    if prefix
      @prefix = prefix
  

    if @source[0].tagName.toLowerCase() is 'label'
      @target = $("#" + @source.attr('for'))
    else
      @target = $("#" + @source.data('for'))

    if @target
      @target.on 'change', (event) => @targetChanged()
      @targetChanged()
    return

  targetChanged: () ->
    try
      $elm = $(@target[0].options[@target[0].selectedIndex])
      if not $elm.data('noprefix')
        @source.html(@prefix + $elm[0].innerHTML)
      else
        @source.html($elm[0].innerHTML)
    catch e
      console.log @source.attr('for')
      console.log "Missing target element for this label"
      console.log @source

class ToggleElement
  constructor: (element) ->
    @source = (if (element instanceof jQuery) then element else $(element))
    @statusClass = @source.data("statusclass") or "toggled"
    @activeClass = @source.data("activeclass") or "active"
    @toggleClass = @source.data("toggleclass") or "jsDisplayNone"
    
    _target = @source.data('target')
    if _target == 'previous'
      @target = [@source.prev()]
    else if _target == 'parent'
      @target = [@source.parent()]
    else if _target.indexOf('#') >= 0 || _target.indexOf('.') >= 0
      @target = []
      for elm in _target.split(/\s+/)
        @target.push $(elm)
    else
      @target = [@source.next()]

    if @target
      @source.on "click", (event) =>
        event.stopPropagation()
        @clicked event
        return
    return
  click: () ->
    @source.click()

  clicked: (event) ->
    event.preventDefault()
    
    for _elm in @target
      # console.log $(window).scrollTop()
      # console.log _elm.offset()
      _elm.toggleClass @toggleClass
    @source.toggleClass @statusClass


