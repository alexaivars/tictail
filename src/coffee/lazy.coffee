(exports ? this).krmg ?= {}

"use strict"

DATA_NAME = "data-src"
lazy_list = []

inView = (elm, height) ->
  offsetParent = elm.offsetParent
  rect = elm.parentNode.getBoundingClientRect()
  
  if rect.top == 0
    if offsetParent
      rect = offsetParent.getBoundingClientRect()
    else
      return false
  else
    return rect.top >= 0 and rect.top <= height or rect.bottom >= 0 and rect.bottom <= height
  
krmg.LazyImage =
  init: ->
    node = document.getElementsByTagName "img"
    for img in node
      lazy_list.push img if img.getAttribute(DATA_NAME)?
    @
  load: ->
    height = window.innerHeight or document.documentElement.clientHeight
    update = []
    for img in lazy_list
      update.push(img) if inView(img, height)
    for img in update
      @get(img)
    @
  get: (elm, notween) ->
    # img = new Image()
    src = elm.getAttribute(DATA_NAME)
    unless elm.src == src
      elm.src = src
    ###
    img.onload = ->
      elm.getAttribute(DATA_NAME)
      lazy_list.splice(lazy_list.indexOf(elm), 1) if Array::indexOf
      if elm.parentNode?
        elm.parentNode.replaceChild img, elm
      else
        elm.className = ""
        elm.removeAttribute(DATA_NAME)
        elm.src = src
      unless notween
        try
          TweenLite.from elm, 0.25,
            opacity : 0
        catch e
          console.log "missing TweenLite"
      ###
    # img.src = src
    @

