(exports ? this).Swipe = (container, options) ->
  # quit if no root element
  unless container then return

  # check browser capabilities
  browser =
    addEventListener: !!window.addEventListener
    touch: Modernizr.touch
    transitions: Modernizr.csstransitions


  # utilities
  noop = () ->
  
  offloadFn = (fn) ->           # offload a functions execution
    setTimeout(fn || noop, 0)
 
  # options and initial default values
  options = options || {}
  element = container.children[0]
  index = parseInt(options.startSlide, 10) || 0
  speed = options.speed || 300
  
  # application variables
  slides = null
  slidePos = null
  width = null
  console.log "element"
  
  setup = () ->
    # cache slides
    slides = element.children
    # create an array to store current positions of each slide
    slidePos = new Array slides.length
    
    # determine width of each slide
    width = container.getBoundingClientRect().width || container.offsetWidth

    element.style.width = (slides.length * width) + 'px'
    
    # stack slide elements
    pos = slides.length
    while pos--
      slide = slides[pos]
      slide.style.width = width + 'px'
      slide.setAttribute 'data-index', pos
      if browser.transitions
        slide.style.left = (pos * -width) + 'px'
        move pos, (if index > pos then -width else ((if index < pos then width else 0))), 0
    
    unless browser.transitions
      element.style.left = (index * -width) + 'px'

    container.style.visibility = 'visible'
    return #setup

  translate = (_index, _dist, _speed) ->
    slide = slides[_index]
    style = slide && slide.style
    unless style then return

    style.webkitTransitionDuration =
    style.MozTransitionDuration =
    style.msTransitionDuration =
    style.OTransitionDuration =
    style.transitionDuration = _speed + 'ms'

    style.webkitTransform = "translate(#{_dist}px,0) translateZ(0)"
    style.msTransform =
    style.MozTransform =
    style.OTransform = "translateX(#{_dist}px)"
    return #translate
  

  move = (_index, _dist, _speed) ->
    
    translate(_index, _dist, _speed)
    slidePos[_index] = _dist

  prev = () ->
    if index
      slide index - 1
    else if options.continuous
      slide slides.length - 1
    return

  next = () ->
    if index < slides.length - 1
      slide index + 1
    else if options.continuous
      slide 0

  slide = (_to, _slide) ->
    # do nothing if already on requested slide
    return if index is _to
    if browser.transitions
      diff = Math.abs(index - _to) - 1
      direction = Math.abs(index - _to) / (index - _to) # 1:right -1:left
      move ((if _to > index then _to else index)) - diff - 1, width * direction, 0  while diff--
      move index, width * direction, _speed or speed
      move _to, 0, _speed or speed
    else
      animate index * -width, _to * -width, _speed or speed
    index = _to
    offloadFn options.callback and options.callback(index, slides[index])
    return #slide 

  animate = (_from, _to, _speed) ->
    # if not an animation, just reposition
    unless _speed
      element.style.left = _to + "px"
      return
    start = +new Date
    timer = setInterval(->
      timeElap = +new Date - start
      if timeElap > _speed
        element.style.left = _to + "px"
        begin() if delay
        options.transitionEnd and options.transitionEnd.call(event, index, slides[index])
        clearInterval timer
        return
      element.style.left = (((_to - _from) * (Math.floor((timeElap / _speed) * 100) / 100)) + _from) + "px"
    , 4)

  # setup auto slideshow
  delay = options.auto || 0
  interval = null

  begin = () ->
    interval = setTimeout(next, delay)
    return

  stop = () ->
    delay = 0
    clearTimout interval
    return

  # setup initial vars
  touch = Hammer container
  touch.on "touch dragleft swipeleft dragright swiperight release", (event) -> handleEvent(event)
  isSwipe = false

  handleEvent = (event) ->
    # prevent page scroll
    event.stopPropagation()
    event.stopImmediatePropagation()
    deltaX = event.gesture.deltaX
    switch event.type
      when "touch"
        isSwipe = false
      when "dragright", "dragleft"
        event.gesture.preventDefault()
        # determine resistance level
        deltaX = deltaX / (Math.abs(deltaX) / width + 1) if not index and deltaX > 0 or index is slides.length - 1 and deltaX < 0
        translate(index-1, deltaX + slidePos[index-1], 0)
        translate(index, deltaX + slidePos[index], 0)
        translate(index+1, deltaX + slidePos[index+1], 0)

      when "swiperight", "swipeleft"
        event.gesture.preventDefault()
        isSwipe = true
      when "release"
        isValidSlide = Math.abs(deltaX) > width*0.5 || isSwipe
        isPastBounds = not index &&
                       deltaX > 0 ||
                       index == slides.length - 1 &&
                       deltaX < 0

        if isValidSlide && not isPastBounds
          if event.gesture.direction == "left"
            move index-1, -width, 0
            move index, slidePos[index]-width, speed
            move index+1, slidePos[index+1]-width, speed
            index += 1
          else
            move index+1, width, 0
            move index, slidePos[index]+width, speed
            move index-1, slidePos[index-1]+width, speed
            index += -1
        else
          move index-1, -width, speed
          move index, 0, speed
          move index+1, width, speed
    return #handleEvent 
  
  if browser.addEventListener
    window.addEventListener "resize", () ->
      offloadFn(setup.call())
  else
    window.onresize = () ->
      setup()
  
  # trigger setup
  setup()
