(function() {
  var cat, menu, resizing, scrolling, setup;

  scrolling = false;

  resizing = false;

  menu = null;

  cat = "index";

  setup = function() {
    var element, elm, insert, instance, ref, swipe, _i, _j, _k, _len, _len1, _len2, _results;
    krmg.ProductList.flush().load().index();
    krmg.LazyImage.init();
    krmg.LazyImage.load();
    menu.resize();
    $(".product_slide_figure img").on("dragstart", function(event) {
      event.preventDefault();
      return false;
    });
    ref = $(".product_single .product_slide");
    if (ref.length) {
      for (_i = 0, _len = ref.length; _i < _len; _i++) {
        elm = ref[_i];
        swipe = new krmg.Swipe(elm, {
          continuous: true,
          disableScroll: false,
          stopPropagation: false,
          mouse: true
        });
      }
    }
    ref = $(".variations_select_label");
    if (ref.length) {
      for (_j = 0, _len1 = ref.length; _j < _len1; _j++) {
        elm = ref[_j];
        instance = new krmg.SelectLable(elm);
      }
    }
    ref = $(".html_content");
    if (ref.length) {
      _results = [];
      for (_k = 0, _len2 = ref.length; _k < _len2; _k++) {
        element = ref[_k];
        insert = krmg.ELEMENT.insertLater(element);
        krmg.ELEMENT.wash(element);
        element.className = element.className.replace(/html_content\s*/, "");
        _results.push(insert());
      }
      return _results;
    }
  };

  $(document).ready(function() {
    var PAGE_SELECTOR;
    menu = new krmg.SlideMenu($(".page_body").first());
    setup();
    PAGE_SELECTOR = ".page_column";
    return $.sammy(PAGE_SELECTOR, function() {
      this.get("/", function(context) {
        if (cat !== "index") {
          context.load("/").then(function(html) {
            krmg.HTML.read(html, PAGE_SELECTOR);
            setup();
          });
        }
      });
      this.get(/products\/(.*)/, function(context) {
        var category;
        category = context.params["splat"][0];
        cat = category;
        return context.load("/products/" + category).then(function(html) {
          krmg.HTML.read(html, PAGE_SELECTOR);
          setup();
        });
      });
      this.get(/product\/(.*)/, function(context) {
        var name, target;
        name = context.params["splat"][0];
        target = $(".page_column a[href$='product/" + name + "']");
        $(".page_column .selected").removeClass("selected");
        target.addClass("selected");
        krmg.ProductList.show(this.path);
      });
      this.get(/page\/(.*)/, function(context) {
        var name;
        name = context.params["splat"][0];
        cat = name;
        context.load("/page/" + name).then(function(html) {
          krmg.ProductList.flush();
          krmg.HTML.read(html, PAGE_SELECTOR);
          return setup();
        });
      });
      return this.bind("event-context-after", function(event) {
        var target;
        target = $("a[href$='" + (this.path.replace(/^\/\#|^\//, "")) + "']");
        $("a.selected").removeClass("selected");
        if (target.length) {
          target.addClass("selected");
        } else {
          $("a[href='/']").addClass("selected");
        }
        menu.close();
      });
    }).run();
  });

  $(window).on("scroll", function() {
    if (!scrolling) {
      scrolling = true;
      return window.requestAnimationFrame(function() {
        krmg.LazyImage.load();
        return scrolling = false;
      });
    }
  });

  $(window).on("resize", function() {
    if (!resizing) {
      resizing = true;
      return window.requestAnimationFrame(function() {
        krmg.ProductList.index();
        krmg.LazyImage.load();
        return resizing = false;
      });
    }
  });

}).call(this);
