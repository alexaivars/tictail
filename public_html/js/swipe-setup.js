(function() {

  (typeof exports !== "undefined" && exports !== null ? exports : this).SwipeManager = (function() {

    function SwipeManager(container) {
      var _this = this;
      this.container = container;
      this.container = $(this.container);
      this.images = this.container.find("img");
      this.prime = this.images.first();
      this.slides = this.container.children().first().children();
      if (!this.prime.width()) {
        this.prime.one("load", function() {
          return _this.init();
        });
      } else {
        this.init();
      }
      return;
    }

    SwipeManager.prototype.init = function() {
      var elm, _i, _len, _ref,
        _this = this;
      this.width = this.prime.width();
      this.height = this.prime.height();
      this.prime.css({
        display: "block"
      });
      this.style = {
        display: "block",
        position: "relative",
        overflow: "hidden",
        width: "" + this.width + "px",
        height: "" + this.height + "px",
        background: "blue"
      };
      _ref = this.slides;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        elm = _ref[_i];
        elm._jq = $(elm);
        elm._img = elm._jq.find("img").first();
        if (elm._img.width() === 0) {
          elm._img[0]._pointer = elm;
          elm._img.one("load", function(event) {
            var obj;
            obj = event.target._pointer;
            obj._width = obj._img.width();
            obj._height = obj._img.height();
            event.target._pointer = void 0;
            console.log("center");
            return _this.center();
          });
        }
        elm._width = elm._img.width();
        elm._height = elm._img.height();
      }
      this.center();
    };

    SwipeManager.prototype.center = function() {
      var elm, _i, _len, _ref;
      _ref = this.slides;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        elm = _ref[_i];
        elm._jq.css(this.style);
        elm._img.css({
          marginTop: "" + (Math.round((this.height - elm._height) * 0.5)) + "px",
          marginLeft: "" + (Math.round((this.width - elm._width) * 0.5)) + "px"
        });
      }
    };

    return SwipeManager;

  })();

}).call(this);
