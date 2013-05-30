(function() {
  var ProductList, _base, _ref;

  ProductList = (function() {
    function ProductList() {
      this.list = [];
      this.first = [];
      this;
    }

    ProductList.prototype.show = function(url) {
      var obj, offset, product, _i, _j, _len, _len1, _ref, _ref1,
        _this = this;

      url = url.replace(krmg.RE.clean, "");
      obj = null;
      _ref = this.list;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        product = _ref[_i];
        if (product.url === url) {
          obj = product;
        }
      }
      if (!obj) {
        return false;
      }
      _ref1 = this.list;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        product = _ref1[_j];
        if (product !== obj && product.row === obj.row) {
          product.select(false);
        }
      }
      this.active = obj;
      this.insert_detail(obj, obj.row + 1);
      obj.select();
      offset = 40;
      setTimeout(function() {});
      TweenLite.to(window, 0.25, {
        scrollTo: {
          y: obj.detail.offset().top - offset,
          x: $(window).scrollLeft(),
          autoKill: false
        },
        ease: Power2.easeIn
      });
      return this;
    };

    ProductList.prototype.insert_detail = function(obj, row) {
      var detail, e, parent, target;

      if (!this.container) {
        this.container = $(".product_list");
      }
      target = null;
      detail = obj.detail[0];
      parent = obj.container.parent()[0];
      if (this.first[row]) {
        target = this.first[row].container[0];
      }
      try {
        parent.insertBefore(detail, target);
      } catch (_error) {
        e = _error;
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
          this.list.push(new krmg.Product($(child)));
        }
      }
      return this;
    };

    ProductList.prototype.index = function() {
      var obj, open, p, r, row, top, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _len5, _m, _n, _ref, _ref1, _ref2, _ref3, _ref4;

      row = top = -1;
      open = [];
      while (this.first.length) {
        this.first.pop();
      }
      _ref = this.list;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        obj = _ref[_i];
        if (obj.selected) {
          obj.select(false);
          open.push(obj);
        }
      }
      _ref1 = this.list;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        obj = _ref1[_j];
        obj.size("reset");
      }
      _ref2 = this.list;
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        obj = _ref2[_k];
        obj.size("load");
      }
      _ref3 = this.list;
      for (_l = 0, _len3 = _ref3.length; _l < _len3; _l++) {
        obj = _ref3[_l];
        obj.size("write");
      }
      _ref4 = this.list;
      for (_m = 0, _len4 = _ref4.length; _m < _len4; _m++) {
        obj = _ref4[_m];
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

  if ((_ref = (_base = typeof exports !== "undefined" && exports !== null ? exports : this).krmg) == null) {
    _base.krmg = {};
  }

  krmg.ProductList = new ProductList();

}).call(this);
