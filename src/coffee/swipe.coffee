
"use strict"
# requestAnimationFrame polyfil
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

# utilities
noop = () ->
  
offloadFn = (fn) ->           # offload a functions execution
  setTimeout(fn || noop, 0)

# check browser capabilities
BROWSER =
  addEventListener: !!window.addEventListener
  touch: Modernizr.touch
  transitions: Modernizr.csstransitions


# expose public swipe constuctor and api
class (exports ? this).Swipe
  constructor: (@container, options) ->
    # quit if no root element
    unless container then return

    # options and initial default values
    @options = options || {}
    @element = container.children[0]
    @index = parseInt(options.startSlide, 10) || 0
    @speed = options.speed || 300
  
    # application variables
    @slides = null
    @slidePos = null
    @width = null
    @timer = null
    @interactive = false
    @swiped = false
 
    # setup auto slideshow
    @delay = options.auto || 0
    
    @interval = null
  
    # setup initial vars
    @touch = Hammer @container
    @touch.on "touch dragleft swipeleft dragright swiperight release", (event) => @handleTouch(event)
    
    if options.mouse
      @touch.on "click mousemove mouseout", (event) => @handleMouse(event)

    @onresize = () =>
      requestAnimationFrame () => @setup()
 
    if BROWSER.transitions
      fn = ((event) => @handleTransition(event))
      @element.addEventListener 'webkitTransitionEnd', fn, false
      @element.addEventListener 'msTransitionEnd', fn, false
      @element.addEventListener 'oTransitionEnd', fn, false
      @element.addEventListener 'otransitionend', fn, false
      @element.addEventListener 'transitionend', fn, false
    if BROWSER.addEventListener
      window.addEventListener "resize", () => @onresize()
    else
      window.onresize = @onresize

    # setup
    @setup()
    
    # start auto slideshow if applicable
    if @delay
      setTimeout (() => @begin()), options.delay || 0
    
    #return our exposed public api and hide our "private" methods
    api =
      setup: =>
        @setup()
        @
      slide: (to, speed) =>
        @slide to, speed
        @
      prev: =>
        @stop()
        @prev()
        @
      next: =>
        @stop()
        @next()
        @
      getPos: =>
        @index
      kill: =>
        @teardown()
        return
    api.__proto__ = @.__proto__
    return api
  
  teardown: ->
    #cancel slideshow
    @stop()
    #reset element
    @element.style.width = 'auto'
    @element.style.left = 0
    #reset slides
    pos = @slides.length
    while pos--
      slide = @slides[pos]
      slide.style.width = '100%'
      slide.style.left = 0
      if BROWSER.transitions then @translate(pos, 0, 0)
    #removed event listeners
    @touch.off "touch dragleft swipeleft dragright swiperight release"
    @touch.off "click mousemove mouseout"
    if BROWSER.addEventListener
      window.removeEventListener "resize", @onresize
    else
      window.onresize = null
    return
  
  setup: ->
    # cache slides
    @slides = @element.children

    # create an array to store current positions of each slide
    @slidePos = new Array @slides.length
    
    # determine width of each slide
    bounds = @container.getBoundingClientRect()
    @width = bounds.width || @container.offsetWidth
    @height = bounds.height || @container.offsetHeight
    @element.style.width = (@slides.length * @width) + 'px'
    
    # stack slide elements
    pos = @slides.length
    while pos--
      slide = @slides[pos]
      slide.style.width = @width + 'px'
      slide.setAttribute 'data-index', pos
      if BROWSER.transitions
        slide.style.left = (pos * -@width) + 'px'
        @move pos, (if @index > pos then -@width else ((if @index < pos then @width else 0))), 0
    
    unless BROWSER.transitions
      @element.style.left = (@index * -@width) + 'px'
    
    @container.style.visibility = 'visible'
    return

  translate: (index, dist, speed) ->
    
    slide = @slides[index]
    style = slide && slide.style
    unless style then return

    style.webkitTransitionDuration =
    style.MozTransitionDuration =
    style.msTransitionDuration =
    style.OTransitionDuration =
    style.transitionDuration = speed + 'ms'
    style.webkitTransform = "translate3d(#{dist}px, 0, 0) scale3d(1,1,1)"
    # style.webkitTransform = "translate(#{_dist}px,0) translateZ(0)"
    style.msTransform =
    style.MozTransform =
    style.OTransform = "translateX(#{dist}px)"
    return

  move: (index, dist, speed) ->
    @translate(index, dist, speed)
    @slidePos[index] = dist
    return

  prev: ->
    if @index
      @slide @index - 1
    else if @options.continuous
      @slide @slides.length - 1
    return

  next: ->
    if @index < @slides.length - 1
      @slide @index + 1
    else if @options.continuous
      @slide 0
    return

  slide: (to, speed) ->
    # do nothing if already on requested slide
    return if @index is to
    speed = @speed unless speed?
    if BROWSER.transitions
      diff = Math.abs(@index - to) - 1
      direction = Math.abs(@index - to) / (@index - to) # 1:right -1:left
      while diff--
        @move ((if to > @index then to else @index)) - diff - 1, @width * direction, 0
      @move @index, @width * direction, speed
      @move to, 0, speed
    else
      @animate @index * -@width, to * -@width, speed
    @index = to
    offloadFn @options.callback and @options.callback(@index, @slides[@index])
    return

  animate: (from, to, speed) ->
    # if not an animation, just reposition
    unless speed
      @element.style.left = to + "px"
      return
    start = +new Date
    @timer = setInterval(=>
      timeElap = +new Date - start
      if timeElap > speed
        @element.style.left = to + "px"
        @begin() if @delay
        @options.transitionEnd and @options.transitionEnd.call(event, @index, @slides[@index])
        clearInterval @timer
        return
      @element.style.left = (((to - from) * (Math.floor((timeElap / speed) * 100) / 100)) + from) + "px"
    , 4)
    return

  begin: ->
    @interval = setTimeout((() => @next()), @delay)
    return

  stop: ->
    @delay = 0
    clearTimeout @interval
    return

  handleTransition: (event) ->
    if (parseInt(event.target.getAttribute('data-index'), 10) == @index)
      if @delay
        requestAnimationFrame () => @begin()
      @options.transitionEnd && @options.transitionEnd.call(event, @index, @slides[@index])
    return

  render: ->
    if @interactive
      @translate(@index-1, @lastDelta + @slidePos[@index-1], 0)
      @translate(@index, @lastDelta + @slidePos[@index], 0)
      @translate(@index+1, @lastDelta + @slidePos[@index+1], 0)
  
  handleMouse: (event) ->
    unless @interactive
      if event.type == "click"
        if @clickAction == "next" then @next()
        if @clickAction == "prev" then @prev()
      else if event.type == "mouseout"
        bounds = @container.getBoundingClientRect()
        if event.clientY <= bounds.top ||
           event.clientY >= (bounds.height + bounds.top) ||
           event.clientX <= bounds.left ||
           event.clientX >= (bounds.width + bounds.left)

          @container.removeAttribute "data-click"
          @clickAction = "none"
      else if event.offsetX > @width*0.5
        if @clickAction == "next" then return
        @container.setAttribute "data-click", "next"
        @clickAction = "next"
      else
        if @clickAction == "prev" then return
        @container.setAttribute "data-click", "prev"
        @clickAction = "prev"
    else
      if @clickAction == "none" then return
      @container.removeAttribute "data-click"
      @clickAction = "none"
    return

  handleTouch: (event) ->
    event.stopPropagation()
    event.stopImmediatePropagation()
    deltaX = event.gesture.deltaX
    clearTimeout @interval
    
    switch event.type
      when "touch"
        @interactive = true
        @swiped = false
      when "dragright", "dragleft"
        event.gesture.preventDefault()
        # determine resistance level
        deltaX = deltaX / (Math.abs(deltaX) / @width + 1) if not @index and deltaX > 0 or @index is @slides.length - 1 and deltaX < 0
        @lastDelta = deltaX
        requestAnimationFrame () => @render()
      when "swiperight", "swipeleft"
        event.gesture.preventDefault()
        @interactive = false
        @swiped = false
      when "release"
        @interactive = false
        isValidSlide = Math.abs(deltaX) > @width*0.5 || @swiped
        isPastBounds = not @index &&
                       deltaX > 0 ||
                       @index == @slides.length - 1 &&
                       deltaX < 0

        if isValidSlide && not isPastBounds
          if event.gesture.direction == "left"
            @move @index-1, -@width, 0
            @move @index, @slidePos[@index]-@width, @speed
            @move @index+1, @slidePos[@index+1]-@width, @speed
            @index += 1
          else
            @move @index+1, @width, 0
            @move @index, @slidePos[@index]+@width, @speed
            @move @index-1, @slidePos[@index-1]+@width, @speed
            @index += -1
        else
          @move @index-1, -@width, @speed
          @move @index, 0, @speed
          @move @index+1, @width, @speed
    return
