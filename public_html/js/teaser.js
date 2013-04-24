(function() {
  var Handler, Product, ProductDetail, ProductTeaser, app, getNextRow, inView, layoutSlide, loadSlide, removeToInsertLater, slideImage, _ref;

  if ((_ref = window.console) == null) {
    window.console = {
      log: function() {}
    };
  }

  getNextRow = function(element) {
    var nextSibling;
    nextSibling = element.nextSibling;
    while (nextSibling && nextSibling.nodeType !== 1) {
      nextSibling = nextSibling.nextSibling;
    }
    if (!nextSibling) {
      return false;
    } else if (nextSibling.offsetTop === element.offsetTop) {
      return getNextRow(nextSibling);
    } else {
      return nextSibling;
    }
  };

  inView = function(elm) {
    var height, rect;
    rect = elm.parentNode.getBoundingClientRect();
    height = window.innerHeight || document.documentElement.clientHeight;
    return rect.top >= 0 && rect.top <= height || rect.bottom >= 0 && rect.bottom <= height;
  };

  removeToInsertLater = function(element) {
    var nextSibling, parentNode;
    parentNode = element.parentNode;
    nextSibling = element.nextSibling;
    parentNode.removeChild(element);
    return function() {
      if (nextSibling) {
        return parentNode.insertBefore(element, nextSibling);
      } else {
        return parentNode.appendChild(element);
      }
    };
  };

  app = null;

  $(document).ready(function() {
    var element, handler, ref, _i, _len;
    handler = null;
    ref = $(".product");
    if (ref.length) {
      for (_i = 0, _len = ref.length; _i < _len; _i++) {
        element = ref[_i];
        if (handler == null) {
          handler = new Handler();
        }
        handler.add(new Product(element));
      }
      handler.draw();
    }
    app = $.sammy(".page_content", function() {
      this.get("#/", function(context) {});
      return this.get("#/product/:name", function(context) {
        return handler.show("/product/" + this.params["name"]);
      });
    });
    return app.run('#/');
  });

  Handler = (function() {

    function Handler() {
      var _this = this;
      this.container = $(".product_list")[0];
      this.products = [];
      this.draw_pending = false;
      $(window).on("resize", function() {
        return _this.redraw();
      });
      this;
    }

    Handler.prototype.add = function(product) {
      this.products.push(product);
      return this;
    };

    Handler.prototype.show = function(url) {
      var product, _i, _len, _ref1;
      _ref1 = this.products;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        product = _ref1[_i];
        if (product.url === url) {
          product.toggle();
        }
      }
      return this;
    };

    Handler.prototype.redraw = function() {
      var _this = this;
      if (this.draw_pending) {
        return;
      }
      this.draw_pending = true;
      return requestAnimationFrame(function() {
        return _this.draw();
      });
    };

    Handler.prototype.draw = function() {
      var height, max, product, _i, _j, _k, _len, _len1, _len2, _ref1, _ref2, _ref3;
      max = 0;
      _ref1 = this.products;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        product = _ref1[_i];
        product.reset();
      }
      _ref2 = this.products;
      for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
        product = _ref2[_j];
        height = product.height();
        if (height > max) {
          max = height;
        }
      }
      _ref3 = this.products;
      for (_k = 0, _len2 = _ref3.length; _k < _len2; _k++) {
        product = _ref3[_k];
        product.resize(max);
      }
      this.draw_pending = false;
    };

    return Handler;

  })();

  Product = (function() {

    function Product(element) {
      var _this = this;
      this.element = element instanceof jQuery ? element : $(element);
      this.teaser = new ProductTeaser(this.element.find(".product_teaser").first());
      this.detail = new ProductDetail(this.element.find(".product_detail")[0], this.element[0]);
      this.url = this.element.data("url");
      this.element.on("click", function(event) {
        event.preventDefault();
        event.stopPropagation();
        event.stopImmediatePropagation();
        return false;
      });
      Hammer(this.element[0]).on("tap doubletap", function(event) {
        return _this.selected(event);
      });
      this;
    }

    Product.prototype.selected = function(event) {
      app.setLocation("#" + this.url);
      event.preventDefault();
    };

    Product.prototype.toggle = function(event) {
      if (event) {
        event.preventDefault();
      }
      this.detail.moveNode();
      this.teaser.select();
      this.detail.show(0);
      return false;
    };

    Product.prototype.reset = function() {
      this.teaser.reset();
      return this;
    };

    Product.prototype.height = function() {
      return this.teaser.calc().height();
    };

    Product.prototype.resize = function(val) {
      return this.teaser.height(val);
    };

    return Product;

  })();

  /*
  #load = (elm, express) ->
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
  */


  $(window).on("resize", function() {
    var elm, height, obj, ref, width, _i, _len, _results;
    ref = $(".product_detail.selected");
    if (ref.length) {
      _results = [];
      for (_i = 0, _len = ref.length; _i < _len; _i++) {
        elm = ref[_i];
        obj = $(elm);
        width = $(".product_list").width();
        height = Math.round(width * (2 / 3));
        obj.find(".product_slide").first().width(width);
        _results.push(obj.find(".product_slide").first().height(height));
      }
      return _results;
    }
  });

  slideImage = [];

  layoutSlide = function() {
    var img, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = slideImage.length; _i < _len; _i++) {
      img = slideImage[_i];
      _results.push(cosoleole.log(img.height()));
    }
    return _results;
  };

  loadSlide = function(elm) {
    var src;
    src = elm.getAttribute("data-src");
    if (src != null) {
      return elm.src = src;
    }
  };

  ProductDetail = (function() {

    function ProductDetail(element, container) {
      this.element = element;
      this.container = container;
      return;
    }

    ProductDetail.prototype.moveNode = function() {
      var nextSibling, parent;
      this.element.parentNode.removeChild(this.element);
      parent = this.container.parentNode;
      nextSibling = getNextRow(this.container);
      parent.insertBefore(this.element, nextSibling);
    };

    ProductDetail.prototype.show = function(offset) {
      var height, next, obj, slide, slides, swipe, width, _i, _len;
      obj = $(this.element);
      width = $(".product_list").width();
      height = Math.round(width * (2 / 3));
      obj.find(".product_slide").first().width(width);
      obj.find(".product_slide").first().height(height);
      swipe = obj.find(".product_slide").first()[0].swipe;
      next = obj.next();
      while (next.length && next.hasClass("product_detail")) {
        next.toggleClass("selected", false);
        next = next.next();
      }
      obj.toggleClass("selected", true);
      slides = obj.find(".product_slide_figure img");
      if (swipe != null) {
        swipe.setup();
      }
      for (_i = 0, _len = slides.length; _i < _len; _i++) {
        slide = slides[_i];
        loadSlide(slide);
      }
      TweenLite.to(window, 0.25, {
        scrollTo: {
          y: obj.offset().top - offset,
          x: $(window).scrollLeft()
        },
        ease: Power2.easeIn
      });
    };

    return ProductDetail;

  })();

  ProductTeaser = (function() {

    function ProductTeaser(element) {
      this.element = element instanceof jQuery ? element : $(element);
      this.hover = this.element.find(".product_teaser_hover .wrapper").first();
      return;
    }

    ProductTeaser.prototype.reset = function() {
      this.element.removeAttr("style");
      this.hover.removeAttr("style");
      return this;
    };

    ProductTeaser.prototype.height = function(val) {
      var top;
      if (!val) {
        return this.heightElm;
      }
      this.element.height(val);
      this.element.css({
        position: "relative"
      });
      top = Math.round((val - this.heightHover) * 0.5);
      this.hover.css({
        position: "absolute",
        top: "" + top + "px"
      });
      return this;
    };

    ProductTeaser.prototype.calc = function() {
      this.heightElm = this.element.height();
      this.heightHover = this.hover.height();
      return this;
    };

    ProductTeaser.prototype.select = function(toggle) {
      if (toggle == null) {
        toggle = true;
      }
      $(".product_teaser").toggleClass("selected", false);
      this.element.toggleClass("selected", toggle);
      return this;
    };

    return ProductTeaser;

  })();

  enquire.register("screen and (min-width: 300px) and (max-width: 500px)", {
    match: function() {
      return console.log("match 1");
    },
    unmatch: function() {
      return console.log("unmatch");
    },
    setup: function() {
      return console.log("setup");
    },
    deferSetup: true
  }).register("screen and (min-width: 500px) and (max-width: 800px)", {
    match: function() {
      return console.log("match 2");
    },
    unmatch: function() {
      return console.log("unmatch");
    },
    setup: function() {
      return console.log("setup");
    },
    deferSetup: true
  }).register("screen and (min-width: 800px)", {
    match: function() {
      return console.log("match 3");
    },
    unmatch: function() {
      return console.log("unmatch");
    },
    setup: function() {
      return console.log("setup");
    },
    deferSetup: true
  });

}).call(this);
