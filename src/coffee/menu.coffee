(exports ? this).krmg ?= {}
class krmg.SlideMenu
  constructor: (@container) ->
   
    @menu = $('.page_menu').first()
    @tt   = $('#tt_colophon').first()
    
    @content = [@menu, @container]
    if @tt.length
      @content.push @tt

      
    @touch = Hammer @container
    @touch.on "dragleft dragright swipeleft swiperight release dragup dragdown", (event) => @touchHandler(event)
    @navigation =  @container.find(".page_navigation").first()
    @width = 256
    @close()

    Hammer($("[data-action=menu-toggle]").first()).on "tap", (event) => @actionHandler(event)
    document.getElementById("tictail_search_box").disabled = true
    $(window).on "resize", () => @resize()

    @resize()
    return

  actionHandler: (event) ->
    event.stopPropagation()
    event.preventDefault()
    if @state == "open"
      @close()
    else
      @open()

  touchHandler: (event) ->
    # disable browser scrolling
    switch event.type
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
        if @state == "open"
          x = Math.max(0,Math.min(@width,@width + event.gesture.deltaX))
        else
          x = Math.max(0,Math.min(@width,event.gesture.deltaX))
        TweenLite.set @content,
          x: x
          overwrite: true
      when "swiperight"
        event.preventDefault()
        @open()
      when "swipeleft"
        event.preventDefault()
        @close()
      when "release"
        event.preventDefault()
        if @change
          if Math.abs(event.gesture.deltaX) > @width * 0.5
            if @state == "open"
              @close()
            else
              @open()
          else
            if @state == "open"
              @open()
            else
              @close()

        @ignore = false
        @change = false
    return

  resize: () ->
    @navigation.css
      minHeight: "auto"
    if @container.height() < $(window).height()
      @navigation.css
        minHeight: $(window).height()
    @
  open: (fn) ->
    TweenLite.to @content, 0.25,
      x: @width
      overwrite: true
      onComplete: () =>
        @state = "open"
        console.log "open"
        setTimeout () ->
          document.getElementById("tictail_search_box").disabled = false
        , 400
  
  close: (fn) ->
    console.log fn
    TweenLite.to @content, 0.25,
      x: 0
      overwrite: true
      onComplete: () =>
        @state = "closed"
        document.getElementById("tictail_search_box").disabled = true
