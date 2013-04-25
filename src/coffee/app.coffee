scrolling = false
resizing = false
cat = "index"

setup = () ->
  krmg.ProductList.flush().load().index()
  krmg.LazyImage.init()
  krmg.LazyImage.load()
 
  # todo move this to swipe component 
  $(".product_slide_figure img").on "dragstart", (event) ->
    event.preventDefault()
    return false
  
  ref = $(".variations_select_label")
  if ref.length
    for elm in ref
      instance = new krmg.SelectLable(elm)
  
  ref = $(".html_content")
  if ref.length
    for element in ref
      insert = krmg.ELEMENT.insertLater element
      krmg.ELEMENT.wash element
      element.className = element.className.replace(/html_content\s*/,"")
      insert()

$(document).ready ->
  
  setup()
  menu = new krmg.SlideMenu $(".page_body").first()

  PAGE_SELECTOR = ".page_column"
  $.sammy PAGE_SELECTOR, () ->
    @get "/", (context) ->
      unless cat == "index"
        context.load("/")
        .then (html) ->
          krmg.HTML.read(html, PAGE_SELECTOR)
          setup()
          return
      return
    
    @get /products\/(.*)/, (context) ->
      console.log context.params
      category = context.params["splat"][0]
      cat = category
      context.load("products/#{category}")
      .then (html) ->
        krmg.HTML.read(html, PAGE_SELECTOR)
        setup()
        return

    @get /product\/(.*)/, (context) ->
      name = context.params["splat"][0]
      target = $(".page_column a[href$='product/#{name}']")
      $(".page_column .selected").removeClass "selected"
      target.addClass "selected"
      krmg.ProductList.show @path
      return
    
    @get /page\/(.*)/, (context) ->
      name = context.params["splat"][0]
      cat = name
      console.log name
      context.load("page/#{name}")
      .then (html) ->
        krmg.ProductList.flush()
        krmg.HTML.read(html, PAGE_SELECTOR)
        clean()
      return

    @bind "event-context-after", (event) ->
      target = $(".navigation a[href$='#{@path.replace /^\/\#|^\//, ""}']")
      $(".navigation .selected").removeClass "selected" if target.length
      target.addClass "selected"
      $(".navigation ul").has(".selected").addClass "selected"
      return
  .run()

$(window).on "scroll", () ->
  unless scrolling
    scrolling = true
    window.requestAnimationFrame () ->
      krmg.LazyImage.load()
      scrolling = false
      
$(window).on "resize", () ->
  unless resizing
    resizing = true
    window.requestAnimationFrame () ->
      krmg.ProductList.index()
      krmg.LazyImage.load()
      resizing = false

