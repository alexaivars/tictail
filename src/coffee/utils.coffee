(exports ? this).krmg ?= {}

# Global regs 
krmg.RE =
  wash1  : /<(script|head|style|iframe|frame|noscript)[^\>]*>[\s\S]*?<\/.*?\1>/gi
  wash2  : /<(!doctype|head|html|body).*?>/gi
  wash3  : /<\/.*?(head|html|body)>/gi
  wash4  : /<!--[\s\S]*?-->/gi
  clean  : /^\/\#|^\/|\#|\/\#/

krmg.HTML =
  wash: (html) ->
    html = html.replace krmg.RE.wash1, ""
    html = html.replace krmg.RE.wash2, ""
    html = html.replace krmg.RE.wash3, ""
    html = html.replace krmg.RE.wash4, ""
    return html

  read: (html, target) ->
    html = @wash html
    doc = document
    if document.implementation? && document.implementation.createHTMLDocument?
      try
        doc = document.implementation.createHTMLDocument("")
      catch e
        doc = document

    container = doc.createElement('div')
    container.innerHTML = html

    $(target).first().html $(container).find(target).first().html()
    try
      TT.store.domReady()
    catch e
      console.log "Missing TT.store.domReady"

krmg.ELEMENT =
  wash: (element) ->
    element.removeAttribute("style")
    if element.children.length
      for child in element.children
        @wash child
    return element

  insertLater: (element) ->
    parentNode = element.parentNode
    nextSibling = element.nextSibling
    parentNode.removeChild element
    ->
      if nextSibling
        parentNode.insertBefore element, nextSibling
      else
        parentNode.appendChild element



