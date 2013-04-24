
/*
images = $("img.lazy").toArray()
pending = false

load = (elm, express) ->
  img = new Image()
  src = elm.getAttribute("data-src")
  img.onload = ->
    unless not elm.parent
      elm.parent.replaceChild img, elm
    else
      elm.src = src
    unless express
      TweenLite.from elm, 0.25,
        opacity : 0

  img.src = src

inView = (elm) ->
  rect = elm.parentNode.getBoundingClientRect()
  height = (window.innerHeight or document.documentElement.clientHeight)
  rect.top >= 0 and rect.top <= height or rect.bottom >= 0 and rect.bottom <= height

addEventListener = (event, fn) ->
  (if window.addEventListener then @addEventListener(event, fn, false) else (if (window.attachEvent) then @attachEvent("on" + event, fn) else this["on" + event] = fn))

processScroll = (express) ->
  unless pending or images.length then return
  queue = []
  pending = false
  for img in images
    queue.push img if inView img
	
  for img in queue
    images.splice images.indexOf(img), 1
    load img, express


processScroll()

addEventListener "resize", ->
  pending = true
  requestAnimationFrame () -> processScroll()

addEventListener "scroll", ->
  pending = true
  requestAnimationFrame () -> processScroll()
*/


(function() {



}).call(this);
