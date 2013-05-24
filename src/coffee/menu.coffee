
(exports ? this).krmg ?= {}
class krmg.SlideMenu
  @IS_ACTIVE: "open"
  @IS_INACTIVE: "close"
  constructor: (@menu, @content , @options = {}) ->
    
    @animate = @content
    @animate.push @menu
 
      
    @touch = Hammer(window)
    @touch.on "dragstart dragleft dragright swipeleft swiperight release dragup dragdown", (event) => @touchHandler(event)

    @width = @menu.offsetWidth
    @close()
    return

  actionHandler: (event) ->
    event.stopPropagation()
    event.preventDefault()
    if @state == SlideMenu.IS_ACTIVE
      @close()
    else
      @open()

  touchHandler: (event) ->
    # Ignore touches if user i swiping a slide show, should probably make a more general solution.
    return if event.result && event.result instanceof krmg.Swipe
    # disable browser scrolling
    switch event.type
      when "dragstart"
        if event.target && event.target.className == "product_slide_figure"
          @ignore = true

      when "dragup", "dragdown"
        if @change
          event.preventDefault()
          event.gesture.preventDefault()
        else
          @ignore = true
          
      when "dragright", "dragleft"
        return if @ignore
        @change = true
        event.preventDefault()
        event.gesture.preventDefault()
        limit = 20

        if Math.abs(event.gesture.deltaX) > limit
          if @state == "open"
            x = Math.max(0,Math.min(@width,@width + event.gesture.deltaX - limit))
          else
            x = Math.max(0,Math.min(@width,event.gesture.deltaX - limit))
          TweenLite.set @content,
            x: x
            overwrite: true

      when "swiperight"
        return if @ignore
        event.preventDefault()
        @open()
      when "swipeleft"
        return if @ignore
        event.preventDefault()
        @close()
      when "release"
        event.preventDefault()
        if @change
          if @state == SlideMenu.IS_ACTIVE
            if Math.abs(event.gesture.deltaX) > @width * 0.5 && event.gesture.direction == Hammer.DIRECTION_LEFT
              @close()
            else
              @open()
          else
            if Math.abs(event.gesture.deltaX) > @width * 0.5 && event.gesture.direction == Hammer.DIRECTION_RIGHT
              @open()
            else
              @close()
        @ignore = false
        @change = false
    return false
  open: () ->
    TweenLite.to @animate, 0.25,
      x: @width
      overwrite: true
      onComplete: () =>
        @state = SlideMenu.IS_ACTIVE
        @options.onOpened.call() if @options.onOpened
    @
  close: (fn) ->
    TweenLite.to @animate, 0.25,
      x: 0
      clearProps: "x"
      overwrite: true
      onComplete: () =>
        @state = SlideMenu.IS_INACTIVE
        @options.onClosed.call() if @options.onClosed
        return
     @
  toggle: () ->
    @options.onToggle.call() if @options.onToggle
    if @state == SlideMenu.IS_ACTIVE
      @close()
    else
      @open()
    @

