(function() {
  var _base, _ref;

  if ((_ref = (_base = typeof exports !== "undefined" && exports !== null ? exports : this).krmg) == null) {
    _base.krmg = {};
  }

  krmg.Swipe = (function() {
    function Swipe(container, options) {
      var api,
        _this = this;

      this.container = container;
      this.options = options != null ? options : {};
      this.wrapper = this.container.children[0];
      this.index = 0;
      this.speed = 400;
      this.setup();
      api = {
        setup: function() {
          _this.setup();
          return _this;
        },
        prev: function() {
          _this.stop();
          _this.prev();
          return _this;
        },
        next: function() {
          _this.stop();
          _this.next();
          return _this;
        },
        kill: function() {
          _this.teardown();
        }
      };
      api.__proto__ = this.__proto__;
      return api;
    }

    Swipe.prototype.stop = function() {
      return this;
    };

    Swipe.prototype.prev = function() {
      TweenLite.set(this.wrapper, {
        x: "-=" + this.width
      });
      this.index = this.circle(this.index - 1);
      this.layout();
      this.move();
      return this;
    };

    Swipe.prototype.next = function() {
      TweenLite.set(this.wrapper, {
        x: "+=" + this.width
      });
      this.index = this.circle(this.index + 1);
      this.layout();
      this.move();
      return this;
    };

    Swipe.prototype.circle = function(num) {
      return (this.length + (num % this.length)) % this.length;
    };

    Swipe.prototype.teardown = function() {
      var node, _i, _len, _ref1;

      if (this.touch) {
        this.touch.off();
      }
      _ref1 = this.slides;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        node = _ref1[_i];
        node.removeAttribute("style");
      }
      this.wrapper.removeAttribute("style");
      this.container.removeAttribute("style");
      this.index = 0;
      this.slides = [];
    };

    Swipe.prototype.setup = function() {
      var child, index, node, point, slide, _i, _j, _k, _len, _len1, _len2, _ref1, _ref2, _ref3,
        _this = this;

      this.length = this.wrapper.children.length;
      point = 0;
      _ref1 = this.wrapper.children;
      for (index = _i = 0, _len = _ref1.length; _i < _len; index = ++_i) {
        child = _ref1[index];
        child.setAttribute("data-index", index);
      }
      if (this.length > 1) {
        while (this.length < 5) {
          node = this.wrapper.children[point].cloneNode(true);
          point++;
          this.wrapper.appendChild(node);
          this.length++;
        }
      }
      this.slides = [];
      this.direction = 0;
      _ref2 = this.wrapper.children;
      for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
        slide = _ref2[_j];
        this.slides.push(slide);
      }
      this.bounds = this.container.getBoundingClientRect();
      this.width = this.bounds.width | this.bounds.right - this.bounds.left;
      this.height = this.bounds.height | this.bounds.bottom - this.bounds.top;
      this.wrapper.style.height = "" + this.height + "px";
      this.wrapper.style.width = "" + this.width + "px";
      this.wrapper.style.position = "absolute";
      if (!this.touch && this.length > 1) {
        this.touch = Hammer(this.container);
        this.touch.on("tap swipeleft dragleft swiperight dragright touch release", function(event) {
          return _this.dragHandler(event);
        });
        this.touch.on("click mousemove", function(event) {
          var x, y;

          y = event.pageY - _this.bounds.top;
          x = event.pageX - _this.bounds.left;
          if (_this.direction !== 1 && x > _this.width * 0.5) {
            _this.container.setAttribute("data-direction", "next");
            _this.direction = 1;
          } else if (_this.direction !== -1 && x < _this.width * 0.5) {
            _this.container.setAttribute("data-direction", "prev");
            _this.direction = -1;
          }
          if (event.type === "click") {
            if (_this.direction === 1) {
              _this.next();
            }
            if (_this.direction === -1) {
              return _this.prev();
            }
          }
        });
        this.touch.on("click", function(event) {
          return event.preventDefault();
        });
        this.touch.on("dragstart", function(event) {
          if (event.target.tagName.toLowerCase() === "img") {
            return event.preventDefault();
          }
        });
        if (this.options.mouse) {
          this.touch.on("click mousemove", function(event) {
            var x, y;

            y = event.pageY - _this.bounds.top;
            x = event.pageX - _this.bounds.left;
            if (_this.direction !== 1 && x > _this.width * 0.5) {
              _this.container.setAttribute("data-direction", "next");
              return _this.direction = 1;
            } else if (_this.direction !== -1 && x < _this.width * 0.5) {
              _this.container.setAttribute("data-direction", "prev");
              return _this.direction = -1;
            }
          });
        }
      }
      _ref3 = this.slides;
      for (_k = 0, _len2 = _ref3.length; _k < _len2; _k++) {
        node = _ref3[_k];
        node.style.width = "" + this.width + "px";
        node.style.height = "" + this.height + "px";
      }
      this.layout();
      return this;
    };

    Swipe.prototype.layout = function() {
      var node, pos, _i, _len, _ref1;

      _ref1 = this.slides;
      for (pos = _i = 0, _len = _ref1.length; _i < _len; pos = ++_i) {
        node = _ref1[pos];
        if (pos === this.index) {
          node.style.left = 0;
          node.style.visibility = "visible";
        } else if (pos === this.circle(this.index + 1)) {
          node.style.left = "" + (this.width * 1) + "px";
          node.style.visibility = "visible";
        } else if (pos === this.circle(this.index + 2)) {
          node.style.left = "" + (this.width * 2) + "px";
          node.style.visibility = "visible";
        } else if (pos === this.circle(this.index - 1)) {
          node.style.left = "" + (this.width * -1) + "px";
          node.style.visibility = "visible";
        } else if (pos === this.circle(this.index - 2)) {
          node.style.left = "" + (this.width * -2) + "px";
          node.style.visibility = "visible";
        } else {
          node.style.visibility = "hidden";
        }
      }
      return this;
    };

    Swipe.prototype.dragHandler = function(event) {
      var dist;

      if (this.offset == null) {
        this.offset = 0;
      }
      dist = Math.min(this.width, Math.max(-this.width, event.gesture.deltaX));
      switch (event.type) {
        case "tap":
          if (this.options.onClick) {
            this.options.onClick(event, this.index, this.slides[this.index]);
          }
          break;
        case "touch":
          if (this.t) {
            this.offset = Math.round(this.t.target._gsTransform.x);
            this.t = null;
          } else {
            this.offset = 0;
          }
          TweenLite.killTweensOf(this.wrapper);
          break;
        case "dragleft":
        case "dragright":
          event.gesture.preventDefault();
          TweenLite.set(this.wrapper, {
            x: dist,
            overwrite: true
          });
          break;
        case "swipeleft":
          event.gesture.preventDefault();
          this.pendingTouch = "next";
          break;
        case "swiperight":
          event.gesture.preventDefault();
          this.pendingTouch = "prev";
          break;
        case "release":
          if (this.pendingTouch === "prev" || dist > Math.min(250, this.width * 0.5)) {
            this.prev();
          } else if (this.pendingTouch === "next" || dist < Math.max(-250, this.width * -0.5)) {
            this.next();
          } else {
            this.move(true);
          }
          this.pendingTouch = null;
      }
      return this;
    };

    Swipe.prototype.move = function(quiet) {
      var _this = this;

      return this.t = TweenLite.to(this.wrapper, this.speed / 1000, {
        x: 0,
        overwrite: true,
        clearProps: "x",
        onComplete: function() {
          if (_this.options.transitionEnd && !quiet) {
            requestAnimationFrame(function() {
              if (_this.options.transitionEnd && !quiet) {
                return _this.options.transitionEnd(_this, _this.index, _this.slides[_this.index]);
              }
            });
          }
          _this.offset = 0;
          return _this.t = null;
        }
      });
    };

    return Swipe;

  })();

}).call(this);
