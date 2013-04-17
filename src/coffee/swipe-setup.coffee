class (exports ? this).SwipeManager
	
	constructor: (@container) ->
		@container = $(@container)
		@images = @container.find("img")
		@prime = @images.first()
		@slides = @container.children().first().children()
		unless @prime.width()
			@prime.one "load", () => @init()
		else
			@init()
		return
	
	init: ->
		@width = @prime.width()
		@height = @prime.height()

		@prime.css(
			display: "block"
		)
		
		@style =
			display: "block"
			position: "relative"
			overflow: "hidden"
			width: "#{@width}px"
			height: "#{@height}px"
			background: "blue"
		
		for elm in @slides
			elm._jq = $(elm)
			elm._img = elm._jq.find("img").first()
			if elm._img.width() == 0
				elm._img[0]._pointer = elm
				elm._img.one "load", (event) =>
					obj = event.target._pointer
					obj._width = obj._img.width()
					obj._height = obj._img.height()
					event.target._pointer = undefined
					console.log "center"
					@center()
			elm._width = elm._img.width()
			elm._height = elm._img.height()

		@center()
		return

	center: ->

		for elm in @slides
			elm._jq.css @style
			elm._img.css(
				marginTop: "#{Math.round((@height - elm._height) * 0.5)}px"
				marginLeft: "#{Math.round((@width - elm._width) * 0.5)}px"
			)
		return

	
