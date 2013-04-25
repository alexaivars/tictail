removeToInsertLater = (element) ->
  parentNode = element.parentNode
  nextSibling = element.nextSibling
  parentNode.removeChild element
  ->
    if nextSibling
      parentNode.insertBefore element, nextSibling
    else
      parentNode.appendChild element

wash = (element) ->
  element.removeAttribute("style")
  if element.children.length
    for child in element.children
      wash child
  return element
$(document).ready ->
  ref = $(".html_content")
  if ref.length
    for element in ref
      insert = removeToInsertLater element
      wash(element)
      element.className = element.className.replace(/html_content\s*/,"")
      insert()
  return
