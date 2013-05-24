(function() {
  var cat, menu, onscroll, resizing, scrolling, setup, single;

  scrolling = false;

  resizing = false;

  menu = null;

  cat = "index";

  single = null;

  setup = function() {
    var element, elm, insert, instance, ref, _i, _j, _k, _len, _len1, _len2, _results;
    ref = $(".variations_select_label");
    if (ref.length) {
      for (_i = 0, _len = ref.length; _i < _len; _i++) {
        elm = ref[_i];
        instance = new krmg.SelectLable(elm);
      }
    }
    krmg.ProductList.flush().load();
    krmg.ProductList.index();
    krmg.LazyImage.init();
    krmg.LazyImage.load();
    $(".product_slide_figure img").on("dragstart", function(event) {
      event.preventDefault();
      return false;
    });
    ref = $(".product_single");
    if (ref.length) {
      for (_j = 0, _len1 = ref.length; _j < _len1; _j++) {
        elm = ref[_j];
        single = new krmg.Product($(elm));
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
    var PAGE_SELECTOR, app, menu_options, menu_targets, tictail_menu;
    menu_targets = [document.getElementById("page")];
    tictail_menu = $('#tt_colophon');
    menu_options = {};
    if (Modernizr.touch) {
      menu_options = {
        onToggle: function() {
          return $("#menu_blocker").show();
        },
        onOpened: function() {
          return setTimeout(function() {
            return $("#menu_blocker").hide();
          }, 400);
        },
        onClosed: function() {
          return setTimeout(function() {
            return $("#menu_blocker").hide();
          }, 400);
        }
      };
    }
    if (tictail_menu.length) {
      menu_targets.push(tictail_menu.first()[0]);
    }
    menu = new krmg.SlideMenu(document.getElementById("navigation"), menu_targets, menu_options);
    Hammer($(".navigation_toggle")).on("tap", function() {
      return menu.toggle();
    });
    setup();
    PAGE_SELECTOR = ".page_column";
    app = $.sammy(PAGE_SELECTOR, function() {
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
    });
    if (Modernizr.history) {
      return app.run();
    }
  });

  onscroll = function() {
    if (!scrolling) {
      scrolling = true;
      return window.requestAnimationFrame(function() {
        krmg.LazyImage.load();
        return scrolling = false;
      });
    }
  };

  if (Modernizr.touch) {
    document.addEventListener("touchmove", onscroll);
  } else {
    $(window).on("scroll", onscroll);
  }

  $(window).on("resize", function() {
    if (!resizing) {
      resizing = true;
      return window.requestAnimationFrame(function() {
        krmg.ProductList.index();
        krmg.LazyImage.load();
        if (single) {
          single.size("load");
          single.size("write");
          single.swipe.setup();
        }
        return resizing = false;
      });
    }
  });

}).call(this);
