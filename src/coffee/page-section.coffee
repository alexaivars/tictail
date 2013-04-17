$(document).ready ->
  getNext = (elm) ->
    next = elm.next()
    return elm unless next.length
    if next.position().top != elm.position().top
      return elm
    else
      return getNext next

 
  getPre = (elm) ->
    pre = elm.prev()
    return elm unless pre.length
    if pre.position().top != elm.position().top
      return elm
    else
      return getPre pre

  $(".box").on "click", (event) ->
    $(".box").removeClass("active")
    box = $(event.currentTarget)
    
    box.addClass("active")
    console.log box
    pre = getNext(box)
    obj = $("#box-view")
    obj.slideUp "fast", () ->
      
      $('html, body').animate({
        # scrollTop: box.offset().top
      }, "fast", () ->
        obj.insertAfter( pre )
        obj.slideDown "fast"
      )

  
  resizer = null


  ###
  ref = $(".swipe")
  console.log ref
  if ref.length
    for elm in ref
      new SwipeManager(elm)
  ###
