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
      this.hover = this.container.find(".product_teaser_hover .wrapper").first();
      this.swipe = null;
      this.detail.detach();
      this.detail.show();
      this.row = 0;
      this.url = this.teaser.attr("href").replace(krmg.RE.clean, "");
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
          this.swipe = new krmg.Swipe(this.slider[0], {
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

}).call(this);
