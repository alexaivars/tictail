(exports ? this).krmg ?= {}
class krmg.SlideMenu
  constructor: (@container) ->
   
    @menu = $('.page_menu').first()
    @tt   = $('#tt_colophon').first()

    @touch = Hammer @container
    @touch.on "touch dragleft dragright swipeleft swiperight release", (event) => @touchHandler(event)
    @navigation =  @container.find(".page_navigation").first()
    @width = 256
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
      minHeight: "auto"

    if @container.height() < $(window).height()
      @navigation.css
        minHeight: $(window).height()
    @

  setOffset:  (px) ->
    @dragX = px
    @left = px
    if Modernizr.csstransforms3d
      @container.css "transform", "translate3d(#{px}px, 0, 0) scale3d(1,1,1)"
      @menu.css "transform", "translate3d(#{px}px, 0, 0) scale3d(1,1,1)"
      @tt.css "transform", "translate3d(#{px}px, 0, 0) scale3d(1,1,1)"
      @tt.css "transform", (if (px is 0) then "" else "translate3d(#{px}px, 0)")
    else if Modernizr.csstransforms
      @container.css "transform", "translate(#{px}px, 0)"
      @menu.css "transform", "translate(#{px}px, 0)"
      @tt.css "transform", (if (px is 0) then "" else "translate(#{px}px, 0)")
    else
      @container.css "left", "#{px - @width}px"
      @menu.css "left", "#{px - @width + @width}px"
      @tt.css "left", (if (px is 0) then "" else "#{px - width}px")

  close: () ->
    TweenLite.to @, 0.25,
      left: 0
      onUpdate: () =>
        @setOffset @left
