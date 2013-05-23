scrolling = false
resizing = false
menu = null
cat = "index"
single = null

setup = () ->
  ref = $(".variations_select_label")
  if ref.length
    for elm in ref
      instance = new krmg.SelectLable(elm)
  
  krmg.ProductList.flush().load()

  krmg.ProductList.index()
  krmg.LazyImage.init()
  krmg.LazyImage.load()
 
  # todo move this to swipe component 
  $(".product_slide_figure img").on "dragstart", (event) ->
    event.preventDefault()
    return false
 
  ref = $(".product_single")
  if ref.length
    for elm in ref
      single = new krmg.Product $(elm)

  ref = $(".html_content")
  if ref.length
    for element in ref
      insert = krmg.ELEMENT.insertLater element
      krmg.ELEMENT.wash element
      element.className = element.className.replace(/html_content\s*/,"")
      insert()

$(document).ready ->
  menu_targets   = [document.getElementById("page") ]
  tictail_menu   = $('#tt_colophon')
  menu_options   = {}
  if Modernizr.touch
    menu_options   =
      onToggle: () ->
        $("#menu_blocker").show()
      onOpened: () ->
        setTimeout () ->
          $("#menu_blocker").hide()
        , 400
      onClosed: () ->
        setTimeout () ->
          $("#menu_blocker").hide()
        , 400

  if tictail_menu.length
    menu_targets.push(tictail_menu.first()[0])
  
  menu = new krmg.SlideMenu(document.getElementById("navigation"), menu_targets, menu_options)
 
  Hammer($(".navigation_toggle")).on "tap", () ->
    menu.toggle()
  setup()

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
      category = context.params["splat"][0]
      cat = category
      context.load("/products/#{category}")
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
      context.load("/page/#{name}")
      .then (html) ->
        krmg.ProductList.flush()
        krmg.HTML.read(html, PAGE_SELECTOR)
        setup()
      
      return

    @bind "event-context-after", (event) ->
      target = $("a[href$='#{@path.replace /^\/\#|^\//, ""}']")
      $("a.selected").removeClass "selected"
      if target.length
        target.addClass "selected"
      else
        $("a[href='/']").addClass "selected"
      menu.close()
      return
  .run()





onscroll = () ->
  unless scrolling
    scrolling = true
    window.requestAnimationFrame () ->
      krmg.LazyImage.load()
      scrolling = false

if Modernizr.touch
  document.addEventListener "touchmove", onscroll
else
  $(window).on "scroll", onscroll


$(window).on "resize", () ->
  unless resizing
    resizing = true
    window.requestAnimationFrame () ->
      krmg.ProductList.index()
      krmg.LazyImage.load()
      if single
        single.size("load")
        single.size("write")
        single.swipe.setup()
      resizing = false

