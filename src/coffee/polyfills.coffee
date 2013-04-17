"use strict"

# Add ECMA262-5 Array methods if not supported natively
# https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Array/indexOf
unless Array::indexOf
  Array::indexOf = (searchElement) -> #, fromIndex
    throw new TypeError()  unless this?
    t = Object(this)
    len = t.length >>> 0
    return -1  if len is 0
    n = 0
    if arguments.length > 1
      n = Number(arguments[1])
      unless n is n # shortcut for verifying if it's NaN
        n = 0
      else n = (n > 0 or -1) * Math.floor(Math.abs(n))  if n isnt 0 and n isnt Infinity and n isnt -Infinity
    return -1  if n >= len
    k = (if n >= 0 then n else Math.max(len - Math.abs(n), 0))
    while k < len
      return k  if k of t and t[k] is searchElement
      k++
    -1

# requestAnimationFrame and cancel polyfill
(->
  lastTime = 0
  vendors = ["ms", "moz", "webkit", "o"]
  x = 0

  while x < vendors.length and not window.requestAnimationFrame
    window.requestAnimationFrame = window[vendors[x] + "RequestAnimationFrame"]
    window.cancelAnimationFrame = window[vendors[x] + "CancelAnimationFrame"] or window[vendors[x] + "CancelRequestAnimationFrame"]
    ++x
  unless window.requestAnimationFrame
    window.requestAnimationFrame = (callback, element) ->
      currTime = new Date().getTime()
      timeToCall = Math.max(0, 16 - (currTime - lastTime))
      id = window.setTimeout(->
        callback currTime + timeToCall
      , timeToCall)
      lastTime = currTime + timeToCall
      id
  unless window.cancelAnimationFrame
    window.cancelAnimationFrame = (id) ->
      clearTimeout id
)()
