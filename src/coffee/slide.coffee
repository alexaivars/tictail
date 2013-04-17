

$(document).ready ->
  $(".product_slide_figure img").on "dragstart", (event) ->
    event.preventDefault()
    return false
    
  ref = $(".product_slide")
  if ref.length
    for elm in ref
      if $(elm).find(".product_slide_figure").length > 1
        elm.swipe = new Swipe elm,
          continuous: true
          disableScroll: false
          stopPropagation: false
          mouse: true
          auto: 0
        
