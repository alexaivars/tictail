
"use strict"
# polyfil
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
    
    # setup auto slideshow
    @delay = options.auto || 0
    
    @interval = null
  
    # setup initial vars
    @touch = Hammer @container
    @touch.on "touch dragleft swipeleft dragright swiperight release", (event) => @handleEvent(event)
    @isSwipe = false
    @onresize = () =>
      offloadFn(@setup.call(@))
 
    if BROWSER.transitions
      fn = ((event) => @handleTransition(event))
      @element.addEventListener 'webkitTransitionEnd', fn, false
      @element.addEventListener 'msTransitionEnd', fn, false
      @element.addEventListener 'oTransitionEnd', fn, false
      @element.addEventListener 'otransitionend', fn, false
      @element.addEventListener 'transitionend', fn, false
    if BROWSER.addEventListener
      window.addEventListener "resize", @onresize
    else
      window.onresize = () =>
        @onresize()

    # setup
    @setup()
    
    # start auto slideshow if applicable
    @begin() if @delay
    
    #setup our exposed public api
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
    @width = @container.getBoundingClientRect().width || @container.offsetWidth

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
      @element.style.left = (index * -width) + 'px'
    
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

    # style.webkitTransform = "translate3d(#{dist}px,0) translateZ(0)"
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
    if BROWSER.transitions
      diff = Math.abs(@index - to) - 1
      direction = Math.abs(@index - to) / (@index - to) # 1:right -1:left
      @move ((if to > @index then to else @index)) - diff - 1, @width * direction, 0  while diff--
      @move @index, @width * direction, speed or @speed
      @move to, 0, speed or @speed
    else
      @animate @index * -@width, to * -@width, speed or @speed
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
    fn = () => @next()
    @interval = setTimeout(fn, @delay)
    return

  stop: ->
    @delay = 0
    clearTimeout @interval
    return

  handleTransition: (event) ->
    if (parseInt(event.target.getAttribute('data-index'), 10) == @index)
      fn = () => @begin() if @delay
      offloadFn(fn)
    return

  render: ->
    if(@mouseIsDown)
      @translate(@index-1, @lastDelta + @slidePos[@index-1], 0)
      @translate(@index, @lastDelta + @slidePos[@index], 0)
      @translate(@index+1, @lastDelta + @slidePos[@index+1], 0)
    
  handleEvent: (event) ->
    # prevent page scroll
    event.stopPropagation()
    event.stopImmediatePropagation()
    deltaX = event.gesture.deltaX
    
    switch event.type
      when "touch"
        clearTimeout @interval
        @mouseIsDown = true
        @isSwipe = false
      when "dragright", "dragleft"
        event.gesture.preventDefault()
        # determine resistance level
        deltaX = deltaX / (Math.abs(deltaX) / @width + 1) if not @index and deltaX > 0 or @index is @slides.length - 1 and deltaX < 0
        @lastDelta = deltaX
        requestAnimationFrame () => @render()


      when "swiperight", "swipeleft"
        event.gesture.preventDefault()
        @mouseIsDown = false
        @isSwipe = true
      when "release"
        @mouseIsDown = false
        isValidSlide = Math.abs(deltaX) > @width*0.5 || @isSwipe
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
