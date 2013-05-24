(exports ? this).krmg ?= {}
class krmg.SelectLable
  
  prefix: ''

  constructor: (element) ->
    @label = (if (element instanceof jQuery) then element else $(element))
    @select = @label.prev()
    unless @select.hasClass("tictail_variations_select")
      @label = null
      @select = null
      return
    @setup()
    @

  setup: () ->

    @select.on 'change', (event) => @changed()
    @options = $("<div class='variations_option_container'>")
    @options.on "click", (event) =>
      @select[0].selectedIndex = event.target.getAttribute("data-index")
      @changed()
      @options.slideToggle("fast")
    html = ""
    for opt, index in @select[0].options
      html += "<div class='variations_option' data-index='#{index}'>#{opt.innerHTML}</div>"
    
    @options[0].innerHTML = html

    @label.after(@options)
    @label.on "click", (event) =>
      @options.slideToggle("fast")
    
    @changed()
    return

  changed: () ->
    try
      $elm = $(@select[0].options[@select[0].selectedIndex])
      @label.html($elm[0].innerHTML)
    catch e
      console.log e

