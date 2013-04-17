$(document).ready ->
  ref = $(".variations_select_label")
  if ref.length
    for elm in ref
      instance = new SelectLable(elm)

class SelectLable
  
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
    @changed()
    return

  changed: () ->
    try
      $elm = $(@select[0].options[@select[0].selectedIndex])
      @label.html($elm[0].innerHTML)
    catch e
      console.log e

