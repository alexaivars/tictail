(function() {
  var _base, _ref;

  if ((_ref = (_base = typeof exports !== "undefined" && exports !== null ? exports : this).krmg) == null) {
    _base.krmg = {};
  }

  krmg.SlideMenu = (function() {

    function SlideMenu(container) {
      var _this = this;
      this.container = container;
      this.menu = $('.page_menu').first();
      this.tt = $('#tt_colophon').first();
      this.content = [this.menu, this.container];
      if (this.tt.length) {
        this.content.push(this.tt);
      }
      this.touch = Hammer(this.container);
      this.touch.on("dragleft dragright swipeleft swiperight release dragup dragdown", function(event) {
        return _this.touchHandler(event);
      });
      this.navigation = this.container.find(".page_navigation").first();
      this.width = 256;
      this.close();
      Hammer($("[data-action=menu-toggle]").first()).on("tap", function(event) {
        return _this.actionHandler(event);
      });
      document.getElementById("tictail_search_box").disabled = true;
      $(window).on("resize", function() {
        return _this.resize();
      });
      this.resize();
      return;
    }

    SlideMenu.prototype.actionHandler = function(event) {
      event.stopPropagation();
      event.preventDefault();
      if (this.state === "open") {
        return this.close();
      } else {
        return this.open();
      }
    };

    SlideMenu.prototype.touchHandler = function(event) {
      var x;
      switch (event.type) {
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
          if (this.state === "open") {
            x = Math.max(0, Math.min(this.width, this.width + event.gesture.deltaX));
          } else {
            x = Math.max(0, Math.min(this.width, event.gesture.deltaX));
          }
          TweenLite.set(this.content, {
            x: x,
            overwrite: true
          });
          break;
        case "swiperight":
          event.preventDefault();
          this.open();
          break;
        case "swipeleft":
          event.preventDefault();
          this.close();
          break;
        case "release":
          event.preventDefault();
          if (this.change) {
            if (Math.abs(event.gesture.deltaX) > this.width * 0.5) {
              if (this.state === "open") {
                this.close();
              } else {
                this.open();
              }
            } else {
              if (this.state === "open") {
                this.open();
              } else {
                this.close();
              }
            }
          }
          this.ignore = false;
          this.change = false;
      }
    };

    SlideMenu.prototype.resize = function() {
      this.navigation.css({
        minHeight: "auto"
      });
      if (this.container.height() < $(window).height()) {
        this.navigation.css({
          minHeight: $(window).height()
        });
      }
      return this;
    };

    SlideMenu.prototype.open = function(fn) {
      var _this = this;
      return TweenLite.to(this.content, 0.25, {
        x: this.width,
        overwrite: true,
        onComplete: function() {
          _this.state = "open";
          console.log("open");
          return setTimeout(function() {
            return document.getElementById("tictail_search_box").disabled = false;
          }, 400);
        }
      });
    };

    SlideMenu.prototype.close = function(fn) {
      var _this = this;
      console.log(fn);
      return TweenLite.to(this.content, 0.25, {
        x: 0,
        overwrite: true,
        onComplete: function() {
          _this.state = "closed";
          return document.getElementById("tictail_search_box").disabled = true;
        }
      });
    };

    return SlideMenu;

  })();

}).call(this);
