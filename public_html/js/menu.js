(function() {
  var _base, _ref;

  if ((_ref = (_base = typeof exports !== "undefined" && exports !== null ? exports : this).krmg) == null) {
    _base.krmg = {};
  }

  krmg.SlideMenu = (function() {

    function SlideMenu(container) {
      var _this = this;
      this.container = container;
      this.touch = Hammer(this.container);
      this.touch.on("touch dragleft dragright swipeleft swiperight release", function(event) {
        return _this.touchHandler(event);
      });
      this.navigation = this.container.find(".page_navigation").first();
      this.width = 200;
      this.left = 0;
      this.setOffset(this.left);
      Hammer($("[data-action=menu-toggle]").first()).on("tap", function(event) {
        return _this.actionHandler(event);
      });
      $(window).on("resize", function() {
        return _this.resize();
      });
      this.resize();
      return;
    }

    SlideMenu.prototype.actionHandler = function(event) {
      var _this = this;
      event.preventDefault();
      event.gesture.preventDefault();
      return TweenLite.to(this, 0.25, {
        left: (this.left > 0 ? 0 : this.width),
        onUpdate: function() {
          return _this.setOffset(_this.left);
        }
      });
    };

    SlideMenu.prototype.touchHandler = function(event) {
      event.preventDefault();
      switch (event.type) {
        case "touch":
          this.delta = this.dragX;
          break;
        case "dragright":
        case "dragleft":
          event.gesture.preventDefault();
          this.setOffset(Math.max(0, Math.min(this.width, event.gesture.deltaX + this.delta)));
          break;
        case "swiperight":
          this.setOffset(this.width, true);
          break;
        case "swipeleft":
          this.setOffset(0, true);
          break;
        case "release":
          if (this.dragX > this.width * 0.5) {
            this.setOffset(this.width, true);
          } else {
            this.setOffset(0, true);
          }
      }
    };

    SlideMenu.prototype.resize = function() {
      this.navigation.css({
        minHeight: Math.max(this.container.height(), $(window).height())
      });
      return this;
    };

    SlideMenu.prototype.setOffset = function(px) {
      this.dragX = px;
      this.left = px;
      if (Modernizr.csstransforms3d) {
        return this.container.css("transform", "translate3d(" + px + "px, 0, 0) scale3d(1,1,1)");
      } else if (Modernizr.csstransforms) {
        return this.container.css("transform", "translate(" + px + "px, 0)");
      } else {
        return this.container.css("left", "" + (px - this.width) + "px");
      }
    };

    return SlideMenu;

  })();

}).call(this);
