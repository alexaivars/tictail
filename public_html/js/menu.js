(function() {
  var _base, _ref;

  if ((_ref = (_base = typeof exports !== "undefined" && exports !== null ? exports : this).krmg) == null) {
    _base.krmg = {};
  }

  krmg.SlideMenu = (function() {
    SlideMenu.IS_ACTIVE = "open";

    SlideMenu.IS_INACTIVE = "close";

    function SlideMenu(menu, content, options) {
      var _this = this;

      this.menu = menu;
      this.content = content;
      this.options = options != null ? options : {};
      this.animate = this.content;
      this.animate.push(this.menu);
      this.touch = Hammer(window);
      this.touch.on("dragstart dragleft dragright swipeleft swiperight release dragup dragdown", function(event) {
        return _this.touchHandler(event);
      });
      this.width = this.menu.offsetWidth;
      this.close();
      return;
    }

    SlideMenu.prototype.actionHandler = function(event) {
      event.stopPropagation();
      event.preventDefault();
      if (this.state === SlideMenu.IS_ACTIVE) {
        return this.close();
      } else {
        return this.open();
      }
    };

    SlideMenu.prototype.touchHandler = function(event) {
      var limit, x;

      if (event.result && event.result instanceof krmg.Swipe) {
        return;
      }
      switch (event.type) {
        case "dragstart":
          if (event.target && event.target.className === "product_slide_figure") {
            this.ignore = true;
          }
          break;
        case "dragup":
        case "dragdown":
          if (this.change) {
            event.preventDefault();
            event.gesture.preventDefault();
          } else {
            this.ignore = true;
          }
          break;
        case "dragright":
        case "dragleft":
          if (this.ignore) {
            return;
          }
          this.change = true;
          event.preventDefault();
          event.gesture.preventDefault();
          limit = 20;
          if (Math.abs(event.gesture.deltaX) > limit) {
            if (this.state === "open") {
              x = Math.max(0, Math.min(this.width, this.width + event.gesture.deltaX - limit));
            } else {
              x = Math.max(0, Math.min(this.width, event.gesture.deltaX - limit));
            }
            TweenLite.set(this.content, {
              x: x,
              overwrite: true
            });
          }
          break;
        case "swiperight":
          if (this.ignore) {
            return;
          }
          event.preventDefault();
          this.open();
          break;
        case "swipeleft":
          if (this.ignore) {
            return;
          }
          event.preventDefault();
          this.close();
          break;
        case "release":
          event.preventDefault();
          if (this.change) {
            if (this.state === SlideMenu.IS_ACTIVE) {
              if (Math.abs(event.gesture.deltaX) > this.width * 0.5 && event.gesture.direction === Hammer.DIRECTION_LEFT) {
                this.close();
              } else {
                this.open();
              }
            } else {
              if (Math.abs(event.gesture.deltaX) > this.width * 0.5 && event.gesture.direction === Hammer.DIRECTION_RIGHT) {
                this.open();
              } else {
                this.close();
              }
            }
          }
          this.ignore = false;
          this.change = false;
      }
      return false;
    };

    SlideMenu.prototype.open = function() {
      var _this = this;

      TweenLite.to(this.animate, 0.25, {
        x: this.width,
        overwrite: true,
        onComplete: function() {
          _this.state = SlideMenu.IS_ACTIVE;
          if (_this.options.onOpened) {
            return _this.options.onOpened.call();
          }
        }
      });
      return this;
    };

    SlideMenu.prototype.close = function(fn) {
      var _this = this;

      TweenLite.to(this.animate, 0.25, {
        x: 0,
        clearProps: "x",
        overwrite: true,
        onComplete: function() {
          _this.state = SlideMenu.IS_INACTIVE;
          if (_this.options.onClosed) {
            _this.options.onClosed.call();
          }
        }
      });
      return this;
    };

    SlideMenu.prototype.toggle = function() {
      if (this.options.onToggle) {
        this.options.onToggle.call();
      }
      if (this.state === SlideMenu.IS_ACTIVE) {
        this.close();
      } else {
        this.open();
      }
      return this;
    };

    return SlideMenu;

  })();

}).call(this);
