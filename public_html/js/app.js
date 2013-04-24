(function() {
  var Product, ProductList, app, cat, clean, images, inView, init, list, loadLazy, processScroll, reClean, reWash1, reWash2, reWash3, reWash4, read, removeToInsertLater, resizing, scrolling, unstyle, wash, _ref;

  (function() {
    var lastTime, vendors, x;
    lastTime = 0;
    vendors = ["ms", "moz", "webkit", "o"];
    x = 0;
    while (x < vendors.length && !window.requestAnimationFrame) {
      window.requestAnimationFrame = window[vendors[x] + "RequestAnimationFrame"];
      window.cancelAnimationFrame = window[vendors[x] + "CancelAnimationFrame"] || window[vendors[x] + "CancelRequestAnimationFrame"];
      ++x;
    }
    if (!window.requestAnimationFrame) {
      window.requestAnimationFrame = function(callback, element) {
        var currTime, id, timeToCall;
        currTime = new Date().getTime();
        timeToCall = Math.max(0, 16 - (currTime - lastTime));
        id = window.setTimeout(function() {
          return callback(currTime + timeToCall);
        }, timeToCall);
        lastTime = currTime + timeToCall;
        return id;
      };
    }
    if (!window.cancelAnimationFrame) {
      return window.cancelAnimationFrame = function(id) {
        return clearTimeout(id);
      };
    }
  })();

  if ((_ref = window.console) == null) {
    window.console = {
      log: function() {}
    };
  }

  reWash1 = /<(script|head|style|iframe|frame|noscript)[^\>]*>[\s\S]*?<\/.*?\1>/gi;

  reWash2 = /<(!doctype|head|html|body).*?>/gi;

  reWash3 = /<\/.*?(head|html|body)>/gi;

  reWash4 = /<!--[\s\S]*?-->/gi;

  reClean = /^\/\#|^\/|\#|\/\#/;

  images = [];

  removeToInsertLater = function(element) {
    var nextSibling, parentNode;
    parentNode = element.parentNode;
    nextSibling = element.nextSibling;
    parentNode.removeChild(element);
    return function() {
      if (nextSibling) {
        return parentNode.insertBefore(element, nextSibling);
      } else {
        return parentNode.appendChild(elemenMissing(TT.store.domReadyt));
      }
    };
  };

  unstyle = function(element) {
    var child, _i, _len, _ref1;
    element.removeAttribute("style");
    if (element.children.length) {
      _ref1 = element.children;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        child = _ref1[_i];
        unstyle(child);
      }
    }
    return element;
  };

  wash = function(html) {
    html = html.replace(reWash1, "");
    html = html.replace(reWash2, "");
    html = html.replace(reWash3, "");
    html = html.replace(reWash4, "");
    return html;
  };

  read = function(html, target) {
    var container, doc;
    doc = document;
    if ((document.implementation != null) && (document.implementation.createHTMLDocument != null)) {
      try {
        doc = document.implementation.createHTMLDocument("");
      } catch (e) {
        doc = document;
      }
    }
    container = doc.createElement('div');
    container.innerHTML = html;
    $(target).first().html($(container).find(target).first().html());
    try {
      return TT.store.domReady();
    } catch (e) {
      return console.log("Missing TT.store.domReady");
    }
  };

  ProductList = (function() {

    function ProductList(container) {
      this.container = container;
      this.list = [];
      this.first = [];
      this;
    }

    ProductList.prototype.show = function(url) {
      var obj, offset, product, _i, _j, _len, _len1, _ref1, _ref2;
      url = url.replace(reClean, "");
      obj = null;
      _ref1 = this.list;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        product = _ref1[_i];
        if (product.url === url) {
          obj = product;
        }
      }
      _ref2 = this.list;
      for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
        product = _ref2[_j];
        if (product !== obj && product.row === obj.row) {
          product.select(false);
        }
      }
      obj.select();
      this.active = obj;
      this.insert_detail(obj, obj.row + 1);
      offset = 0;
      TweenLite.to(window, 0.25, {
        scrollTo: {
          y: obj.detail.offset().top - offset,
          x: $(window).scrollLeft()
        },
        ease: Power2.easeIn
      });
      return this;
    };

    ProductList.prototype.insert_detail = function(obj, row) {
      var detail, parent, target;
      target = null;
      detail = obj.detail[0];
      parent = obj.container.parent()[0];
      if (this.first[row]) {
        target = this.first[row].container[0];
      }
      try {
        parent.insertBefore(detail, target);
      } catch (e) {
        console.log(e);
      }
      return this;
    };

    ProductList.prototype.load = function() {
      var child, ref, _i, _len;
      ref = $(".product_list .product");
      if (ref.length) {
        for (_i = 0, _len = ref.length; _i < _len; _i++) {
          child = ref[_i];
          this.list.push(new Product($(child)));
        }
      }
      return this;
    };

    ProductList.prototype.index = function() {
      var obj, open, p, r, row, top, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _len5, _m, _n, _ref1, _ref2, _ref3, _ref4, _ref5;
      row = top = -1;
      open = [];
      while (this.first.length) {
        this.first.pop();
      }
      _ref1 = this.list;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        obj = _ref1[_i];
        if (obj.selected) {
          obj.select(false);
          open.push(obj);
        }
      }
      _ref2 = this.list;
      for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
        obj = _ref2[_j];
        obj.size("reset");
      }
      _ref3 = this.list;
      for (_k = 0, _len2 = _ref3.length; _k < _len2; _k++) {
        obj = _ref3[_k];
        obj.size("load");
      }
      _ref4 = this.list;
      for (_l = 0, _len3 = _ref4.length; _l < _len3; _l++) {
        obj = _ref4[_l];
        obj.size("write");
      }
      _ref5 = this.list;
      for (_m = 0, _len4 = _ref5.length; _m < _len4; _m++) {
        obj = _ref5[_m];
        if (obj.size().top > top) {
          row++;
          this.first[row] = obj;
        }
        obj.row = row;
        top = obj.size().top;
      }
      p = -1;
      if (this.active) {
        for (_n = 0, _len5 = open.length; _n < _len5; _n++) {
          obj = open[_n];
          r = obj.row + 1;
          if (obj === this.active || (obj.row !== this.active.row && r !== p)) {
            this.insert_detail(obj, r);
            obj.select(true);
            p = r;
          }
        }
      }
      return this;
    };

    ProductList.prototype.flush = function() {
      this.active = null;
      while (this.first.length) {
        this.first.pop();
      }
      while (this.list.length) {
        this.list.pop()["delete"]();
      }
      return this;
    };

    return ProductList;

  })();

  Product = (function() {

    function Product(container) {
      this.container = container;
      this.teaser = this.container.find(".product_teaser").first();
      this.detail = this.container.find(".product_detail").first();
      this.slider = this.container.find(".product_slide").first();
      this.images = this.container.find(".product_slide_figure img");
      this.hover = this.container.find(".product_teaser_hover .wrapper").first();
      this.swipe = null;
      this.detail.detach();
      this.detail.show();
      this.row = 0;
      this.url = this.teaser.attr("href").replace(reClean, "");
      this;
    }

    Product.prototype.select = function(selected) {
      var img, src, _i, _len, _ref1;
      this.selected = selected != null ? selected : true;
      if (this.selected) {
        _ref1 = this.images;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          img = _ref1[_i];
          src = img.getAttribute("data-src");
          img.removeAttribute("data-src");
          if (src != null) {
            img.src = src;
          }
        }
        if (!this.swipe && this.images.length > 1) {
          this.swipe = new Swipe(this.slider[0], {
            continuous: true,
            disableScroll: false,
            stopPropagation: false,
            mouse: true
          });
        } else if (this.swipe) {
          this.swipe.setup();
        }
      } else {
        this.detail.detach();
      }
      return this;
    };

    Product.prototype.size = function(action) {
      if (action === "reset") {
        this.hover.removeAttr("style");
      } else if (action === "load") {
        this.hover_bounds = this.hover[0].getBoundingClientRect();
        this.container_bounds = this.container[0].getBoundingClientRect();
        this.list_bounds = $(".product_list")[0].getBoundingClientRect();
      } else if (action = "write") {
        this.hover.css({
          position: "absolute",
          top: Math.round((this.container_bounds.height - this.hover_bounds.height) * 0.5)
        });
        this.slider.css({
          width: this.list_bounds.width,
          height: Math.round(this.list_bounds.width * 0.5625)
        });
        this.slider.width(this.list_bounds.width);
      }
      return this.container_bounds;
    };

    Product.prototype.top = function() {
      return this.container.position().top;
    };

    Product.prototype["delete"] = function() {
      var prop;
      for (prop in this) {
        if (this[prop] instanceof jQuery) {
          this[prop].off();
        }
        if (this.hasOwnProperty(prop)) {
          this[prop] = null;
        }
      }
    };

    return Product;

  })();

  list = new ProductList($(".product_list"));

  cat = "index";

  app = $.sammy(".page_column", function() {
    this.get("/", function(context) {
      if (cat !== "index") {
        context.load("/").then(function(html) {
          wash(html);
          read(wash(html), ".page_column");
          init();
        });
      }
    });
    this.get(/products\/(.*)/, function(context) {
      var category;
      console.log(context.params);
      category = context.params["splat"][0];
      cat = category;
      return context.load("products/" + category).then(function(html) {
        wash(html);
        read(wash(html), ".page_column");
        init();
      });
    });
    this.get(/product\/(.*)/, function(context) {
      var name, target;
      name = context.params["splat"][0];
      target = $(".page_column a[href$='product/" + name + "']");
      $(".page_column .selected").removeClass("selected");
      target.addClass("selected");
      list.show(this.path);
    });
    this.get(/page\/(.*)/, function(context) {
      var name;
      name = context.params["splat"][0];
      cat = name;
      console.log(name);
      context.load("page/" + name).then(function(html) {
        list.flush();
        read(wash(html), ".page_column");
        return clean();
      });
    });
    return this.bind("event-context-after", function(event) {
      var target;
      target = $(".navigation a[href$='" + (this.path.replace(/^\/\#|^\//, "")) + "']");
      if (target.length) {
        $(".navigation .selected").removeClass("selected");
      }
      target.addClass("selected");
      $(".navigation ul").has(".selected").addClass("selected");
    });
  });

  loadLazy = function(elm, express) {
    var img, src;
    img = new Image();
    src = elm.getAttribute("data-src");
    img.onload = function() {
      if (!!elm.parent) {
        elm.parent.replaceChild(img, elm);
      } else {
        elm.src = src;
      }
      if (!express) {
        return TweenLite.from(elm, 0.25, {
          opacity: 0
        });
      }
    };
    return img.src = src;
  };

  inView = function(elm) {
    var height, rect;
    rect = elm.parentNode.getBoundingClientRect();
    height = window.innerHeight || document.documentElement.clientHeight;
    return rect.top >= 0 && rect.top <= height || rect.bottom >= 0 && rect.bottom <= height;
  };

  processScroll = function(express) {
    var img, pending, queue, _i, _j, _len, _len1;
    if (!images.length) {
      return;
    }
    queue = [];
    pending = false;
    for (_i = 0, _len = images.length; _i < _len; _i++) {
      img = images[_i];
      if (inView(img)) {
        queue.push(img);
      }
    }
    for (_j = 0, _len1 = queue.length; _j < _len1; _j++) {
      img = queue[_j];
      images.splice(images.indexOf(img), 1);
      loadLazy(img, express);
    }
  };

  init = function() {
    $(".product_slide_figure img").on("dragstart", function(event) {
      event.preventDefault();
      return false;
    });
    list.flush().load().index();
    images = $("img.lazy").toArray();
    return processScroll();
  };

  clean = function() {
    var element, insert, ref, _i, _len;
    ref = $(".html_content");
    if (ref.length) {
      for (_i = 0, _len = ref.length; _i < _len; _i++) {
        element = ref[_i];
        insert = removeToInsertLater(element);
        unstyle(element);
        element.className = element.className.replace(/html_content\s*/, "");
        insert();
      }
    }
  };

  $(document).ready(function() {
    init();
    app.run();
    return clean();
  });

  scrolling = false;

  $(window).on("scroll", function() {
    if (!scrolling) {
      scrolling = true;
      return window.requestAnimationFrame(function() {
        processScroll();
        return scrolling = false;
      });
    }
  });

  resizing = false;

  $(window).on("resize", function() {
    if (!resizing) {
      resizing = true;
      return window.requestAnimationFrame(function() {
        list.index();
        processScroll();
        return resizing = false;
      });
    }
  });

  /*
      Sammy () ->
      @get '/products', () ->
        console.log "list all products"
        # $.get("/mail", { folder: this.params.folder }, self.chosenFolderData)
        return
      @get /\#\/products\/(.*)/, () ->
        console.log "list #{@params['splat']} products"
        # $.get("/mail", { folder: this.params.folder }, self.chosenFolderData)
        return
      @get /\#\/product\/(.*)/, () ->
        console.log "show product #{@params['splat']}"
        # $.get("/mail", { folder: this.params.folder }, self.chosenFolderData)
        return
      @get /\#\/(.*)/, () ->
        console.log "show other #{@params['splat']}"
        return
      @get '', () ->
        console.log "show default"
        return
    .run()
  */


}).call(this);
