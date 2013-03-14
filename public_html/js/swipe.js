(function() {
  "use strict";
  var BROWSER, noop, offloadFn;

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

  noop = function() {};

  offloadFn = function(fn) {
    return setTimeout(fn || noop, 0);
  };

  BROWSER = {
    addEventListener: !!window.addEventListener,
    touch: Modernizr.touch,
    transitions: Modernizr.csstransitions
  };

  (typeof exports !== "undefined" && exports !== null ? exports : this).Swipe = (function() {

    function Swipe(container, options) {
      var api, fn,
        _this = this;
      this.container = container;
      if (!container) {
        return;
      }
      this.options = options || {};
      this.element = container.children[0];
      this.index = parseInt(options.startSlide, 10) || 0;
      this.speed = options.speed || 300;
      this.slides = null;
      this.slidePos = null;
      this.width = null;
      this.timer = null;
      this.delay = options.auto || 0;
      this.interval = null;
      this.touch = Hammer(this.container);
      this.touch.on("touch dragleft swipeleft dragright swiperight release", function(event) {
        return _this.handleEvent(event);
      });
      this.isSwipe = false;
      this.onresize = function() {
        return offloadFn(_this.setup.call(_this));
      };
      if (BROWSER.transitions) {
        fn = (function(event) {
          return _this.handleTransition(event);
        });
        this.element.addEventListener('webkitTransitionEnd', fn, false);
        this.element.addEventListener('msTransitionEnd', fn, false);
        this.element.addEventListener('oTransitionEnd', fn, false);
        this.element.addEventListener('otransitionend', fn, false);
        this.element.addEventListener('transitionend', fn, false);
      }
      if (BROWSER.addEventListener) {
        window.addEventListener("resize", this.onresize);
      } else {
        window.onresize = function() {
          return _this.onresize();
        };
      }
      this.setup();
      if (this.delay) {
        this.begin();
      }
      api = {
        setup: function() {
          _this.setup();
          return _this;
        },
        slide: function(to, speed) {
          _this.slide(to, speed);
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
        getPos: function() {
          return _this.index;
        },
        kill: function() {
          _this.teardown();
        }
      };
      api.__proto__ = this.__proto__;
      return api;
    }

    Swipe.prototype.teardown = function() {
      var pos, slide;
      this.stop();
      this.element.style.width = 'auto';
      this.element.style.left = 0;
      pos = this.slides.length;
      while (pos--) {
        slide = this.slides[pos];
        slide.style.width = '100%';
        slide.style.left = 0;
        if (BROWSER.transitions) {
          this.translate(pos, 0, 0);
        }
      }
      this.touch.off("touch dragleft swipeleft dragright swiperight release");
      if (BROWSER.addEventListener) {
        window.removeEventListener("resize", this.onresize);
      } else {
        window.onresize = null;
      }
    };

    Swipe.prototype.setup = function() {
      var pos, slide;
      this.slides = this.element.children;
      this.slidePos = new Array(this.slides.length);
      this.width = this.container.getBoundingClientRect().width || this.container.offsetWidth;
      this.element.style.width = (this.slides.length * this.width) + 'px';
      pos = this.slides.length;
      while (pos--) {
        slide = this.slides[pos];
        slide.style.width = this.width + 'px';
        slide.setAttribute('data-index', pos);
        if (BROWSER.transitions) {
          slide.style.left = (pos * -this.width) + 'px';
          this.move(pos, (this.index > pos ? -this.width : (this.index < pos ? this.width : 0)), 0);
        }
      }
      if (!BROWSER.transitions) {
        this.element.style.left = (index * -width) + 'px';
      }
      this.container.style.visibility = 'visible';
    };

    Swipe.prototype.translate = function(index, dist, speed) {
      var slide, style;
      slide = this.slides[index];
      style = slide && slide.style;
      if (!style) {
        return;
      }
      style.webkitTransitionDuration = style.MozTransitionDuration = style.msTransitionDuration = style.OTransitionDuration = style.transitionDuration = speed + 'ms';
      style.webkitTransform = "translate3d(" + dist + "px, 0, 0) scale3d(1,1,1)";
      style.msTransform = style.MozTransform = style.OTransform = "translateX(" + dist + "px)";
    };

    Swipe.prototype.move = function(index, dist, speed) {
      this.translate(index, dist, speed);
      this.slidePos[index] = dist;
    };

    Swipe.prototype.prev = function() {
      if (this.index) {
        this.slide(this.index - 1);
      } else if (this.options.continuous) {
        this.slide(this.slides.length - 1);
      }
    };

    Swipe.prototype.next = function() {
      if (this.index < this.slides.length - 1) {
        this.slide(this.index + 1);
      } else if (this.options.continuous) {
        this.slide(0);
      }
    };

    Swipe.prototype.slide = function(to, speed) {
      var diff, direction;
      if (this.index === to) {
        return;
      }
      if (BROWSER.transitions) {
        diff = Math.abs(this.index - to) - 1;
        direction = Math.abs(this.index - to) / (this.index - to);
        while (diff--) {
          this.move((to > this.index ? to : this.index) - diff - 1, this.width * direction, 0);
        }
        this.move(this.index, this.width * direction, speed || this.speed);
        this.move(to, 0, speed || this.speed);
      } else {
        this.animate(this.index * -this.width, to * -this.width, speed || this.speed);
      }
      this.index = to;
      offloadFn(this.options.callback && this.options.callback(this.index, this.slides[this.index]));
    };

    Swipe.prototype.animate = function(from, to, speed) {
      var start,
        _this = this;
      if (!speed) {
        this.element.style.left = to + "px";
        return;
      }
      start = +(new Date);
      this.timer = setInterval(function() {
        var timeElap;
        timeElap = +(new Date) - start;
        if (timeElap > speed) {
          _this.element.style.left = to + "px";
          if (_this.delay) {
            _this.begin();
          }
          _this.options.transitionEnd && _this.options.transitionEnd.call(event, _this.index, _this.slides[_this.index]);
          clearInterval(_this.timer);
          return;
        }
        return _this.element.style.left = (((to - from) * (Math.floor((timeElap / speed) * 100) / 100)) + from) + "px";
      }, 4);
    };

    Swipe.prototype.begin = function() {
      var fn,
        _this = this;
      fn = function() {
        return _this.next();
      };
      this.interval = setTimeout(fn, this.delay);
    };

    Swipe.prototype.stop = function() {
      this.delay = 0;
      clearTimeout(this.interval);
    };

    Swipe.prototype.handleTransition = function(event) {
      var fn,
        _this = this;
      if (parseInt(event.target.getAttribute('data-index'), 10) === this.index) {
        fn = function() {
          if (_this.delay) {
            return _this.begin();
          }
        };
        offloadFn(fn);
      }
    };

    Swipe.prototype.render = function() {
      if (this.mouseIsDown) {
        this.translate(this.index - 1, this.lastDelta + this.slidePos[this.index - 1], 0);
        this.translate(this.index, this.lastDelta + this.slidePos[this.index], 0);
        return this.translate(this.index + 1, this.lastDelta + this.slidePos[this.index + 1], 0);
      }
    };

    Swipe.prototype.handleEvent = function(event) {
      var deltaX, isPastBounds, isValidSlide,
        _this = this;
      event.stopPropagation();
      event.stopImmediatePropagation();
      deltaX = event.gesture.deltaX;
      switch (event.type) {
        case "touch":
          clearTimeout(this.interval);
          this.mouseIsDown = true;
          this.isSwipe = false;
          break;
        case "dragright":
        case "dragleft":
          event.gesture.preventDefault();
          if (!this.index && deltaX > 0 || this.index === this.slides.length - 1 && deltaX < 0) {
            deltaX = deltaX / (Math.abs(deltaX) / this.width + 1);
          }
          this.lastDelta = deltaX;
          requestAnimationFrame(function() {
            return _this.render();
          });
          break;
        case "swiperight":
        case "swipeleft":
          event.gesture.preventDefault();
          this.mouseIsDown = false;
          this.isSwipe = true;
          break;
        case "release":
          this.mouseIsDown = false;
          isValidSlide = Math.abs(deltaX) > this.width * 0.5 || this.isSwipe;
          isPastBounds = !this.index && deltaX > 0 || this.index === this.slides.length - 1 && deltaX < 0;
          if (isValidSlide && !isPastBounds) {
            if (event.gesture.direction === "left") {
              this.move(this.index - 1, -this.width, 0);
              this.move(this.index, this.slidePos[this.index] - this.width, this.speed);
              this.move(this.index + 1, this.slidePos[this.index + 1] - this.width, this.speed);
              this.index += 1;
            } else {
              this.move(this.index + 1, this.width, 0);
              this.move(this.index, this.slidePos[this.index] + this.width, this.speed);
              this.move(this.index - 1, this.slidePos[this.index - 1] + this.width, this.speed);
              this.index += -1;
            }
          } else {
            this.move(this.index - 1, -this.width, this.speed);
            this.move(this.index, 0, this.speed);
            this.move(this.index + 1, this.width, this.speed);
          }
      }
    };

    return Swipe;

  })();

}).call(this);
