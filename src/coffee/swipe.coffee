
(exports ? this).krmg ?= {}
class krmg.Swipe
  constructor: (@container, @options = {} ) ->
    @wrapper = @container.children[0]
    @index = 0
    @speed = 400
    @setup()
    #return our exposed public api and hide our "private" methods
    api =
      setup: =>
        @setup()
        @
      prev: =>
        @stop()
        @prev()
        @
      next: =>
        @stop()
        @next()
        @
      kill: =>
        @teardown()
        return
    api.__proto__ = @.__proto__
    return api
  stop: ->
    @

  prev: ->
    TweenLite.set @wrapper, {x: "-=#{@width}"}
    @index = @circle(@index - 1)
    @layout()
    @move()
    @

  next: ->
    TweenLite.set @wrapper, {x: "+=#{@width}"}
    @index = @circle(@index + 1)
    @layout()
    @move()
    @
  
  circle: (num) ->
    # a simple positive modulos
    return (@length + (num % @length)) % @length
  teardown: ->
    @touch.off() if @touch
    for node in  @slides
      node.removeAttribute("style")
    @wrapper.removeAttribute("style")
    @container.removeAttribute("style")
    @index = 0
    @slides = []
    return
  setup: ->
    @length = @wrapper.children.length
    point = 0
    
    for child, index in @wrapper.children
      child.setAttribute("data-index",index)
    
    if @length > 1
      while @length < 5
        node = @wrapper.children[point].cloneNode(true)
        point++
        @wrapper.appendChild(node)
        @length++

    @slides = []
    @direction = 0
    
    # cache children
    for slide in @wrapper.children
      @slides.push slide
    
    # cache size
    @bounds = @container.getBoundingClientRect()
    @width = @bounds.width
    @height = @bounds.height
    @wrapper.style.height = "#{@height}px"
    @wrapper.style.width = "#{@width}px"
    @wrapper.style.position = "absolute"
    
    # touch handler
    if not @touch && @length > 1
      @touch = Hammer @container
      @touch.on "tap swipeleft dragleft swiperight dragright touch release", (event) => @dragHandler(event)
      @touch.on "click mousemove", (event) =>
        y = event.pageY - @bounds.top
        x = event.pageX - @bounds.left
        if @direction != 1 && x > @width * 0.5
          @container.setAttribute("data-direction","next")
          @direction = 1
        else if @direction != -1 && x < @width * 0.5
          @container.setAttribute("data-direction","prev")
          @direction = -1
        if event.type == "click"
          @next() if @direction == 1
          @prev() if @direction == -1

      @touch.on "click", (event) ->
        event.preventDefault()
      
      @touch.on "dragstart", (event) =>
        event.preventDefault() if event.target.tagName.toLowerCase() == "img"

      if @options.mouse
        @touch.on "click mousemove", (event) =>
          y = event.pageY - @bounds.top
          x = event.pageX - @bounds.left
          if @direction != 1 && x > @width * 0.5
            @container.setAttribute("data-direction","next")
            @direction = 1
          else if @direction != -1 && x < @width * 0.5
            @container.setAttribute("data-direction","prev")
            @direction = -1
      
    for node in  @slides
      node.style.width = "#{@width}px"
      node.style.height = "#{@height}px"
    
    @layout()
    
    @
  layout: ->
    for node, pos in @slides
      # node.style.width = "#{@width}px"
      if pos == @index
        node.style.left = 0
        node.style.visibility = "visible"
      else if pos == @circle(@index + 1)
        node.style.left = "#{@width * 1}px"
        node.style.visibility = "visible"
      else if pos == @circle(@index + 2)
        node.style.left = "#{@width * 2}px"
        node.style.visibility = "visible"
      else if pos == @circle(@index - 1)
        node.style.left = "#{@width * -1}px"
        node.style.visibility = "visible"
      else if pos == @circle(@index - 2)
        node.style.left = "#{@width * -2}px"
        node.style.visibility = "visible"
      else
        node.style.visibility = "hidden"
        # @wrapper.removeChild(node)
    @
  dragHandler: (event) ->
    @offset = 0 unless @offset?
    dist = Math.min(@width,Math.max(-@width,event.gesture.deltaX))

    switch event.type
      when "tap"
        @options.onClick(event, @index, @slides[@index]) if @options.onClick
      when "touch"
        # event.gesture.preventDefault()
        if @t
          @offset = Math.round(@t.target._gsTransform.x)
          @t = null
        else
          @offset = 0
        TweenLite.killTweensOf @wrapper
      when "dragleft", "dragright"
        event.gesture.preventDefault()
        TweenLite.set @wrapper,
          x: dist
          overwrite: true
      when "swipeleft"
        event.gesture.preventDefault()
        @pendingTouch = "next"
      when "swiperight"
        event.gesture.preventDefault()
        @pendingTouch = "prev"

      when "release"
        # @speed  = 300 * Math.abs(dist / @width)
        if @pendingTouch == "prev" || dist > Math.min( 250, @width * 0.5)
          @prev()
        else if @pendingTouch == "next" || dist < Math.max(-250, @width * -0.5 )
          @next()
        else
          @move(true)
        @pendingTouch = null
    @
  
  move: (quiet) ->
    @t = TweenLite.to @wrapper, @speed / 1000,
      # ease: Power2.easeOut
      x: 0
      overwrite: true
      clearProps: "x"
      onComplete: () =>
        if @options.transitionEnd and not quiet
          requestAnimationFrame () =>
            @options.transitionEnd(this, @index, @slides[@index]) if @options.transitionEnd and not quiet
        @offset = 0
        @t = null

