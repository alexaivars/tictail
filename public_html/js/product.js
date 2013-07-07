(function() {
  var _base, _ref;

  if ((_ref = (_base = typeof exports !== "undefined" && exports !== null ? exports : this).krmg) == null) {
    _base.krmg = {};
  }

  krmg.Product = (function() {
    function Product(container) {
      this.container = container;
      this.teaser = this.container.find(".product_teaser").first();
      this.detail = this.container.find(".product_detail").first();
      this.slider = this.container.find(".product_slide").first();
      this.images = this.container.find(".product_slide_figure img");
      this.index = this.container.find(".product_slider_index").first();
      this.parent = this.container.parent();
      this.swipe = null;
      if (this.teaser.length) {
        this.detail.detach();
        this.detail.show();
        this.row = 0;
        this.url = this.teaser.attr("href").replace(krmg.RE.clean, "");
      } else {
        this.size("load");
        this.size("write");
        this.select(true);
      }
      this;
    }

    Product.prototype.select = function(selected) {
      var img, src, _i, _len, _ref1,
        _this = this;

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
        if (!this.swipe) {
          if (this.index.length && this.index.children().length > 1) {
            this.index.children()[0].className = "active";
            this.index.show();
          }
          this.swipe = new krmg.Swipe(this.slider[0], {
            continuous: true,
            disableScroll: false,
            stopPropagation: false,
            mouse: true,
            transitionEnd: function(swipe, index, slide) {
              var i;

              i = parseInt(slide.getAttribute("data-index"));
              if (_this.index.length) {
                _this.index.children().removeClass("active");
                return _this.index.children()[i].className = "active";
              }
            }
          });
        } else if (this.swipe) {
          this.swipe.setup();
        }
        if (!this.social) {
          if (window.FB != null) {
            FB.XFBML.parse(this.detail[0]);
          }
          if (window.twttr != null) {
            twttr.widgets.load();
          }
          this.social = true;
        }
      } else {
        this.detail.detach();
      }
      return this;
    };

    Product.prototype.size = function(action) {
      if (action === "reset") {

      } else if (action === "load") {
        this.parent_bounds = this.parent[0].getBoundingClientRect();
        this.bounds = this.container[0].getBoundingClientRect();
      } else if (action = "write") {
        this.slider.height(Math.round(this.parent_bounds.width * (2 / 3)));
      }
      return this.bounds;
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

}).call(this);
