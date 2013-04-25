(exports ? this).krmg ?= {}
class krmg.SlideMenu
  constructor: (@container) ->
    @touch = Hammer @container
    @touch.on "touch dragleft dragright swipeleft swiperight release", (event) => @touchHandler(event)
    @navigation =  @container.find(".page_navigation").first()
    @width = 200
    @left = 0
    @setOffset(@left)
    Hammer($("[data-action=menu-toggle]").first()).on "tap", (event) => @actionHandler(event)
    $(window).on "resize", () => @resize()
    @resize()
    return

  actionHandler: (event) ->
    event.preventDefault()
    event.gesture.preventDefault()
    TweenLite.to @, 0.25,
      left: ( if @left > 0 then 0 else @width )
      onUpdate: () =>
        @setOffset @left

  touchHandler: (event) ->
    # disable browser scrolling
    event.preventDefault()
    switch event.type
      when "touch"
        @delta = @dragX
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

  resize: () ->
    @navigation.css
      minHeight: Math.max( @container.height(), $(window).height() )
    @

  setOffset:  (px) ->
    @dragX = px
    @left = px
    if Modernizr.csstransforms3d
      @container.css "transform", "translate3d(#{px}px, 0, 0) scale3d(1,1,1)"
    else if Modernizr.csstransforms
      @container.css "transform", "translate(#{px}px, 0)"
    else
      @container.css "left", "#{px - @width}px"

