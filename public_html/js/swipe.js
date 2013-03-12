(function() {

  (typeof exports !== "undefined" && exports !== null ? exports : this).Swipe = function(container, options) {
    var animate, begin, browser, delay, element, handleEvent, index, interval, isSwipe, move, next, noop, offloadFn, prev, setup, slide, slidePos, slides, speed, stop, touch, translate, width;
    if (!container) {
      return;
    }
    browser = {
      addEventListener: !!window.addEventListener,
      touch: Modernizr.touch,
      transitions: Modernizr.csstransitions
    };
    noop = function() {};
    offloadFn = function(fn) {
      return setTimeout(fn || noop, 0);
    };
    options = options || {};
    element = container.children[0];
    index = parseInt(options.startSlide, 10) || 0;
    speed = options.speed || 300;
    slides = null;
    slidePos = null;
    width = null;
    console.log("element");
    setup = function() {
      var pos, slide;
      slides = element.children;
      slidePos = new Array(slides.length);
      width = container.getBoundingClientRect().width || container.offsetWidth;
      element.style.width = (slides.length * width) + 'px';
      pos = slides.length;
      while (pos--) {
        slide = slides[pos];
        slide.style.width = width + 'px';
        slide.setAttribute('data-index', pos);
        if (browser.transitions) {
          slide.style.left = (pos * -width) + 'px';
          move(pos, (index > pos ? -width : (index < pos ? width : 0)), 0);
        }
      }
      if (!browser.transitions) {
        element.style.left = (index * -width) + 'px';
      }
      container.style.visibility = 'visible';
    };
    translate = function(_index, _dist, _speed) {
      var slide, style;
      slide = slides[_index];
      style = slide && slide.style;
      if (!style) {
        return;
      }
      style.webkitTransitionDuration = style.MozTransitionDuration = style.msTransitionDuration = style.OTransitionDuration = style.transitionDuration = _speed + 'ms';
      style.webkitTransform = "translate3d(" + _dist + "px, 0, 0) scale3d(1,1,1)";
      style.msTransform = style.MozTransform = style.OTransform = "translateX(" + _dist + "px)";
    };
    move = function(_index, _dist, _speed) {
      translate(_index, _dist, _speed);
      return slidePos[_index] = _dist;
    };
    prev = function() {
      if (index) {
        slide(index - 1);
      } else if (options.continuous) {
        slide(slides.length - 1);
      }
    };
    next = function() {
      if (index < slides.length - 1) {
        return slide(index + 1);
      } else if (options.continuous) {
        return slide(0);
      }
    };
    slide = function(_to, _slide) {
      var diff, direction;
      if (index === _to) {
        return;
      }
      if (browser.transitions) {
        diff = Math.abs(index - _to) - 1;
        direction = Math.abs(index - _to) / (index - _to);
        while (diff--) {
          move((_to > index ? _to : index) - diff - 1, width * direction, 0);
        }
        move(index, width * direction, _speed || speed);
        move(_to, 0, _speed || speed);
      } else {
        animate(index * -width, _to * -width, _speed || speed);
      }
      index = _to;
      offloadFn(options.callback && options.callback(index, slides[index]));
    };
    animate = function(_from, _to, _speed) {
      var start, timer;
      if (!_speed) {
        element.style.left = _to + "px";
        return;
      }
      start = +(new Date);
      return timer = setInterval(function() {
        var timeElap;
        timeElap = +(new Date) - start;
        if (timeElap > _speed) {
          element.style.left = _to + "px";
          if (delay) {
            begin();
          }
          options.transitionEnd && options.transitionEnd.call(event, index, slides[index]);
          clearInterval(timer);
          return;
        }
        return element.style.left = (((_to - _from) * (Math.floor((timeElap / _speed) * 100) / 100)) + _from) + "px";
      }, 4);
    };
    delay = options.auto || 0;
    interval = null;
    begin = function() {
      interval = setTimeout(next, delay);
    };
    stop = function() {
      delay = 0;
      clearTimout(interval);
    };
    touch = Hammer(container);
    touch.on("touch dragleft swipeleft dragright swiperight release", function(event) {
      return handleEvent(event);
    });
    isSwipe = false;
    handleEvent = function(event) {
      var deltaX, isPastBounds, isValidSlide;
      event.stopPropagation();
      event.stopImmediatePropagation();
      deltaX = event.gesture.deltaX;
      switch (event.type) {
        case "touch":
          isSwipe = false;
          break;
        case "dragright":
        case "dragleft":
          event.gesture.preventDefault();
          if (!index && deltaX > 0 || index === slides.length - 1 && deltaX < 0) {
            deltaX = deltaX / (Math.abs(deltaX) / width + 1);
          }
          translate(index - 1, deltaX + slidePos[index - 1], 0);
          translate(index, deltaX + slidePos[index], 0);
          translate(index + 1, deltaX + slidePos[index + 1], 0);
          break;
        case "swiperight":
        case "swipeleft":
          event.gesture.preventDefault();
          isSwipe = true;
          break;
        case "release":
          isValidSlide = Math.abs(deltaX) > width * 0.5 || isSwipe;
          isPastBounds = !index && deltaX > 0 || index === slides.length - 1 && deltaX < 0;
          if (isValidSlide && !isPastBounds) {
            if (event.gesture.direction === "left") {
              move(index - 1, -width, 0);
              move(index, slidePos[index] - width, speed);
              move(index + 1, slidePos[index + 1] - width, speed);
              index += 1;
            } else {
              move(index + 1, width, 0);
              move(index, slidePos[index] + width, speed);
              move(index - 1, slidePos[index - 1] + width, speed);
              index += -1;
            }
          } else {
            move(index - 1, -width, speed);
            move(index, 0, speed);
            move(index + 1, width, speed);
          }
      }
    };
    if (browser.addEventListener) {
      window.addEventListener("resize", function() {
        return offloadFn(setup.call());
      });
    } else {
      window.onresize = function() {
        return setup();
      };
    }
    return setup();
  };

}).call(this);
